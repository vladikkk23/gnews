//
//  NavigationViewModel.swift
//  GNewsApp
//
//  Created by vladikkk on 02/12/2021.
//

import UIKit
import RxSwift

protocol NavigationDelegate: AnyObject {
    func didStartNavigation()
    func didFailNavigation()
}

struct NavigationViewModel {
    // MARK: - Properties
    var rootVC: UIViewController?
    private let disposeBag = DisposeBag()
    let isViewActive: Observable<Bool>
    let viewType: Observable<MenuButtonType>?
    
    // Events
    let didStartNavigation = PublishSubject<Void>()
    let didFailNavigation = PublishSubject<Void>()
    
    // MARK: - Initializers
    init(withViewController vc: UIViewController) {
        rootVC = vc
        isViewActive = Observable.just(true)
        viewType = Observable.just(.news)
    }
    
    // MARK: - Methods
    func didStartNavigationTapped() {
        if rootVC != nil {
            didStartNavigation.onNext(())
        } else {
            // MARK: - TO DO -> Implement error
            didFailNavigation.onNext(())
        }
    }
}