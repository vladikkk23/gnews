//
//  LoadingView.swift
//  Autoshina
//
//  Created by vladikkk on 03/09/2020.
//  Copyright © 2020 Studio Web Master. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    // MARK: - Properties
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        return view
    }()
    
    lazy var loadingIndicator: CircleLoadingIndicator = {
        let indicatorView = CircleLoadingIndicator(frame: .zero)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.trackColor = UIColor(white: 1, alpha: 0.5).cgColor
        indicatorView.lineColor = UIColor.orange.cgColor
        indicatorView.lineWidth = 5
        return indicatorView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        setupBacckgroundViewLayout()
        setupLoadingIndicatorLayout()
    }
    
    private func setupBacckgroundViewLayout() {
        addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupLoadingIndicatorLayout() {
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.065),
            loadingIndicator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.065)
        ])
        
        loadingIndicator.startLoad()
    }
}
