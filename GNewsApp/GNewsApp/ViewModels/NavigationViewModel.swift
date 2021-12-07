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
    
    let isFiltersViewActive = PublishSubject<Bool>()
    let isContentFilterViewActive = PublishSubject<Bool>()

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
    }
    
    func didCloseFiltersView() {
        // MARK: - Only use this method to when filter view is closed
        isViewActive
            .onNext(.search)
    }
}
