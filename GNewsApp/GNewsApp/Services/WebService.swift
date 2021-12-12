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
    // MARK: - Properties
    var method: RequestType { get }
    var endpoint: String { get }
    var parameters: [String: String] { get }
}

extension APIRequest {
    // MARK: - Methods
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
    // MARK: - Properties
    var method: RequestType = .GET
    var endpoint: String = "top-headlines"
    var parameters: [String : String] = [String : String]()
    
    // MARK: - Initializers
    init(token: String) {
        parameters["token"] = token
        parameters["lang"] = "en"
    }
}

// MARK: - TopHeadlines Request
class SearchRequest: APIRequest {
    var method: RequestType = .GET
    var endpoint: String = "search"
    var parameters: [String : String] = [String : String]()
    
    // MARK: - Initializers
    init(token: String, title: String, filters: [String], sort: ArticleSortEnum) {
        parameters["q"] = title
        parameters["from"] = filters[0]
        parameters["to"] = filters[1]
        parameters["in"] = filters[2]
        parameters["sortby"] = sort.rawValue
        parameters["token"] = token
        parameters["lang"] = "en"
    }
}

// MARK: - Web Service
class WebService {
    // MARK: - Shared instance
    static let shared = WebService()
    
    // MARK: - Initializers
    private init () {}
    
    // MARK: - Properties
    private let baseURL = URL(string: "https://gnews.io/api/v4")!
    private let APIToken = ""
    
    // MARK: - Methods
    
    // MARK: - Genereic request handler
    internal func handleRequest<T: Codable>(request: URLRequest) -> Observable<T> {
        return URLSession.shared.rx.data(request: request)
            .map { data in
                try JSONDecoder().decode(T.self, from: data)
            }
    }
    
    // MARK: - Get top headlines request
    func getTopHeadlines<T: Codable>() -> Observable<T> {
        let request = TopHeadlinesRequest(token: APIToken).request(with: baseURL)
        
        return handleRequest(request: request)
    }
    
    // MARK: - Get search result request
    func getSearchResult<T: Codable>(title: String, filters: [String], sort: ArticleSortEnum) -> Observable<T> {
        let request = SearchRequest(token: APIToken, title: title, filters: filters, sort: sort).request(with: baseURL)
        
        return handleRequest(request: request)
    }
}

// MARK: - ImageService
class ImageService {
    // MARK: - Properties
    let image = PublishSubject<UIImage>()
    
    // MARK: - Image cache. Store images for one day.
    private let imageCache = ImageCache<String, UIImage>(cacheTTL: TimeInterval(86400))
    
    // MARK: - Shared instance
    static let shared = ImageService()
    
    // MARK: - WebService instance
    private let webService = WebService.shared
    
    // MARK: - Initializers
    private init () {}
    
    // MARK: - Methods
    private func downloadImage(withStringUrl stringUrl: String) -> Observable<UIImage?> {
        if let validUrl = URL(string: stringUrl) {
            let request = URLRequest(url: validUrl)
            
            return URLSession.shared.rx.data(request: request)
                .map { data in
                    if let image = UIImage(data: data) {
                        self.imageCache.save(key: stringUrl, item: image)
                        
                        return image
                    }
                    return nil
                }
        }
        
        return .never()
    }
    
    func loadImage(usingStringUrl stringUrl: String) -> Observable<UIImage?> {
        if let cachedImage = imageCache.load(key: stringUrl) {
            return .just(cachedImage)
        }
        
        return downloadImage(withStringUrl: stringUrl)
    }
}
