//
//  NavigationView.swift
//  GNewsApp
//
//  Created by vladikkk on 28/11/2021.
//

import UIKit

class NavigationView: UIView {
    // MARK: - Propeties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .orange
        return label
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
        
        setupTitleLabelLayout()
    }
    
    private func setupTitleLabelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75)
        ])
    }
}
