//
//  WebService.swift
//  GNewsApp
//
//  Created by vladikkk on 26/11/2021.
//

import Foundation

// MARK: - Web Service
class WebService {
    // Mark: - Shared instance
    static let shared = WebService()
    
    // Mark: - Initializers
    private init () {}
    
    // Mark: - Properties
    private let baseURLString = "https://gnews.io/api/v4/"
    private let APIToken = "2095cca668c3535f52997e59f3c482dd"
    private var request: URLRequest?
    
    // Mark: - Methods
    private func handleRequest(completion: @escaping (Data) -> Void) {
        if let request = self.request {
            URLSession.shared.dataTask(with: request) { data, _, err in
                // Check for error
                if let error = err {
                    fatalError("Fatal Error: \(error)")
                }
                
                // Handle data
                if let data = data {
                    completion(data)
                }
            }.resume()
        }
    }
    
    func getTopHeadlines(completion: @escaping (NewsModel) -> Void) {
        guard let url = URL(string: baseURLString + "top-headlines?token=\(APIToken)") else { return }
        
        request = URLRequest(url: url)
        
        handleRequest { data in
            guard let headlines = try? JSONDecoder().decode(NewsModel.self, from: data) else {
                return
            }
            
            completion(headlines)
        }
    }
    
    func searchForArticle(title: String, filters: [ArticleFilterEnum]?, sort: ArticleSortEnum?, completion: @escaping (NewsModel) -> Void) {
        var searchUrlString = baseURLString + "search?&q=\(title)"
        
        // Get filters & sort type
        if let filters = filters {
            filters.forEach { filter in
                if let filterStr = filter.getFilters() {
                    searchUrlString += filterStr.joined()
                }
            }
            
            if let sortString = sort?.rawValue {
                searchUrlString += "&sortby=\(sortString)"
            }
            
            // Add token
            searchUrlString += "&token=\(APIToken)"
        }
        
        // Setup URL string
        guard let url = URL(string: searchUrlString) else { return }
        
        request = URLRequest(url: url)
        
        handleRequest { data in
            guard let headlines = try? JSONDecoder().decode(NewsModel.self, from: data) else {
                return
            }
            
            completion(headlines)
        }
    }
}
