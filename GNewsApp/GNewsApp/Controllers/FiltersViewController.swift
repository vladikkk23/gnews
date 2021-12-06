//
//  FiltersViewController.swift
//  GNewsApp
//
//  Created by vladikkk on 05/12/2021.
//

import UIKit

class FiltersViewController: UIViewController {
    // MARK: - Properties
    var viewModel: SearchViewModel! {
        didSet {
            navigationView.viewModel = viewModel
        }
    }
    
    var navigationViewModel: NavigationViewModel! {
        didSet {
            navigationView.navigationViewModel = navigationViewModel
        }
    }
    
    // UI
    lazy var navigationView: FiltersNavigationView = {
        let view = FiltersNavigationView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationViewLayout()
    }
    
    private func setupNavigationViewLayout() {
        self.view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: self.view.topAnchor),
            navigationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            navigationView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1),
            navigationView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
}
