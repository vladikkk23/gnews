//
//  MenuView.swift
//  GNewsApp
//
//  Created by vladikkk on 29/11/2021.
//

import UIKit

// MARK: - Menu View
class MenuView: UIView {
    // MARK: - Properties
    lazy var homeButton: MenuButton = {
        let btn = MenuButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.type = .home
        return btn
    }()
    
    lazy var newsButton: MenuButton = {
        let btn = MenuButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.type = .news
        return btn
    }()
    
    lazy var searchButton: MenuButton = {
        let btn = MenuButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.type = .search
        return btn
    }()
    
    lazy var profileButton: MenuButton = {
        let btn = MenuButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.type = .profile
        return btn
    }()
    
    lazy var moreButton: MenuButton = {
        let btn = MenuButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.type = .more
        return btn
    }()
    
    lazy var buttonsStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
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
        setupStackViewLayout()
    }
    
    private func setupStackViewLayout() {
        buttonsStack.addArrangedSubview(homeButton)
        buttonsStack.addArrangedSubview(newsButton)
        buttonsStack.addArrangedSubview(searchButton)
        buttonsStack.addArrangedSubview(profileButton)
        buttonsStack.addArrangedSubview(moreButton)
        
        addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            buttonsStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonsStack.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            buttonsStack.heightAnchor.constraint(equalTo: self.heightAnchor),
            buttonsStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85)
        ])
    }
}

// MARK: - Menu Button
class MenuButton: UIView {
    // MARK: - Properties
    var type: MenuButtonType? {
        didSet {
            setupButton()
        }
    }
    
    // UI
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .gray
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 12)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Methods
    private func setupView() {
        setupButtonLayout()
        setupImageLayout()
        setupTitleLabel()
    }
    
    private func setupButton() {
        if let type = type {
            switch type {
            case .home:
                image.image = UIImage(systemName: "house")
                titleLabel.text = "Home"
            case .news:
                image.image = UIImage(systemName: "text.justify")
                image.tintColor = .systemOrange
                titleLabel.text = "News"
                titleLabel.textColor = .systemOrange
            case .search:
                image.image = UIImage(systemName: "magnifyingglass")
                titleLabel.text = "Search"
            case .profile:
                image.image = UIImage(systemName: "person")
                titleLabel.text = "Profile"
            case .more:
                image.image = UIImage(systemName: "ellipsis.circle.fill")
                titleLabel.text = "More"
            }
        }
        
        setupView()
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
    
    private func setupImageLayout() {
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.topAnchor),
            image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            image.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            image.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 2.5),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9)
        ])
    }
}

// MARK: - Menu Button Type
enum MenuButtonType {
    case home
    case news
    case search
    case profile
    case more
}
