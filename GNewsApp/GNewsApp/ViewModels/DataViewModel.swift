//
//  DataViewModel.swift
//  GNewsApp
//
//  Created by vladikkk on 04/12/2021.
//

import Foundation
import RxSwift
import RealmSwift

class DataViewModel {
    // MARK: - Properties
    let storage = StorageService()
    var persistentNewsData = PersistentNewsModel()
    var persistentFiltersData = PersistenFiltersModel()
    
    public let count = PublishSubject<Int>()
    public let articles = PublishSubject<[ArticleModel]>()
    public let news = PublishSubject<NewsModel>()
    public let selectedArticle = PublishSubject<ArticleModel>()
    
    private let disposeBag = DisposeBag()
    
    let isSearching = PublishSubject<String>()
    let clearFilters = PublishSubject<Void>()
    
    let isDateSelected = PublishSubject<Bool>()
    let fromDateSelected = PublishSubject<String>()
    let toDateSelected = PublishSubject<String>()
    
    let isRelevanceSelected = PublishSubject<Bool>()
    
    // MARK: - Initializers
    init() {
        fetchItems()
        
        news
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] news in
                guard let self = self else { return }
                
                self.writeDataToPersistenceStorage(news: news)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
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
        
        result
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] news in
                guard let self = self else { return }
                
                self.news.onNext(news)
            } onError: { [weak self] err in
                guard let self = self else { return }
                
                let error = err as NSError
                
                switch error.code {
                case 100...500:
                    self.fetchItems()
                default:
                    self.fetchItemsFromPersistenceStorage()
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Write new data to storage
    private func writeDataToPersistenceStorage(news: NewsModel) {
        persistentNewsData = persistentNewsData.getData(fromCodable: news)
        
        let isSuccess = storage.write(persistentNewsData)
        
        if isSuccess {
            fetchItemsFromPersistenceStorage()
        }
    }
    
    // MARK: - Read data from storage
    private func fetchItemsFromPersistenceStorage() {
        if let objects: PersistentNewsModel = storage.object(.news), let news = objects.getDatafromPersistant() {
            articles.onNext(news.articles)
            count.onNext(news.totalArticles)
        }
    }
    
    // MARK: - Perform search and fetch result
    func search(title: String) {
        let result: Observable<NewsModel> = WebService.shared.getSearchResult(title: title)
        
        result
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.articles.onNext($0.articles)
                self.count.onNext($0.totalArticles)
            })
            .disposed(by: disposeBag)
    }
}
