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
//        let result: Observable<NewsModel> = WebService.shared.getTopHeadlines()
        
        let models: [ArticleModel] = [
            ArticleModel(title: "Qualcomm prezintă procesorul flagship Snapdragon 8 Gen 1; Se va regăsi pe Galaxy S22, OnePlus 10 + alte telefoane din 2022",
                         description: "Aşa cum ne aşteptam Qualcomm a ţinut un eveniment pe 30 noiembrie 2021, în cadrul căruia a prezentat în sfârşit noul său procesor flagship, Qualcomm Snapdragon 8 Gen 1. A fost cunoscut o perioadă şi drept Snapdragon 898, dar pentru a marca saltul de..",
                         content: "Aşa cum ne aşteptam Qualcomm a ţinut un eveniment pe 30 noiembrie 2021, în cadrul căruia a prezentat în sfârşit noul său procesor flagship, Qualcomm Snapdragon 8 Gen 1. A fost cunoscut o perioadă şi drept Snapdragon 898, dar pentru a marca saltul de ... [3895 chars]",
                         url: "https://www.mobilissimo.ro/stiri-diverse/qualcomm-prezinta-procesorul-flagship-snapdragon-8-gen-1-se-va-regasi-pe-galaxy-s22-oneplus-10-plus-alte-telefoane-din-2022",
                         image: "https://images1.mobilissimo.ro/SHY/61a7299b1cf71.jpg",
                         publishedAt: "2021-12-01T07:51:02Z",
                         source: SourceModel(name: "Mobilissimo.ro",
                                             url: "https://www.mobilissimo.ro")),
            ArticleModel(title: "Qualcomm prezintă procesorul flagship Snapdragon 8 Gen 1; Se va regăsi pe Galaxy S22, OnePlus 10 + alte telefoane din 2022",
                         description: "Aşa cum ne aşteptam Qualcomm a ţinut un eveniment pe 30 noiembrie 2021, în cadrul căruia a prezentat în sfârşit noul său procesor flagship, Qualcomm Snapdragon 8 Gen 1. A fost cunoscut o perioadă şi drept Snapdragon 898, dar pentru a marca saltul de..",
                         content: "Aşa cum ne aşteptam Qualcomm a ţinut un eveniment pe 30 noiembrie 2021, în cadrul căruia a prezentat în sfârşit noul său procesor flagship, Qualcomm Snapdragon 8 Gen 1. A fost cunoscut o perioadă şi drept Snapdragon 898, dar pentru a marca saltul de ... [3895 chars]",
                         url: "https://www.mobilissimo.ro/stiri-diverse/qualcomm-prezinta-procesorul-flagship-snapdragon-8-gen-1-se-va-regasi-pe-galaxy-s22-oneplus-10-plus-alte-telefoane-din-2022",
                         image: "https://images1.mobilissimo.ro/SHY/61a7299b1cf71.jpg",
                         publishedAt: "2021-12-01T07:51:02Z",
                         source: SourceModel(name: "Mobilissimo.ro",
                                             url: "https://www.mobilissimo.ro")),
            ArticleModel(title: "Qualcomm prezintă procesorul flagship Snapdragon 8 Gen 1; Se va regăsi pe Galaxy S22, OnePlus 10 + alte telefoane din 2022",
                         description: "Aşa cum ne aşteptam Qualcomm a ţinut un eveniment pe 30 noiembrie 2021, în cadrul căruia a prezentat în sfârşit noul său procesor flagship, Qualcomm Snapdragon 8 Gen 1. A fost cunoscut o perioadă şi drept Snapdragon 898, dar pentru a marca saltul de..",
                         content: "Aşa cum ne aşteptam Qualcomm a ţinut un eveniment pe 30 noiembrie 2021, în cadrul căruia a prezentat în sfârşit noul său procesor flagship, Qualcomm Snapdragon 8 Gen 1. A fost cunoscut o perioadă şi drept Snapdragon 898, dar pentru a marca saltul de ... [3895 chars]",
                         url: "https://www.mobilissimo.ro/stiri-diverse/qualcomm-prezinta-procesorul-flagship-snapdragon-8-gen-1-se-va-regasi-pe-galaxy-s22-oneplus-10-plus-alte-telefoane-din-2022",
                         image: "https://images1.mobilissimo.ro/SHY/61a7299b1cf71.jpg",
                         publishedAt: "2021-12-01T07:51:02Z",
                         source: SourceModel(name: "Mobilissimo.ro",
                                             url: "https://www.mobilissimo.ro")),
            ArticleModel(title: "Qualcomm prezintă procesorul flagship Snapdragon 8 Gen 1; Se va regăsi pe Galaxy S22, OnePlus 10 + alte telefoane din 2022",
                         description: "Aşa cum ne aşteptam Qualcomm a ţinut un eveniment pe 30 noiembrie 2021, în cadrul căruia a prezentat în sfârşit noul său procesor flagship, Qualcomm Snapdragon 8 Gen 1. A fost cunoscut o perioadă şi drept Snapdragon 898, dar pentru a marca saltul de..",
                         content: "Aşa cum ne aşteptam Qualcomm a ţinut un eveniment pe 30 noiembrie 2021, în cadrul căruia a prezentat în sfârşit noul său procesor flagship, Qualcomm Snapdragon 8 Gen 1. A fost cunoscut o perioadă şi drept Snapdragon 898, dar pentru a marca saltul de ... [3895 chars]",
                         url: "https://www.mobilissimo.ro/stiri-diverse/qualcomm-prezinta-procesorul-flagship-snapdragon-8-gen-1-se-va-regasi-pe-galaxy-s22-oneplus-10-plus-alte-telefoane-din-2022",
                         image: "https://images1.mobilissimo.ro/SHY/61a7299b1cf71.jpg",
                         publishedAt: "2021-12-01T07:51:02Z",
                         source: SourceModel(name: "Mobilissimo.ro",
                                             url: "https://www.mobilissimo.ro")),
            ArticleModel(title: "Qualcomm prezintă procesorul flagship Snapdragon 8 Gen 1; Se va regăsi pe Galaxy S22, OnePlus 10 + alte telefoane din 2022",
                         description: "Aşa cum ne aşteptam Qualcomm a ţinut un eveniment pe 30 noiembrie 2021, în cadrul căruia a prezentat în sfârşit noul său procesor flagship, Qualcomm Snapdragon 8 Gen 1. A fost cunoscut o perioadă şi drept Snapdragon 898, dar pentru a marca saltul de..",
                         content: "Aşa cum ne aşteptam Qualcomm a ţinut un eveniment pe 30 noiembrie 2021, în cadrul căruia a prezentat în sfârşit noul său procesor flagship, Qualcomm Snapdragon 8 Gen 1. A fost cunoscut o perioadă şi drept Snapdragon 898, dar pentru a marca saltul de ... [3895 chars]",
                         url: "https://www.mobilissimo.ro/stiri-diverse/qualcomm-prezinta-procesorul-flagship-snapdragon-8-gen-1-se-va-regasi-pe-galaxy-s22-oneplus-10-plus-alte-telefoane-din-2022",
                         image: "https://images1.mobilissimo.ro/SHY/61a7299b1cf71.jpg",
                         publishedAt: "2021-12-01T07:51:02Z",
                         source: SourceModel(name: "Mobilissimo.ro",
                                             url: "https://www.mobilissimo.ro"))
        ]
        
        let result: Observable<NewsModel> = Observable.just(NewsModel(totalArticles: 5, articles: models))
        
        articles.asObservable()
            .subscribe(onNext: { print($0.count) })
            .disposed(by: disposeBag)
        
        result
            .subscribe(onNext: { articles.onNext($0.articles) })
            .disposed(by: disposeBag)
        
        count.asObservable()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        result
            .subscribe(onNext: { count.onNext($0.totalArticles) })
            .disposed(by: disposeBag)
    }
}
