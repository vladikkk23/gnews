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
    var viewModel: SearchViewModel! {
        didSet {
            bindButtons()
        }
    }
    
    var navigationViewModel: NavigationViewModel! {
        didSet {
            bindNavigationData()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // UI
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
    
    private func bindButtons() {
        dateCell.button.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.isDateSelected.onNext(true)
            }
            .disposed(by: disposeBag)
        
        relevanceCell.button.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.isRelevanceSelected.onNext(true)
            }
            .disposed(by: disposeBag)
        
        viewModel.isDateSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] toogle in
                guard let self = self else { return }
                
                if !toogle {
                    self.dateCell.selectionIndicator.layer.borderColor = UIColor.clear.cgColor
                    self.dateCell.selectionIndicator.backgroundColor = .lightGray
                    self.dateCell.selectionIndicator.alpha = 0.25
                } else {
                    self.dateCell.selectionIndicator.layer.borderColor = UIColor.orange.cgColor
                    self.dateCell.selectionIndicator.backgroundColor = .white
                    self.dateCell.selectionIndicator.alpha = 1
                    
                    self.viewModel.isRelevanceSelected.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isRelevanceSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] toogle in
                guard let self = self else { return }
                
                if !toogle {
                    self.relevanceCell.selectionIndicator.layer.borderColor = UIColor.clear.cgColor
                    self.relevanceCell.selectionIndicator.backgroundColor = .lightGray
                    self.relevanceCell.selectionIndicator.alpha = 0.25
                } else {
                    self.relevanceCell.selectionIndicator.layer.borderColor = UIColor.orange.cgColor
                    self.relevanceCell.selectionIndicator.backgroundColor = .white
                    self.relevanceCell.selectionIndicator.alpha = 1
                    
                    self.viewModel.isDateSelected.onNext(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigationData() {
        navigationViewModel.isSortViewActive
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] toogle in
                guard let self = self else { return }
                
                self.shift(duration: TimeInterval(1), toogle: toogle)
                
                if !toogle {
                    self.viewModel.fetchItems()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Extension to animate view toogle event
extension SortSelectionView {
    func shift(duration: TimeInterval, toogle: Bool) {
        UIView.animate(withDuration: duration) {
            if toogle {
                self.frame = self.frame.offsetBy(dx: 0, dy: -self.frame.size.height)
            } else {
                self.frame = self.frame.offsetBy(dx: 0, dy: self.frame.size.height)
            }
        }
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
