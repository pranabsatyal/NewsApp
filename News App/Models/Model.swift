//
//  Model.swift
//  Assignment12
//
//  Created by Pranab Raj Satyal on 7/8/21.
//

import Foundation

struct Model: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// Made some changes to Model
