//
//  WebService.swift
//  GNewsApp
//
//  Created by vladikkk on 26/11/2021.
//

import Foundation
import RxSwift

// MARK: - API Request Type
public enum RequestType: String {
    case GET, POST
}

// MARK: - API Request
protocol APIRequest {
    var method: RequestType { get }
    var endpoint: String { get }
    var parameters: [String: String] { get }
}

extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}

// MARK: - TopHeadlines Request
class TopHeadlinesRequest: APIRequest {
    var method: RequestType = .GET
    var endpoint: String = "top-headlines"
    var parameters: [String : String] = [String : String]()
    
    init(token: String) {
        parameters["token"] = token
        parameters["lang"] = "en"
    }
}

// MARK: - Web Service
class WebService {
    // Mark: - Shared instance
    static let shared = WebService()
    
    // Mark: - Initializers
    private init () {}
    
    // Mark: - Properties
    private let baseURL = URL(string: "https://gnews.io/api/v4")!
    private let APIToken = ""
    
    // Mark: - Methods
    private func handleRequest<T: Codable>(request: URLRequest) -> Observable<T> {
        return URLSession.shared.rx.data(request: request)
            .map { data in
                try JSONDecoder().decode(T.self, from: data)
            }
            .observe(on: MainScheduler.instance)
    }
    
    func getTopHeadlines<T: Codable>() -> Observable<T> {
        let request = TopHeadlinesRequest(token: APIToken).request(with: baseURL)
        
        return handleRequest(request: request)
    }
    
    //    func searchForArticle(title: String, filters: [ArticleFilterEnum]?, sort: ArticleSortEnum?, completion: @escaping (NewsModel) -> Void) {
    //        var searchUrlString = baseURLString + "search?&q=\(title)"
    //
    //        // Get filters & sort type
    //        if let filters = filters {
    //            filters.forEach { filter in
    //                if let filterStr = filter.getFilters() {
    //                    searchUrlString += filterStr.joined()
    //                }
    //            }
    //
    //            if let sortString = sort?.rawValue {
    //                searchUrlString += "&sortby=\(sortString)"
    //            }
    //
    //            // Add token
    //            searchUrlString += "&token=\(APIToken)"
    //        }
    //
    //        // Setup URL string
    //        guard let url = URL(string: searchUrlString) else { return }
    //
    //        request = URLRequest(url: url)
    //
    //        handleRequest { data in
    //            guard let headlines = try? JSONDecoder().decode(NewsModel.self, from: data) else {
    //                return
    //            }
    //
    //            completion(headlines)
    //        }
    //    }
}
