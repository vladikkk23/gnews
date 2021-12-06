//
//  SearchNavView.swift
//  GNewsApp
//
//  Created by vladikkk on 01/12/2021.
//

import UIKit
import RxSwift

// MARK: - SearchNavigationView
class SearchNavigationView: UIView {
    // MARK: - Propeties
    var viewModel: SearchViewModel! {
        didSet {
            searchView.viewModel = viewModel
            bindData()
        }
    }
    
    var navigationViewModel: NavigationViewModel! {
        didSet {
            bindFiltersNavigation()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // UI
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .orange
        return label
    }()
    
    lazy var searchView: SearchView = {
        let view = SearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        return view
    }()
    
    lazy var filtersTagLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "3"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 10)
        lbl.textColor = .white
        lbl.backgroundColor = .systemPink
        return lbl
    }()
    
    lazy var filtersButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "tray.full"), for: .normal)
        btn.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        btn.tintColor = .black
        return btn
    }()
    
    lazy var sortButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        btn.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        btn.tintColor = .black
        return btn
    }()
    
    lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 15
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        
        setupSearchViewLayout()
        setupTitleLabelLayout()
        setupStackViewLayout()
        setupFiltersButtonTagLabelLayout()
    }
    
    private func setupTitleLabelLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupSearchViewLayout() {
        addSubview(searchView)
        
        NSLayoutConstraint.activate([
            searchView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            searchView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65)
        ])
    }
    
    private func setupStackViewLayout() {
        buttonsStack.addArrangedSubview(searchView)
        buttonsStack.addArrangedSubview(filtersButton)
        buttonsStack.addArrangedSubview(sortButton)
        
        addSubview(buttonsStack)
        
        setupFiltersButtonSize()
        setupSortButtonSize()
        
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            buttonsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            buttonsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            buttonsStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
        ])
    }
    
    private func setupFiltersButtonSize() {
        NSLayoutConstraint.activate([
            filtersButton.heightAnchor.constraint(equalTo: searchView.heightAnchor),
            filtersButton.widthAnchor.constraint(equalTo: searchView.heightAnchor)
        ])
    }
    
    private func setupFiltersButtonTagLabelLayout() {
        addSubview(filtersTagLabel)
        
        NSLayoutConstraint.activate([
            filtersTagLabel.topAnchor.constraint(equalTo: filtersButton.topAnchor),
            filtersTagLabel.trailingAnchor.constraint(equalTo: filtersButton.trailingAnchor),
            filtersTagLabel.heightAnchor.constraint(equalTo: filtersButton.heightAnchor, multiplier: 0.35),
            filtersTagLabel.widthAnchor.constraint(equalTo: filtersButton.heightAnchor, multiplier: 0.35)
        ])
    }
    
    private func setupSortButtonSize() {
        NSLayoutConstraint.activate([
            sortButton.heightAnchor.constraint(equalTo: searchView.heightAnchor),
            sortButton.widthAnchor.constraint(equalTo: searchView.heightAnchor)
        ])
    }
}

// MARK: - SearchView Extension to bind data
extension SearchNavigationView {
    private func bindData() {
        filtersButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                self.filtersButton.isSelected.toggle()
                
                self.navigationViewModel.isFiltersViewActive.onNext(self.filtersButton.isSelected)
            }
            .disposed(by: disposeBag)
        
        navigationViewModel.isFiltersViewActive
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.filtersButton.tintColor = $0 ? .white : .black
                self.filtersButton.backgroundColor = $0 ? .orange : UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            })
            .disposed(by: disposeBag)
        
        sortButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                self.sortButton.isSelected.toggle()
                
                self.navigationViewModel.isSortViewActive.onNext(self.sortButton.isSelected)
                
            }
            .disposed(by: disposeBag)
        
        navigationViewModel.isSortViewActive
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.sortButton.tintColor = $0 ? .white : .black
                self.sortButton.backgroundColor = $0 ? .orange : UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
                
                self.viewModel.isDateSelected.onNext(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindFiltersNavigation() {
        
    }
}

// MARK: - SearchView
internal class SearchView: UIView {
    // MARK: - Propeties
    var viewModel: SearchViewModel! {
        didSet {
            bindData()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // UI
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .gray
        return imageView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search"
        textField.backgroundColor = .clear
        textField.delegate = self
        return textField
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
        setupImageLayout()
        setupTextFieldLayout()
    }
    
    private func setupImageLayout() {
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            image.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            image.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupTextFieldLayout() {
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75)
        ])
    }
}

// MARK: - SearchNavigationView Extension for circle buttons
extension SearchNavigationView {
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        searchView.layer.masksToBounds = true
        searchView.layer.cornerRadius = 20
        
        filtersButton.layer.cornerRadius = filtersButton.layer.frame.height / 2
        filtersButton.layer.masksToBounds = true
        
        sortButton.layer.cornerRadius = sortButton.layer.frame.height / 2
        sortButton.layer.masksToBounds = true
        
        filtersTagLabel.layer.cornerRadius = filtersTagLabel.layer.frame.height / 2
        filtersTagLabel.layer.masksToBounds = true
    }
}

// MARK: - SearchView Extension to hide keyboard on return
extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}

// MARK: - SearchView Extension to bind data
extension SearchView {
    private func bindData() {
        textField.rx.text
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] str in
                if let searchString = str, searchString.count > 0 {
                    self?.viewModel?.isSearching.onNext(searchString)
                }
            }
            .disposed(by: disposeBag)
    }
}
