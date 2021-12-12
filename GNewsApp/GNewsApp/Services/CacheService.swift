//
//  CacheService.swift
//  GNewsApp
//
//  Created by vladikkk on 12/12/2021.
//

import Foundation
import UIKit

// MARK: - CacheProtocol
internal protocol CacheProtocol {
    associatedtype K
    associatedtype T
    func load(key: K) -> T?
    func save(key: K, item: T)
}

// MARK: - CacheEntry
struct CacheEntry<T> {
    // MARK: - Properties
    let key: String
    let expiresAt: Date
    let value: T
    
    // MARK: - Initializers
    init(key: String, expiresAt: Date, value: T) {
        self.key = key
        self.expiresAt = expiresAt
        self.value = value
    }
    
    var isExpired: Bool {
        expiresAt < Date()
    }
}

// MARK: - ImageCache
class ImageCache<K: Hashable, T: UIImage>: CacheProtocol {
    // MARK: - Properties
    typealias K = K
    typealias T = T
    
    var cache: [K : CacheEntry<T>] = [:]
    let cacheTTL: TimeInterval
    
    // MARK: - Initializers
    public init(cacheTTL: TimeInterval = 60) {
        self.cacheTTL = cacheTTL
    }
    
    // MARK: - Methods
    func load(key: K) -> T? {
        guard let entry = cache[key] else { return nil }
        
        if entry.isExpired {
            return nil
        }
        
        return entry.value
    }
    
    func save(key: K, item: T) {
        let entry = CacheEntry<T>(key: "\(T.self)", expiresAt: cacheExpiresAt, value: item)
        
        cache[key] = entry
    }
    
    private var cacheExpiresAt: Date {
        return Date().addingTimeInterval(cacheTTL)
    }
}
