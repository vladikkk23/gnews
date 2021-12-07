//
//  SortSelectionView.swift
//  GNewsApp
//
//  Created by vladikkk on 05/12/2021.
//

import UIKit
import RxSwift

// MARK: - SortSelectionView
class SortSelectionView: UIView {
    // MARK: - Propeties
    lazy var sortByCell: SortSelectionViewCell = {
        let view = SortSelectionViewCell()
        view.topBorderView.isHidden = true
        view.titleLabel.text = "Sort by"
        view.titleLabel.font = UIFont(name: "Avenir-Black", size: 15)
        view.selectionIndicator.isHidden = true
        return view
    }()
    
    lazy var dateCell: SortSelectionViewCell = {
        let view = SortSelectionViewCell()
        view.titleLabel.text = "Upload date"
        view.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        return view
    }()
    
    lazy var relevanceCell: SortSelectionViewCell = {
        let view = SortSelectionViewCell()
        view.titleLabel.text = "Relevance"
        view.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        return view
    }()
    
    lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        buttonsStack.addArrangedSubview(sortByCell)
        buttonsStack.addArrangedSubview(dateCell)
        buttonsStack.addArrangedSubview(relevanceCell)
        
        addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            sortByCell.widthAnchor.constraint(equalTo: self.widthAnchor),
            dateCell.widthAnchor.constraint(equalTo: self.widthAnchor),
            relevanceCell.widthAnchor.constraint(equalTo: self.widthAnchor),
            buttonsStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonsStack.topAnchor.constraint(equalTo: self.topAnchor),
            buttonsStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9)
        ])
    }
}

// MARK: - SortSelectionViewCell
internal class SortSelectionViewCell: UIView {
    // MARK: - Propeties
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var topBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 0.25
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var selectionIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 0.25
        view.layer.borderWidth = 7.5
        view.layer.borderColor = UIColor.clear.cgColor
        return view
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
        setupTopBorderViewLayout()
        setupTitleLabelLayout()
        setupSelectionIndicatorLayout()
        setupButtonLayout()
    }
    
    private func setupTopBorderViewLayout() {
        addSubview(topBorderView)
        
        NSLayoutConstraint.activate([
            topBorderView.topAnchor.constraint(equalTo: self.topAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: 1),
            topBorderView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95)
        ])
    }
    
    private func setupTitleLabelLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: topBorderView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupSelectionIndicatorLayout() {
        addSubview(selectionIndicator)
        
        NSLayoutConstraint.activate([
            selectionIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            selectionIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectionIndicator.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            selectionIndicator.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func setupButtonLayout() {
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.heightAnchor.constraint(equalTo: self.heightAnchor),
            button.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}

// MARK: - Extension to make selection indicator circle
extension SortSelectionViewCell {
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        self.selectionIndicator.layer.masksToBounds = true
        self.selectionIndicator.layer.cornerRadius = self.selectionIndicator.layer.frame.size.height / 2
    }
}
