//
//  NavigationCoordinators.swift
//  GNewsApp
//
//  Created by vladikkk on 01/12/2021.
//

import UIKit
import RxSwift

class NewsCoordinator: BaseCoordinator {
    // MARK: - Properties
    private let rootVC = NewsViewController()
    
    // MARK: - Initializers
    init(viewModel: NavigationViewModel) {
        rootVC.navigationViewModel = viewModel
    }
    
    // MARK: - Methods
    override func start() {
        let dataViewModel = NewsViewModel()
        rootVC.viewModel = dataViewModel
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [rootVC]
    }
}

class SearchCoordinator: BaseCoordinator {
    // MARK: - Properties
    private let rootVC = SearchViewController()
    
    // MARK: - Initializers
    init(viewModel: NavigationViewModel) {
        rootVC.navigationViewModel = viewModel
    }
    
    // MARK: - Methods
    override func start() {
        let dataViewModel = SearchViewModel()
        rootVC.viewModel = dataViewModel
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [rootVC]
    }
}

class InDevelopmentCoordinator: BaseCoordinator {
    // MARK: - Properties
    private let rootVC = InDevelopmentViewController()
    
    // MARK: - Initializers
    init(viewModel: NavigationViewModel) {
        rootVC.navigationViewModel = viewModel
    }
    
    // MARK: - Methods
    override func start() {
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [rootVC]
    }
}

class FiltersCoordinator: BaseCoordinator {
    // MARK: - Properties
    private let rootVC = FiltersViewController()
    
    // MARK: - Initializers
    init(viewModel: NavigationViewModel) {
        rootVC.navigationViewModel = viewModel
    }
    
    // MARK: - Methods
    override func start() {
        let dataViewModel = SearchViewModel()
        rootVC.viewModel = dataViewModel
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [rootVC]
    }
    
    func navigateTo(viewController: UIViewController) {
        let dataViewModel = SearchViewModel()
        rootVC.viewModel = dataViewModel
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [rootVC]
    }
}
