//
//  SearchViewController.swift
//  GNewsApp
//
//  Created by vladikkk on 01/12/2021.
//

import UIKit
import RxSwift
import SafariServices

class SearchViewController: UIViewController {
    // MARK: - Properties
    var navigationViewModel: NavigationViewModel! {
        didSet {
            bindNavigationData()
        }
    }
    
    var viewModel: SearchViewModel! {
        didSet {
            bindData()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    lazy var navigationView: SearchNavigationView = {
        let view = SearchNavigationView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.25
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0 , height: 5)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "News"
        label.font = UIFont(name: "Avenir-Black", size: 20)
        return label
    }()
    
    lazy var articlesView: ArticlesCollectionView = {
        let view = ArticlesCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var menuView: MenuView = {
        let view = MenuView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.25
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0 , height: -5)
        return view
    }()
    
    lazy var sortSelectionView: SortSelectionView = {
        let view = SortSelectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0 , height: -5)
        view.isHidden = true
        return view
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationViewLayout()
        setupTableViewLayout()
        setupTitleLabelLayout()
        setupMenuViewLayout()
        setupSortSelectionViewLayout()
    }
    
    private func setupNavigationViewLayout() {
        self.view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: self.view.topAnchor),
            navigationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            navigationView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.175),
            navigationView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
    
    private func setupTitleLabelLayout() {
        self.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.articlesView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.articlesView.topAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05)
        ])
    }
    
    private func setupTableViewLayout() {
        self.view.addSubview(articlesView)
        
        NSLayoutConstraint.activate([
            articlesView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            articlesView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.67),
            articlesView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func setupMenuViewLayout() {
        self.view.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            menuView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            menuView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            menuView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1),
            menuView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            articlesView.bottomAnchor.constraint(equalTo: self.menuView.topAnchor)
        ])
    }
    
    private func setupSortSelectionViewLayout() {
        self.view.addSubview(sortSelectionView)
        
        NSLayoutConstraint.activate([
            sortSelectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            sortSelectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            sortSelectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25),
            sortSelectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
}

extension SearchViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sortSelectionView.shift(duration: 0, toogle: false, offset: CGPoint(x: 0, y: sortSelectionView.frame.height))
    }
}

// MARK: - Bind Navigation Data
extension SearchViewController {
    private func bindNavigationData() {
        bindSearchViewNavigationData()
        bindArticlesViewNavigationData()
        bindMenuButtonsNavigationDataData()
        bindSortViewNavigationData()
    }
    
    private func bindSearchViewNavigationData() {
        navigationView.filtersButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                self.navigationView.filtersButton.isSelected.toggle()
                
                self.navigationViewModel.isFiltersViewActive.onNext(self.navigationView.filtersButton.isSelected)
            }
            .disposed(by: disposeBag)
        
        navigationViewModel.isFiltersViewActive
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.navigationView.filtersButton.tintColor = $0 ? .white : .black
                self.navigationView.filtersButton.backgroundColor = $0 ? .orange : UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            })
            .disposed(by: disposeBag)
        
        navigationView.sortButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                self.navigationView.sortButton.isSelected.toggle()
                
                self.navigationViewModel.isSortViewActive.onNext(self.navigationView.sortButton.isSelected)
                
            }
            .disposed(by: disposeBag)
        
        navigationViewModel.isSortViewActive
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.navigationView.sortButton.tintColor = $0 ? .white : .black
                self.navigationView.sortButton.backgroundColor = $0 ? .orange : UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindArticlesViewNavigationData() {
        // Open web view
        articlesView.articlesCollectionView.rx.modelSelected(ArticleModel.self)
            .observe(on: MainScheduler.instance)
            .compactMap { URL(string: $0.url) }
            .map { SFSafariViewController(url: $0) }
            .subscribe(onNext: { [weak self] safariViewController in
                self?.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindMenuButtonsNavigationDataData() {
        menuView.buttonsStack.arrangedSubviews.forEach({
            if let btn = $0 as? MenuButton, let viewType = btn.type {
                btn.button.rx.tap
                    .observe(on: MainScheduler.instance)
                    .bind { [weak self] in
                        self?.navigationViewModel.isViewActive.onNext(viewType)
                    }
                    .disposed(by: disposeBag)
                
                navigationViewModel.buttonSelected
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: {
                        if $0 == viewType {
                            btn.image.tintColor = .orange
                            btn.titleLabel.textColor = .orange
                        }
                    })
                    .disposed(by: disposeBag)
            }
        })
    }
    
    private func bindSortViewNavigationData() {
        navigationViewModel.isSortViewActive
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] toogle in
                guard let self = self else { return }
                
                // Animate view transition
                self.sortSelectionView.isHidden = false
                self.sortSelectionView.shift(duration: 1, toogle: toogle, offset: CGPoint(x: 0, y: self.sortSelectionView.frame.height))
                
                if !toogle {
                    // Fetch data with new sort type
                    self.viewModel.fetchItems()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Bind View Data
extension SearchViewController {
    private func bindData() {
        bindSearchViewData()
        bindArticlesViewData()
        bindSortViewData()
        bindControllerViewData()

        // MARK: - TO DO -> Check loading view method
        viewModel.showLoading
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isShowing in
                self?.articlesView.loadingView.isHidden = !isShowing
            })
            .disposed(by: disposeBag)
        
        // MARK: - TO DO -> Refactor fetch items method
        viewModel.fetchItems()
    }
    
    private func bindSearchViewData() {
        navigationView.searchView.textField.rx.text
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] str in
                if let searchString = str, searchString.count > 0 {
                    self?.viewModel?.isSearching.onNext(searchString)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindArticlesViewData() {
        viewModel.articles
            .observe(on: MainScheduler.instance)
            .bind(to: articlesView.articlesCollectionView.rx.items(cellIdentifier: ArticleTableViewCell.CELL_IDENTIFIER, cellType: ArticleTableViewCell.self)) { row, model, cell in
                cell.populateCell(data: model)
            }
            .disposed(by: disposeBag)
        
        articlesView.articlesCollectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { indexPath in
                self.articlesView.articlesCollectionView.deselectItem(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSortViewData() {
        sortSelectionView.dateCell.button.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.isDateSelected.onNext(true)
            }
            .disposed(by: disposeBag)
        
        sortSelectionView.relevanceCell.button.rx.tap
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
                    self.sortSelectionView.dateCell.selectionIndicator.layer.borderColor = UIColor.clear.cgColor
                    self.sortSelectionView.dateCell.selectionIndicator.backgroundColor = .lightGray
                    self.sortSelectionView.dateCell.selectionIndicator.alpha = 0.25
                } else {
                    self.sortSelectionView.dateCell.selectionIndicator.layer.borderColor = UIColor.orange.cgColor
                    self.sortSelectionView.dateCell.selectionIndicator.backgroundColor = .white
                    self.sortSelectionView.dateCell.selectionIndicator.alpha = 1
                    
                    self.viewModel.isRelevanceSelected.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isDateSelected
            .onNext(true)
        
        viewModel.isRelevanceSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] toogle in
                guard let self = self else { return }
                
                if !toogle {
                    self.sortSelectionView.relevanceCell.selectionIndicator.layer.borderColor = UIColor.clear.cgColor
                    self.sortSelectionView.relevanceCell.selectionIndicator.backgroundColor = .lightGray
                    self.sortSelectionView.relevanceCell.selectionIndicator.alpha = 0.25
                } else {
                    self.sortSelectionView.relevanceCell.selectionIndicator.layer.borderColor = UIColor.orange.cgColor
                    self.sortSelectionView.relevanceCell.selectionIndicator.backgroundColor = .white
                    self.sortSelectionView.relevanceCell.selectionIndicator.alpha = 1
                    
                    self.viewModel.isDateSelected.onNext(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindControllerViewData() {
        viewModel.count
            .observe(on: MainScheduler.instance)
            .map { "\($0) news" }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
