//
//  ArticleCellViewModel.swift
//  GNewsApp
//
//  Created by vladikkk on 29/11/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct ArticleCellViewModel {
    public let articles = PublishSubject<[ArticleModel]>()

    private let disposeBag = DisposeBag()

    func fetchItems() {
        let result: Observable<NewsModel> = WebService.shared.getTopHeadlines()
        
        articles.asObservable()
            .subscribe(onNext: { print($0.count) })
            .disposed(by: disposeBag)
        
        result
            .subscribe(onNext: { articles.onNext($0.articles) })
            .disposed(by: disposeBag)
    }
}
