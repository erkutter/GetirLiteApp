//
//  APIConfig.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import Foundation

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json = "application/json"
}

struct APIConfig {
    static let BASE_URL = "https://65c38b5339055e7482c12050.mockapi.io/api"
}
