//
//  ArticleTableViewCell.swift
//  GNewsApp
//
//  Created by vladikkk on 29/11/2021.
//

import UIKit
import RxSwift

class ArticleTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let CELL_IDENTIFIER = "ArticleTableViewCell"
    
    private let disposeBag = DisposeBag()

    // MARK: - UI
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Black", size: 15)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCell()
    }
    
    // MARK: - Methods
    func populateCell(data: ArticleModel) {
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.description
        
        if let url = URL(string: data.image) {
            image.image!.load(url: url)
                .asObservable()
                .bind(to: image.rx.image)
                .disposed(by: disposeBag)
        }
    }
    
    private func setupCell() {
        setupImageLayout()
        setupDescriptionLabelLayout()
        setupTitleLabelLayout()
    }
    
    private func setupImageLayout() {
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.heightAnchor.constraint(equalTo: self.heightAnchor),
            image.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35)
        ])
    }
    
    private func setupDescriptionLabelLayout() {
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            descriptionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func setupTitleLabelLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: self.descriptionLabel.topAnchor, constant: -10)
        ])
    }
}
