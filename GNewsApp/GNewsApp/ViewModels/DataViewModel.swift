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
    var persistentFiltersData = PersistentFiltersModel()
    
    public let count = PublishSubject<Int>()
    public let articles = PublishSubject<[ArticleModel]>()
    public let news = PublishSubject<NewsModel>()
    public let selectedArticle = PublishSubject<ArticleModel>()
    
    private let disposeBag = DisposeBag()
    
    let isSearching = PublishSubject<String>()
    
    let fromDateSelected = PublishSubject<String>()
    let toDateSelected = PublishSubject<String>()
    let clearMainFilters = PublishSubject<Void>()
    
    let inTitleSelected = PublishSubject<Bool>()
    let inDescriptionSelected = PublishSubject<Bool>()
    let inContentSelected = PublishSubject<Bool>()
    let clearSecodnaryFilters = PublishSubject<Void>()
    
    let fetchFilters = PublishSubject<Void>()
    let saveFilters = PublishSubject<Void>()
    
    let isDateSelected = PublishSubject<Bool>()
    let isRelevanceSelected = PublishSubject<Bool>()
    
    // MARK: - Initializers
    init() {
        bindData()
        fetchItems()
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
                    self.fetchDataFromPersistenceStorage()
                }
            }
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Bind data
extension DataViewModel {
    private func bindData() {
        bindDataToStorage()
        bindFiltersToPersistenceStorage()
        bindSearch()
    }
    
    // MARK: - Bind search
    private func bindSearch() {
        isSearching
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                
                if title.count > 0 {
                    self.search(title: title)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Bind data to storage
    private func bindDataToStorage() {
        news
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] news in
                guard let self = self else { return }
                
                self.writeDataToPersistenceStorage(news: news)
            })
            .disposed(by: disposeBag)
        
        fetchFilters
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if let filters = self.fetchFiltersFromPersistenceStorage() {
                    self.persistentFiltersData = filters
                    
                    if !filters.fromDate.isEmpty {
                        self.fromDateSelected
                            .onNext(filters.fromDate)
                    }
                    
                    if !filters.toDate.isEmpty {
                        self.fromDateSelected
                            .onNext(filters.toDate)
                    }
                    
                    if filters.searchIn.contains("title") {
                        self.inTitleSelected
                            .onNext(true)
                    }
                    
                    if filters.searchIn.contains("description") {
                        self.inDescriptionSelected
                            .onNext(true)
                    }
                    
                    if filters.searchIn.contains("content") {
                        self.inContentSelected
                            .onNext(true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        saveFilters
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.writeFiltersToPersistenceStorage(data: self.persistentFiltersData)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Bind filters to storage
    private func bindFiltersToPersistenceStorage() {
        fromDateSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] stringDate in
                guard let self = self else { return }
                
                if let filters = self.fetchFiltersFromPersistenceStorage() {
                    _ = self.storage.update {
                        filters.fromDate = stringDate
                    }
                } else {
                    self.persistentFiltersData.fromDate = stringDate
                }
            })
            .disposed(by: disposeBag)
        
        toDateSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] stringDate in
                guard let self = self else { return }
                
                if let filters = self.fetchFiltersFromPersistenceStorage() {
                    _ = self.storage.update {
                        filters.toDate = stringDate
                    }
                } else {
                    self.persistentFiltersData.toDate = stringDate
                }
            })
            .disposed(by: disposeBag)
        
        inTitleSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isActive in
                guard let self = self else { return }
                
                if let filters = self.fetchFiltersFromPersistenceStorage() {
                    if isActive {
                        if !filters.searchIn.contains("title") {
                            _ = self.storage.update {
                                filters.searchIn.append("title")
                            }
                        }
                    } else if let index = self.persistentFiltersData.searchIn.firstIndex(where: { $0 == "title" }) {
                        _ = self.storage.update {
                            filters.searchIn.remove(at: index)
                        }
                    }
                } else {
                    if isActive {
                        if !self.persistentFiltersData.searchIn.contains("title") {
                            self.persistentFiltersData.searchIn.append("title")
                        }
                    } else if let index = self.persistentFiltersData.searchIn.firstIndex(where: { $0 == "title" }) {
                        self.persistentFiltersData.searchIn.remove(at: index)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        inDescriptionSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isActive in
                guard let self = self else { return }
                
                if let filters = self.fetchFiltersFromPersistenceStorage() {
                    if isActive {
                        if !filters.searchIn.contains("description") {
                            _ = self.storage.update {
                                filters.searchIn.append("description")
                            }
                        }
                    } else if let index = self.persistentFiltersData.searchIn.firstIndex(where: { $0 == "description" }) {
                        _ = self.storage.update {
                            filters.searchIn.remove(at: index)
                        }
                    }
                } else {
                    if isActive {
                        if !self.persistentFiltersData.searchIn.contains("description") {
                            self.persistentFiltersData.searchIn.append("description")
                        }
                    } else if let index = self.persistentFiltersData.searchIn.firstIndex(where: { $0 == "description" }) {
                        self.persistentFiltersData.searchIn.remove(at: index)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        inContentSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isActive in
                guard let self = self else { return }
                
                if let filters = self.fetchFiltersFromPersistenceStorage() {
                    if isActive {
                        if !filters.searchIn.contains("content") {
                            _ = self.storage.update {
                                filters.searchIn.append("content")
                            }
                        }
                    } else if let index = self.persistentFiltersData.searchIn.firstIndex(where: { $0 == "content" }) {
                        _ = self.storage.update {
                            filters.searchIn.remove(at: index)
                        }
                    }
                } else {
                    if isActive {
                        if !self.persistentFiltersData.searchIn.contains("content") {
                            self.persistentFiltersData.searchIn.append("content")
                        }
                    } else if let index = self.persistentFiltersData.searchIn.firstIndex(where: { $0 == "content" }) {
                        self.persistentFiltersData.searchIn.remove(at: index)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        clearSecodnaryFilters
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if let filtersData = self.fetchFiltersFromPersistenceStorage() {
                    let isSuccess = self.storage.update {
                        filtersData.searchIn.removeAll()
                    }
                    
                    if isSuccess {
                        self.inTitleSelected.onNext(false)
                        self.inContentSelected.onNext(false)
                        self.inDescriptionSelected.onNext(false)
                    }
                } else {
                    self.persistentFiltersData = PersistentFiltersModel()
                    
                    self.inTitleSelected.onNext(false)
                    self.inContentSelected.onNext(false)
                    self.inDescriptionSelected.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        
        clearMainFilters
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                let isSuccess = self.storage.flushAllFIlters()
                
                if isSuccess {
                    self.persistentFiltersData = PersistentFiltersModel()
                    
                    self.fromDateSelected.onNext("")
                    self.toDateSelected.onNext("")
                    
                    self.inTitleSelected.onNext(false)
                    self.inContentSelected.onNext(false)
                    self.inDescriptionSelected.onNext(false)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Storage operations
extension DataViewModel {
    // MARK: - Write new data to storage
    private func writeDataToPersistenceStorage(news: NewsModel) {
        persistentNewsData = persistentNewsData.getData(fromCodable: news)
        
        let isSuccess = storage.write(persistentNewsData)
        
        if isSuccess {
            fetchDataFromPersistenceStorage()
        }
    }
    
    // MARK: - Read data from storage
    private func fetchDataFromPersistenceStorage() {
        if let objects: PersistentNewsModel = storage.object(.news), let news = objects.getDatafromPersistant() {
            articles.onNext(news.articles)
            count.onNext(news.totalArticles)
        }
    }
    
    // MARK: - Write filters to storage
    private func writeFiltersToPersistenceStorage(data: PersistentFiltersModel) {
        _ = storage.write(data)
        
        print(fetchFiltersFromPersistenceStorage() ?? "nil")
    }
    
    // MARK: - Read filters from storage
    private func fetchFiltersFromPersistenceStorage() -> PersistentFiltersModel?{
        if let filters: PersistentFiltersModel = storage.object(.filters) {
            return filters
        }
        
        return nil
    }
    
    // MARK: - Perform search and fetch result
    func search(title: String) {
        let filtersArray = self.persistentFiltersData.searchIn.joined(separator: ",")
        
        
        let result: Observable<NewsModel> = WebService.shared.getSearchResult(title: title,
                                                                              filters: [persistentFiltersData.fromDate,
                                                                                        persistentFiltersData.toDate,
                                                                                        filtersArray],
                                                                              sort: .newest)
        
        result
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.articles.onNext($0.articles)
                self.count.onNext($0.totalArticles)
            })
            .disposed(by: disposeBag)
    }
}
