//
//  ViewController.swift
//  GNewsApp
//
//  Created by vladikkk on 26/11/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class TopHeadlinesViewController: UIViewController {
    // MARK: - Properties
    private var viewModel = ArticleCellViewModel()
    
    private let disposeBag = DisposeBag()
    
    // UI
    lazy var navigationView: UIView = {
        let view = NavigationView(frame: .zero)
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
    
    lazy var articlesTableView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isPagingEnabled = false
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        view.register(ArticleTableViewCell.self, forCellWithReuseIdentifier: ArticleTableViewCell.CELL_IDENTIFIER)
        view.backgroundColor = .clear
        return view
    }()
    
    
    lazy var menuView: UIView = {
        let view = MenuView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        bindTableData()
        
        articlesTableView
            .rx.delegate
            .setForwardToDelegate(self, retainDelegate: false)
    }
    
    func bindTableData() {
        viewModel.articles
            .observe(on: MainScheduler.instance)
            .bind(to: articlesTableView.rx.items(cellIdentifier: ArticleTableViewCell.CELL_IDENTIFIER, cellType: ArticleTableViewCell.self)) { row, model, cell in
                cell.populateCell(data: model)
            }.disposed(by: disposeBag)
        
        articlesTableView.rx.modelSelected(ArticleModel.self)
            .compactMap { URL(string: $0.url) }
            .map { SFSafariViewController(url: $0) }
            .subscribe(onNext: { [weak self] safariViewController in
              self?.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchItems()
    }
    
    private func setupUI() {
        setupNavigationViewLayout()
        setupMenuViewLayout()
        setupTableViewLayout()
        setupTitleLabelLayout()
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
            titleLabel.leadingAnchor.constraint(equalTo: self.articlesTableView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.articlesTableView.topAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05)
        ])
    }
    
    private func setupTableViewLayout() {
        self.view.addSubview(articlesTableView)
        
        NSLayoutConstraint.activate([
            articlesTableView.bottomAnchor.constraint(equalTo: self.menuView.topAnchor),
            articlesTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            articlesTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7),
            articlesTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func setupMenuViewLayout() {
        self.view.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            menuView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            menuView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            menuView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1),
            menuView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
}

// Launches Flow Layout Setup
extension TopHeadlinesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Setup cell size
        let size = articlesTableView.frame.size
        return CGSize(width: size.width, height: size.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
