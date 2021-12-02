//
//  BaseCoordinator.swift
//  GNewsApp
//
//  Created by vladikkk on 02/12/2021.
//

import UIKit

protocol Coordinator: AnyObject {
    // MARK: - Properties
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    // MARK: - Methods
    func start()
    func start(coordinator: Coordinator)
    func removeChildCoordinators()
    func didFinish(coordinator: Coordinator)
}

class BaseCoordinator: Coordinator {
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController = UINavigationController()
    
    // MARK: - Methods
    func start() {
        fatalError("Start method should be implemented. \n \(#function)")
    }
    
    func start(coordinator: Coordinator) {
        childCoordinators += [coordinator]
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func removeChildCoordinators() {
        childCoordinators.forEach { $0.removeChildCoordinators() }
        childCoordinators.removeAll()
    }
    
    func didFinish(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
