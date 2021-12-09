//
//  NavigationViewModel.swift
//  GNewsApp
//
//  Created by vladikkk on 02/12/2021.
//

import UIKit
import RxSwift

struct NavigationViewModel {
    // MARK: - Properties
    let isViewActive = PublishSubject<MenuButtonType>()
    let buttonSelected = PublishSubject<MenuButtonType>()
    
    let isSortViewActive = PublishSubject<Bool>()
    
    let isFiltersViewActive = PublishSubject<FilterViewTypeEnum>()
    let primaryFilterSelected = PublishSubject<String>()
    let secondaryFiltersSelected = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    func didStartNavigationTapped() {
        // MARK: - Only use this method to show main view controller.
        isViewActive
            .subscribe(onNext: {
                buttonSelected.onNext($0)
            })
            .disposed(by: disposeBag)
        
        isViewActive
            .onNext(.news)
        
        primaryFilterSelected
            .subscribe(onNext: { _ in
                isFiltersViewActive.onNext(.none)
            })
            .disposed(by: disposeBag)
        
        secondaryFiltersSelected
            .subscribe(onNext: { _ in
                isFiltersViewActive.onNext(.primary)
            })
            .disposed(by: disposeBag)
    }
    
    func didCloseFiltersView() {
        // MARK: - Only use this method to when filter view is closed
        isViewActive
            .onNext(.search)
    }
}
