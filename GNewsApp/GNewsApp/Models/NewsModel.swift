//
//  NewsModel.swift
//  GNewsApp
//
//  Created by vladikkk on 26/11/2021.
//

import Foundation
// MARK: - News Model
struct NewsModel: Codable {
    let totalArticles: Int
    let articles: [ArticleModel]
}

// MARK: - Article Model
struct ArticleModel: Codable {
    let title: String
    let description: String
    let content: String
    let url: String
    let image: String
    let publishedAt: String
    let source: SourceModel
}

// MARK: - Source Model
struct SourceModel: Codable {
    let name: String
    let url: String
}
