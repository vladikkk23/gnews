//
//  FiltersNavigationView.swift
//  GNewsApp
//
//  Created by vladikkk on 05/12/2021.
//

import UIKit
import RxSwift

class FiltersNavigationView: UIView {
    // MARK: - Propeties
    var viewModel: SearchViewModel! {
        didSet {
            bindData()
        }
    }
    
    var navigationViewModel: NavigationViewModel! {
        didSet {
            bindNavigationData()
        }
    }
    
    private var disposeBag = DisposeBag()
    
    // UI
    lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.imageView?.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .orange
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .orange
        label.text = "Logo"
        label.font = UIFont(name: "Avenir-BlackOblique", size: 30)
        return label
    }()
    
    lazy var clearButton: ClearButton = {
        let view = ClearButton()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        setupTitleLabelLayout()
        setupBackButtonLayout()
        setupClearButtonLayout()
    }
    
    private func setupBackButtonLayout() {
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            backButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
//            backButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            
            // Set button image constraints
            backButton.imageView!.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            backButton.imageView!.heightAnchor.constraint(equalTo: backButton.heightAnchor, multiplier: 0.5),
            backButton.imageView!.widthAnchor.constraint(equalTo: backButton.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupTitleLabelLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75)
        ])
    }
    
    private func setupClearButtonLayout() {
        addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            clearButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            clearButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor, constant: 5),
            clearButton.heightAnchor.constraint(equalTo: self.titleLabel.heightAnchor),
            clearButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.22)
        ])
    }
}

// MARK: - Bind data
extension FiltersNavigationView {
    private func bindData() {
        clearButton.button.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.clearFilters.onNext(())
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNavigationData() {
        backButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.navigationViewModel.isFiltersViewActive.onNext(false)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Clear Button
class ClearButton: UIView {
    // MARK: Properties
    lazy var button: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Clear"
        lbl.font = UIFont(name: "Avenir-Heavy", size: 15)
        lbl.textColor = .orange
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "trash")
        imageView.tintColor = .orange
        return imageView
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
        setupImageLayout()
        setupTitleLabelLayout()
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
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func setupImageLayout() {
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            image.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
    }
}
