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
    var persistentSortData = PersistentSortModel()
    
    public let count = PublishSubject<Int>()
    public let articles = PublishSubject<[ArticleModel]>()
    public let news = PublishSubject<NewsModel>()
    public let selectedArticle = PublishSubject<ArticleModel>()
    
    private let disposeBag = DisposeBag()
    
    let isSearching = PublishSubject<String>()
    
    let fromDateSelected = PublishSubject<String>()
    let toDateSelected = PublishSubject<String>()
    let searchInSelected = PublishSubject<String>()
    
    let inTitleSelected = PublishSubject<Bool>()
    let inDescriptionSelected = PublishSubject<Bool>()
    let inContentSelected = PublishSubject<Bool>()
    let clearFilters = PublishSubject<Void>()
    
    let saveFilters = PublishSubject<Void>()
    let fetchFilters = PublishSubject<Void>()
    
    var searchTitle = ""
    let isDateSelected = PublishSubject<Bool>()
    let isRelevanceSelected = PublishSubject<Bool>()
    
    let fetchSort = PublishSubject<Void>()
    let saveSort = PublishSubject<Void>()
    
    let isLoading = PublishSubject<Bool>()
    
    // MARK: - Initializers
    init() {
        // MARK: - Begin with default filter values
        persistentFiltersData.searchIn.append(objectsIn: ["title", "description", "content"])
        persistentSortData.filterType = ArticleSortEnum.newest.rawValue
        
        bindData()
        fetchItems()
        
        saveFilters
            .onNext(())
        
        saveSort
            .onNext(())
    }
    
    // MARK: - Methods
    func fetchItems() {
        let result: Observable<NewsModel> = WebService.shared.getTopHeadlines()
        
        result
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
        bindSort()
        bindLoadingData()
    }
    
    // MARK: - Bind search
    private func bindSearch() {
        isSearching
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                
                if title.count > 0 {
                    self.search(title: title, sortBy: ArticleSortEnum(rawValue: self.persistentSortData.filterType) ?? .newest)
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
                        self.toDateSelected
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
                } else {
                    self.inTitleSelected
                        .onNext(true)
                    
                    self.inDescriptionSelected
                        .onNext(true)
                    
                    self.inContentSelected
                        .onNext(true)
                }
                
                self.searchInSelected.onNext(Array(self.persistentFiltersData.searchIn).joined(separator: ", "))
            })
            .disposed(by: disposeBag)
        
        saveFilters
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.writeFiltersToPersistenceStorage(data: self.persistentFiltersData)
                self.fetchFilters.onNext(())
                self.searchInSelected.onNext(Array(self.persistentFiltersData.searchIn).joined(separator: ", "))
            })
            .disposed(by: disposeBag)
        
        fetchSort
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if let sortData = self.fetchSortFromPersistenceStorage() {
                    self.persistentSortData = sortData
                    
                    if sortData.filterType == ArticleSortEnum.newest.rawValue {
                        self.isDateSelected
                            .onNext(true)
                    } else if sortData.filterType == ArticleSortEnum.relevance.rawValue {
                        self.isRelevanceSelected
                            .onNext(true)
                    }
                } else {
                    self.isDateSelected
                        .onNext(true)
                }
            })
            .disposed(by: disposeBag)
        
        saveSort
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.writeSortToPersistenceStorage(data: self.persistentSortData)
                self.fetchSort.onNext(())
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
        
        clearFilters
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
                    
                    self.searchInSelected.onNext(Array(self.persistentFiltersData.searchIn).joined(separator: ", "))
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Bind sort
    private func bindSort() {
        isDateSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isActive in
                guard let self = self else { return }
                
                if isActive {
                    if let sort = self.fetchSortFromPersistenceStorage() {
                        if !(sort.filterType == ArticleSortEnum.newest.rawValue) {
                            _ = self.storage.update {
                                sort.filterType = ArticleSortEnum.newest.rawValue
                            }
                        }
                    } else {
                        self.persistentSortData.filterType = ArticleSortEnum.newest.rawValue
                    }
                }
            })
            .disposed(by: disposeBag)
        
        isRelevanceSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isActive in
                guard let self = self else { return }
                
                if isActive {
                    if let sort = self.fetchSortFromPersistenceStorage() {
                        if !(sort.filterType == ArticleSortEnum.relevance.rawValue) {
                            _ = self.storage.update {
                                sort.filterType = ArticleSortEnum.relevance.rawValue
                            }
                        }
                    } else {
                        _ = self.storage.update {
                            self.persistentSortData.filterType = ArticleSortEnum.relevance.rawValue
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLoadingData() {
        articles
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.isLoading
                    .onNext(data.isEmpty ? true : false)
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
    }
    
    // MARK: - Read filters from storage
    private func fetchFiltersFromPersistenceStorage() -> PersistentFiltersModel?{
        if let filters: PersistentFiltersModel = storage.object(.filters) {
            return filters
        }
        
        return nil
    }
    
    // MARK: - Write sort to storage
    private func writeSortToPersistenceStorage(data: PersistentSortModel) {
        _ = storage.write(data)
    }
    
    // MARK: - Read sort from storage
    private func fetchSortFromPersistenceStorage() -> PersistentSortModel? {
        if let sort: PersistentSortModel = storage.object(.sort) {
            return sort
        }
        
        return nil
    }
    
    // MARK: - Perform search and fetch result
    func search(title: String, sortBy: ArticleSortEnum) {
        if let filters = fetchFiltersFromPersistenceStorage() {
            persistentFiltersData = filters
        }
        
        let searchInFilters = Array(persistentFiltersData.searchIn).joined(separator: ",")
        
        let result: Observable<NewsModel> = WebService.shared.getSearchResult(title: title,
                                                                              filters: [persistentFiltersData.fromDate,
                                                                                        persistentFiltersData.toDate,
                                                                                        searchInFilters],
                                                                              sort: sortBy)
        
        result
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.articles.onNext($0.articles)
                self.count.onNext($0.totalArticles)
                
                self.searchTitle = title
            })
            .disposed(by: disposeBag)
    }
}
