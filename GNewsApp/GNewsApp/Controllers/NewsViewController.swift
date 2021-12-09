//
//  NewsViewController.swift
//  GNewsApp
//
//  Created by vladikkk on 26/11/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class NewsViewController: UIViewController {
    // MARK: - Properties
    var navigationViewModel: NavigationViewModel! {
        didSet {
            bindNavigationData()
        }
    }
    
    var viewModel: DataViewModel! {
        didSet {
            bindData()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    lazy var navigationView: UIView = {
        let view = CommonNavigationView(frame: .zero)
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
    }
    
    private func setupNavigationViewLayout() {
        self.view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: self.view.topAnchor),
            navigationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            navigationView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1),
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
            articlesView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7),
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
}

// MARK: - Bind Navigation Data
extension NewsViewController {
    private func bindNavigationData() {
        bindArticlesViewNavigationData()
        bindMenuButtonsData()
    }
    
    private func bindArticlesViewNavigationData() {
        // Open web view
        articlesView.articlesCollectionView.rx.modelSelected(ArticleModel.self)
            .observe(on: MainScheduler.instance)
            .compactMap { URL(string: $0.url) }
            .map { SFSafariViewController(url: $0) }
            .subscribe(onNext: { [weak self] safariViewController in
                guard let self = self else { return }
                
                self.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindMenuButtonsData() {
        menuView.buttonsStack.arrangedSubviews.forEach({
            if let btn = $0 as? MenuButton, let viewType = btn.type {
                btn.button.rx.tap
                    .observe(on: MainScheduler.instance)
                    .bind { [weak self] in
                        guard let self = self else { return }
                        
                        self.navigationViewModel.isViewActive.onNext(viewType)
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
}

// MARK: - Bind View Data
extension NewsViewController {
    private func bindData() {
        bindArticlesViewData()
        
        viewModel.fetchItems()
    }
    
    private func bindArticlesViewData() {
        viewModel.articles
            .observe(on: MainScheduler.instance)
            .bind(to: articlesView.articlesCollectionView.rx.items(cellIdentifier: ArticleCollectionViewCell.CELL_IDENTIFIER, cellType: ArticleCollectionViewCell.self)) { row, model, cell in
                cell.populateCell(data: model)
            }
            .disposed(by: disposeBag)
        
        articlesView.articlesCollectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                self.articlesView.articlesCollectionView.deselectItem(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
