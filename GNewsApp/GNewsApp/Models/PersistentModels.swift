//
//  PersistentModels.swift
//  GNewsApp
//
//  Created by vladikkk on 08/12/2021.
//

import Foundation
import RealmSwift

// MARK: - PersistentNewsModel
class PersistentNewsModel: Object {
    // MARK: - Properties
    @objc dynamic var id = PersistentDataTypes.news.rawValue
    @objc dynamic var totalArticles: Int = 0
    var articles = List<PersistentArticleModel>()
    
    // MARK: - Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    func getData(fromCodable model: NewsModel) -> PersistentNewsModel {
        let persistentData = PersistentNewsModel()
        
        if model.totalArticles > 0 {
            persistentData.totalArticles = model.totalArticles
            
            model.articles.forEach { article in
                let persistentArticle = PersistentArticleModel().getData(fromCodable: article)
                
                persistentData.articles.append(persistentArticle)
            }
        }
        
        return persistentData
    }
    
    func getDatafromPersistant() -> NewsModel? {
        if articles.count > 0 {
            var newArticles: [ArticleModel] = []
            
            articles.forEach { persistentArticle in
                let article = ArticleModel(title: persistentArticle.title,
                                           description: persistentArticle.desc,
                                           content: persistentArticle.content,
                                           url: persistentArticle.url,
                                           image: persistentArticle.image,
                                           publishedAt: persistentArticle.publishedAt,
                                           source: SourceModel(name: persistentArticle.source.name,
                                                               url: persistentArticle.source.url))
                
                
                newArticles.append(article)
            }
            
            let news = NewsModel(totalArticles: totalArticles, articles: newArticles)
            
            return news
        }
        
        return nil
    }
}

// MARK: - PersistentArticleModel
internal class PersistentArticleModel: Object {
    // MARK: - Properties
    @objc dynamic var id = PersistentDataTypes.articles.rawValue + UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var publishedAt: String = ""
    @objc dynamic var source: PersistentSourceModel! = PersistentSourceModel()
    
    // MARK: - Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    internal func getData(fromCodable model: ArticleModel) -> Self {
        self.title = model.title
        self.desc = model.description
        self.content = model.content
        self.url = model.url
        self.image = model.image
        self.publishedAt = model.publishedAt
        
        let source = PersistentSourceModel()
        source.name = model.source.name
        source.url = model.source.url
        
        return self
    }
}

// MARK: - PersistentSourceModel
internal class PersistentSourceModel: Object {
    // MARK: - Properties
    @objc dynamic var id = PersistentDataTypes.sources.rawValue
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    
    // MARK: - Methods
    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PersistentFilterModel
class PersistentFiltersModel: Object {
    // MARK: - Properties
    @objc dynamic var id = PersistentDataTypes.filters.rawValue
    @objc dynamic var fromDate: String = ""
    @objc dynamic var toDate: String = ""
    var searchIn = List<String>()
    
    // MARK: - Methods
    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PersistentSortModel
class PersistentSortModel: Object {
    // MARK: - Properties
    @objc dynamic var id = PersistentDataTypes.sort.rawValue
    @objc dynamic var filterType: String = ArticleSortEnum.newest.rawValue
    
    // MARK: - Methods
    override static func primaryKey() -> String? {
        return "id"
    }
}

