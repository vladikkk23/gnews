//
//  ArticleTableViewCell.swift
//  GNewsApp
//
//  Created by vladikkk on 29/11/2021.
//

import UIKit
import RxSwift

class ArticleCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let CELL_IDENTIFIER = "ArticleTableViewCell"
    
    let imageViewModel: ImageDataViewModel = {
        let service = ImageDataViewModel()
        return service
    }()
    
    // MARK: - UI
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Black", size: 15)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .lightGray
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCell()
    }
    
    // MARK: - Methods
    func populateCell(data: ArticleModel) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        imageViewModel.fetchImage(usingStringUrl: data.image)
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
            image.widthAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    private func setupDescriptionLabelLayout() {
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
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
            titleLabel.bottomAnchor.constraint(equalTo: self.descriptionLabel.topAnchor)
        ])
    }
}

// MARK: - Set background color and add shadow
extension ArticleCollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .white
        
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.25
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0 , height: 5)
    }
}
