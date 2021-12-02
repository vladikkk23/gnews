//
//  SearchNavView.swift
//  GNewsApp
//
//  Created by vladikkk on 01/12/2021.
//

import UIKit

class SearchNavigationView: UIView {
    // MARK: - Propeties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .orange
        label.backgroundColor = .orange
        return label
    }()
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
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
        titleLabel.text = "Logo"
        titleLabel.font = UIFont(name: "Avenir-BlackOblique", size: 30)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.addSubview(titleLabel)
        self.addSubview(searchView)
        
        setupSearchViewLayout()
        setupTitleLabelLayout()
    }
    
    private func setupTitleLabelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupSearchViewLayout() {
        NSLayoutConstraint.activate([
            searchView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            searchView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            searchView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            searchView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9)
        ])
    }
}
