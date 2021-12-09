//
//  FilterSortEnums.swift
//  GNewsApp
//
//  Created by vladikkk on 26/11/2021.
//

import Foundation

// MARK: - Filter enums
enum ArticleFilterEnum {
    case date(DateEnum, DateEnum)
    case part(ArticlePartEnum?, ArticlePartEnum?, ArticlePartEnum?)
    
    internal enum DateEnum {
        case from(String)
        case to(String)
        
        func getDate() -> String {
            switch self {
            case .from(let stringDate):
                return stringDate
                
            case .to(let stringDate):
                return stringDate
            }
        }
    }
    
    internal enum ArticlePartEnum: String {
        case title = "title"
        case description = "description"
        case content = "content"
    }
    
    func getFilters() -> [String]? {
        switch self {
        case .date(let fromDate, let toDate):
            let fromDateString = fromDate.getDate()
            let toDateString = toDate.getDate()
            
            return ["&from=\(fromDateString)", "&to=\(toDateString)"]
            
        case .part(let description, let content, let title):
            var part = "&in="
            
            if let tit = title?.rawValue, !part.contains(tit) {
                part += "\(tit),"
            }
            
            if let desc = description?.rawValue, !part.contains(desc) {
                part += "\(desc),"
            }
                
            if let cont = content?.rawValue, !part.contains(cont) {
                part += "\(cont),"
            }
            
            if part.last != "=" {
                part.removeLast()
                
                return [part]
            } else {
                return nil
            }
        }
    }
}

// MARK: - Sort enums
enum ArticleSortEnum: String {
    case newest = "publishedAt"
    case relevance = "relevance"
}
