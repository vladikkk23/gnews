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
    var viewModel: SearchViewModel! {
        didSet {
            navigationView.viewModel = viewModel
            sortSelectionView.viewModel = viewModel
        }
    }
    
    var navigationViewModel: NavigationViewModel! {
        didSet {
            navigationView.navigationViewModel = navigationViewModel
            menuView.viewModel = navigationViewModel
            sortSelectionView.navigationViewModel = navigationViewModel
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // UI
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
        return view
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        setupUI()
        bindData()
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

// MARK: - Binding
extension SearchViewController {
    func bindData() {
        viewModel.count
            .observe(on: MainScheduler.instance)
            .map { "\($0) news" }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.articles
            .observe(on: MainScheduler.instance)
            .bind(to: articlesView.articlesCollectionView.rx.items(cellIdentifier: ArticleTableViewCell.CELL_IDENTIFIER, cellType: ArticleTableViewCell.self)) { row, model, cell in
                cell.populateCell(data: model)
            }.disposed(by: disposeBag)
        
        articlesView.articlesCollectionView.rx.modelSelected(ArticleModel.self)
            .compactMap { URL(string: $0.url) }
            .map { SFSafariViewController(url: $0) }
            .subscribe(onNext: { [weak self] safariViewController in
                self?.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        // TO DO: Check
        viewModel.showLoading
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isShowing in
                self?.articlesView.loadingView.isHidden = !isShowing
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchItems()
    }
}

// MARK: - Extension to hide sortSelectionView before controller did load
extension SearchViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sortSelectionView.frame = sortSelectionView.frame.offsetBy(dx: 0, dy: sortSelectionView.frame.size.height)
    }
}
