//
//  SecondaryFiltersView.swift
//  GNewsApp
//
//  Created by vladikkk on 07/12/2021.
//

import UIKit

class SecondaryFiltersView: UIView {
    // MARK: - Properties
    lazy var navigationView: FiltersNavigationView = {
        let view = FiltersNavigationView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Search in"
        lbl.font = UIFont(name: "Avenir-Black", size: 20)
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var contentSelectionView: FiltersContentSelectionView = {
        let view = FiltersContentSelectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var applyButton: CustomRoundedButton = {
        let view = CustomRoundedButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "Apply filter"
        view.backgroundColor = .orange
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        setupNavigationViewLayout()
        setupTitleLabelLayout()
        setupContentSelectionView()
        setupApplyButtonLayout()
    }
    
    private func setupNavigationViewLayout() {
        addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: self.topAnchor),
            navigationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            navigationView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12),
            navigationView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupTitleLabelLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05)
        ])
    }
    
    private func setupContentSelectionView() {
        addSubview(contentSelectionView)
        
        NSLayoutConstraint.activate([
            contentSelectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentSelectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentSelectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            contentSelectionView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupApplyButtonLayout() {
        addSubview(applyButton)
        
        NSLayoutConstraint.activate([
            applyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            applyButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            applyButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.075),
            applyButton.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}
