//
//  EndPointType.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import Foundation
import Alamofire

protocol APIRouterProtocol: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
}

enum APIRouter: APIRouterProtocol {
    case fetchProducts
    case fetchSuggestedProducts
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .fetchProducts:
            return .get
        case .fetchSuggestedProducts:
            return .get
        }
    }
    // MARK: - Path
    var path: String {
        switch self {
        case .fetchProducts:
            return "/products"
        case .fetchSuggestedProducts:
            return "/suggestedProducts"
        }
    }
    // MARK: - URLRequest
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: APIConfig.BASE_URL) else { throw NetworkError.invalidURL }
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        return urlRequest
    }
}
