//
//  NetworkError.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case dataConversionFailure
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed:
            return "The server encountered an error."
        case .invalidResponse:
            return "The response is invalid."
        case .dataConversionFailure:
            return "Failed to decode the data."
        }
    }
}


