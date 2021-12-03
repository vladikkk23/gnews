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
    
    public let count = PublishSubject<Int>()
    public let articles = PublishSubject<[ArticleModel]>()
    public let selectedArticle = PublishSubject<ArticleModel>()

    private let disposeBag = DisposeBag()

    func fetchItems() {
        let result: Observable<NewsModel> = WebService.shared.getTopHeadlines()
        

        
        result
            .subscribe(onNext: { articles.onNext($0.articles) })
            .disposed(by: disposeBag)
        
        result
            .subscribe(onNext: { count.onNext($0.totalArticles) })
            .disposed(by: disposeBag)
    }
}
