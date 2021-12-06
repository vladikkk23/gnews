//
//  ArticlesCollectionView.swift
//  GNewsApp
//
//  Created by vladikkk on 04/12/2021.
//

import UIKit
import RxSwift

class ArticlesCollectionView: UIView {
    // MARK: - Properties
    lazy var articlesCollectionView: UICollectionView = {
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
    
    lazy var loadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        view.isHidden = true
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
        articlesCollectionView
            .rx.delegate
            .setForwardToDelegate(self, retainDelegate: false)
        
        setupArticlesCollectionViewLayout()
        setupLoadingViewLayout()
    }
    
    private func setupArticlesCollectionViewLayout() {
        addSubview(articlesCollectionView)
        
        NSLayoutConstraint.activate([
            articlesCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            articlesCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            articlesCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor),
            articlesCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupLoadingViewLayout() {
        addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: articlesCollectionView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: articlesCollectionView.centerYAnchor),
            loadingView.heightAnchor.constraint(equalTo: articlesCollectionView.heightAnchor),
            loadingView.widthAnchor.constraint(equalTo: articlesCollectionView.widthAnchor)
        ])
    }
}

// Launches Flow Layout Setup
extension ArticlesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Setup cell size
        let size = articlesCollectionView.frame.size
        return CGSize(width: size.width, height: size.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
