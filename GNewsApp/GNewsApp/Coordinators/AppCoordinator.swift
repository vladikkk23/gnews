//
//  AppCoordinator.swift
//  GNewsApp
//
//  Created by vladikkk on 01/12/2021.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var window: UIWindow!
    private var navigationViewModel: NavigationViewModel!
    private var newsViewController: UIViewController!
    
    // MARK: - Initializers
    override init() {
        navigationViewModel = NavigationViewModel()
        newsViewController = NewsViewController()
    }
    
    // MARK: - Methods
    func setWindow(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        window.makeKeyAndVisible()
        
        subscribeToChanges()
        navigationViewModel.didStartNavigationTapped()
    }
    
    private func subscribeToChanges() {
        guard let viewModel = navigationViewModel else { return }
        
        viewModel.isViewActive
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewType in
                guard let self = self else { return }
                
                switch viewType {
                case .news:
                    self.showNewsView()
                case .search:
                    self.showSearchView()
                default:
                    self.showInDevelopmentView()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isFiltersViewActive
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isActive in
                guard let self = self else { return }
                
                if isActive {
                    self.showFiltersView()
                } else {
                    self.navigationViewModel.didCloseFiltersView()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isContentFilterViewActive
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isActive in
                guard let self = self else { return }
                
                if isActive {
                    self.showFiltersView()
                } else {
                    self.showSearchView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showNewsView() {
        removeChildCoordinators()
        
        let newsCoordinator = NewsCoordinator(viewModel: navigationViewModel)
        start(coordinator: newsCoordinator)
        
        ViewControllerUtils.setRootViewController(window: window,
                                                  viewController: newsCoordinator.navigationController,
                                                  withAnimation: true)
    }
    
    private func showSearchView() {
        removeChildCoordinators()
        
        let searchCoordinator = SearchCoordinator(viewModel: navigationViewModel)
        start(coordinator: searchCoordinator)
        
        ViewControllerUtils.setRootViewController(window: window,
                                                  viewController: searchCoordinator.navigationController,
                                                  withAnimation: true)
    }
    
    private func showInDevelopmentView() {
        removeChildCoordinators()
        
        let inDevelopmentCoordinator = InDevelopmentCoordinator(viewModel: navigationViewModel)
        
        start(coordinator: inDevelopmentCoordinator)
        
        ViewControllerUtils.setRootViewController(window: window,
                                                  viewController: inDevelopmentCoordinator.navigationController,
                                                  withAnimation: true)
    }
    
    private func showFiltersView() {
        removeChildCoordinators()
        
        let filtersCoordinator = FiltersCoordinator(viewModel: navigationViewModel)
        
        start(coordinator: filtersCoordinator)
        
        ViewControllerUtils.setRootViewController(window: window,
                                                  viewController: filtersCoordinator.navigationController,
                                                  withAnimation: true)
    }
}
