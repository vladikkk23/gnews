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
    private var navViewModel: NavigationViewModel?
    private var newsVC: NewsViewController?
    
    // MARK: - Initializers
    override init() {
        newsVC = NewsViewController()
        navViewModel = NavigationViewModel(withViewController: newsVC!)
        navViewModel!.rootVC = newsVC
        navViewModel!.didStartNavigationTapped()
    }
    
    // MARK: - Methods
    func setWindow(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        window.makeKeyAndVisible()
        
        subscribeToChanges()
    }
    
    private func subscribeToChanges() {
        navViewModel!.isViewActive
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.showSearchView()
            })
            .disposed(by: disposeBag)
    }
    
    private func showNewsView() {
        removeChildCoordinators()
        
        let newCoordinator = NewsCoordinator()
        start(coordinator: newCoordinator)
        
        ViewControllerUtils.setRootViewController(window: window,
                                                  viewController: newCoordinator.navigationController,
                                                  withAnimation: true)
    }
    
    private func showSearchView() {
        removeChildCoordinators()
        
        let newCoordinator = SearchViewCoordinator()
        start(coordinator: newCoordinator)
        
        ViewControllerUtils.setRootViewController(window: window,
                                                  viewController: newCoordinator.navigationController,
                                                  withAnimation: true)
    }
}
