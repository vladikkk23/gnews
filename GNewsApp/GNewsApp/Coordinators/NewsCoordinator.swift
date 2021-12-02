//
//  NewsCoordinator.swift
//  GNewsApp
//
//  Created by vladikkk on 01/12/2021.
//

import UIKit

class NewsCoordinator: BaseCoordinator {
    // MARK: - Properties
    var viewModel = NavigationViewModel(withViewController: NewsViewController())
    
    // MARK: - Methods
    override func start() {
        guard let rootVC = viewModel.rootVC as? NewsViewController else { return }
        
        let newVM = ArticleCellViewModel()
        rootVC.viewModel = newVM
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [rootVC]
    }
}

class SearchViewCoordinator: BaseCoordinator {
    // MARK: - Properties
    var viewModel = NavigationViewModel(withViewController: SearchViewController())
    
    // MARK: - Methods
    override func start() {
        guard let rootVC = viewModel.rootVC as? SearchViewController else { return }
        
        let newVM = ArticleCellViewModel()
        rootVC.viewModel = newVM
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [rootVC]
    }
}
