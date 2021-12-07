//
//  InDevelopmentViewController.swift
//  GNewsApp
//
//  Created by vladikkk on 03/12/2021.
//

import UIKit
import RxSwift

class InDevelopmentViewController: UIViewController {
    // MARK: - Properties
    var navigationViewModel: NavigationViewModel! {
        didSet {
            bindNavigationData()
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
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .orange
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This view is still in Development. \n Please stand by 😼"
        label.font = UIFont(name: "Avenir-Black", size: 20)
        label.textAlignment = .center
        return label
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
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationViewLayout()
        setupImageLayout()
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
    
    private func setupImageLayout() {
        view.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTitleLabelLayout() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
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

// MARK: - Bind Navigation Data
extension InDevelopmentViewController {
    private func bindNavigationData() {
        bindMenuButtonsData()
    }
    
    private func bindMenuButtonsData() {
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
}
