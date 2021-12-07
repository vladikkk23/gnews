//
//  FiltersViewController.swift
//  GNewsApp
//
//  Created by vladikkk on 05/12/2021.
//

import UIKit
import RxSwift

class FiltersViewController: UIViewController {
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
    lazy var filtersInputView: MainFiltersView = {
        let view = MainFiltersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var contentFiltersSelectionView: SecondaryFiltersView = {
        let view = SecondaryFiltersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        setupFiltersInputViewLayout()
        setupContentFiltersSelectionViewLayout()
    }
    
    private func setupFiltersInputViewLayout() {
        view.addSubview(filtersInputView)
        
        NSLayoutConstraint.activate([
            filtersInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersInputView.topAnchor.constraint(equalTo: view.topAnchor),
            filtersInputView.heightAnchor.constraint(equalTo: view.heightAnchor),
            filtersInputView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func setupContentFiltersSelectionViewLayout() {
        view.addSubview(contentFiltersSelectionView)
        
        NSLayoutConstraint.activate([
            contentFiltersSelectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentFiltersSelectionView.topAnchor.constraint(equalTo: view.topAnchor),
            contentFiltersSelectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            contentFiltersSelectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
}

// MARK: - Extension to hide contentFiltersSelectionView before controller did load
extension FiltersViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentFiltersSelectionView.shift(duration: 0, toogle: false, offset: CGPoint(x: view.frame.width, y: 0))
    }
}

// MARK: - Bind Navigation Data
extension FiltersViewController {
    private func bindNavigationData() {
        bindFiltersInputViewNavigationData()
    }
    
    private func bindFiltersInputViewNavigationData() {
        filtersInputView.navigationView.backButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.navigationViewModel.isFiltersViewActive.onNext(false)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Bind View Data
extension FiltersViewController {
    private func bindData() {
        
    }
}
