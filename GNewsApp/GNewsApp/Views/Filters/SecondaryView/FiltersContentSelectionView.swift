//
//  FiltersContentSelectionView.swift
//  GNewsApp
//
//  Created by vladikkk on 07/12/2021.
//

import UIKit

class FiltersContentSelectionView: UIView {
    // MARK: - Properties
    lazy var titleSwitchView: FilterSwitchView = {
        let view = FilterSwitchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "Title"
        return view
    }()
    
    lazy var descriptionSwitchView: FilterSwitchView = {
        let view = FilterSwitchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "Description"
        return view
    }()
    
    lazy var contentSwitchView: FilterSwitchView = {
        let view = FilterSwitchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "Content"
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
        setupTitleSwitchView()
        setupDescriptionSwitchView()
        setupContentSwitchView()
    }
    
    private func setupTitleSwitchView() {
        addSubview(titleSwitchView)
        
        NSLayoutConstraint.activate([
            titleSwitchView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleSwitchView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleSwitchView.topAnchor.constraint(equalTo: self.topAnchor),
            titleSwitchView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupDescriptionSwitchView() {
        addSubview(descriptionSwitchView)
        
        NSLayoutConstraint.activate([
            descriptionSwitchView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionSwitchView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionSwitchView.topAnchor.constraint(equalTo: self.titleSwitchView.bottomAnchor),
            descriptionSwitchView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupContentSwitchView() {
        addSubview(contentSwitchView)
        
        NSLayoutConstraint.activate([
            contentSwitchView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentSwitchView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentSwitchView.topAnchor.constraint(equalTo: self.descriptionSwitchView.bottomAnchor),
            contentSwitchView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
    }
}

internal class FilterSwitchView: UIView {
    // MARK: - Properties
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Avenir-Heavy", size: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var valueSwitch: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .orange
        return view
    }()
    
    lazy var bottomBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 0.25
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
        setupTitleLabelLayout()
        setupValueSwitchLayout()
        setupBottomBorderView()
        setupButtonLayout()
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
    
    private func setupTitleLabelLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupValueSwitchLayout() {
        addSubview(valueSwitch)
        
        NSLayoutConstraint.activate([
            valueSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            valueSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            valueSwitch.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7)
        ])
    }
    
    private func setupBottomBorderView() {
        addSubview(bottomBorderView)
        
        NSLayoutConstraint.activate([
            bottomBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomBorderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottomBorderView.heightAnchor.constraint(equalToConstant: 1),
            bottomBorderView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}
