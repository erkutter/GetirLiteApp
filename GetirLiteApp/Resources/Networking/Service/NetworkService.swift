//
//  NetworkService.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol: AnyObject {
    func fetchProducts() async throws -> [ProductList]
    func fetchSuggestedProducts() async throws -> [SuggestedProductList]
}

final class NetworkService: NetworkServiceProtocol {
    /// Fetch products from API
    /// - Returns: Product List Array
    func fetchProducts() async throws -> [ProductList] {
        do {
            let request = AF.request(APIRouter.fetchProducts)
            let response = try await request.serializingDecodable([ProductList].self).value
            return response
        } catch {
            throw NetworkError.invalidResponse
        }
    }
    
    /// Fetch Suggested Products from API
    /// - Returns: Suggested Product List Array
    func fetchSuggestedProducts() async throws -> [SuggestedProductList] {
        do {
            let request = AF.request(APIRouter.fetchSuggestedProducts)
            let response = try await request.serializingDecodable([SuggestedProductList].self).value
            return response
        } catch {
            throw NetworkError.invalidResponse
        }
    }
}
