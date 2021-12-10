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
    private var dataViewModel: DataViewModel!
    
    // MARK: - Initializers
    override init() {
        navigationViewModel = NavigationViewModel()
        dataViewModel = DataViewModel()
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
        let storage = StorageService()
        
        viewModel.isViewActive
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewType in
                guard let self = self else { return }
                
                switch viewType {
                case .news:
                    self.showNewsView()
                    // MARK: - Reset filters
                    _ = storage.flushAllFIlters()
                case .search:
                    self.showSearchView()
                default:
                    self.showInDevelopmentView()
                    // MARK: - Reset filters
                    _ = storage.flushAllFIlters()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isFiltersViewActive
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewType in
                guard let self = self else { return }
                
                switch viewType {
                case .none:
                    self.navigationViewModel.didCloseFiltersView()
                default:
                    self.showFiltersView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showNewsView() {
        removeChildCoordinators()
        
        let newsCoordinator = NewsCoordinator(navigationViewModel: navigationViewModel, viewModel: dataViewModel)
        start(coordinator: newsCoordinator)
        
        ViewControllerUtils.setRootViewController(window: window,
                                                  viewController: newsCoordinator.navigationController,
                                                  withAnimation: true)
    }
    
    private func showSearchView() {
        removeChildCoordinators()
        
        let searchCoordinator = SearchCoordinator(navigationViewModel: navigationViewModel, viewModel: dataViewModel)
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
        
        let filtersCoordinator = FiltersCoordinator(navigationViewModel: navigationViewModel, viewModel: dataViewModel)
        
        start(coordinator: filtersCoordinator)
        
        ViewControllerUtils.setRootViewController(window: window,
                                                  viewController: filtersCoordinator.navigationController,
                                                  withAnimation: true)
    }
}
