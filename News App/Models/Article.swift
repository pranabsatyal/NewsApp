//
//  Article.swift
//  Assignment12
//
//  Created by Pranab Raj Satyal on 7/8/21.
//

import Foundation

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

// More changes in article
