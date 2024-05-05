//
//  ProductRepository.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import Foundation

protocol ProductRepositoryProtocol: AnyObject {
    func fetchProducts() async throws -> [ProductList]
    func fetchSuggestedProducts() async throws -> [SuggestedProductList]
}

/// Product related network operations
final class ProductRepository: ProductRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    /// Fetch Products
    /// - Returns: Product List
    func fetchProducts() async throws -> [ProductList] {
        do {
            let products = try await networkService.fetchProducts()
            return products
        } catch {
            throw error
        }
    }
    /// Fetch Suggested Products
    /// - Returns: Suggested Products List
    func fetchSuggestedProducts() async throws -> [SuggestedProductList] {
        do {
            let suggestedProducts = try await networkService.fetchSuggestedProducts()
            return suggestedProducts
        } catch {
            throw error
        }
    }
}
