//
//  ProductListingInteractor.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import Foundation

protocol ProductListingInteractorProtocol {
    func fetchProducts()
    func fetchSuggestedProducts()
    func fetchCart()
    func fetchQuantities(products: [ProductDisplayable])
    func fetchSuggestedProductsQuantities(suggestedProducts: [ProductDisplayable])
    func fetchQuantity(product: ProductDisplayable)
    func updateCart(productId: String, productName: String, productAttribute: String, productThumbnailURL: String, productPrice: Double, productPriceText: String, productQuantity: Int, increment:Bool, completion: @escaping () -> Void)
}

protocol ProductListingInteractorOutputProtocol {
    func updatedCartOutput(cart: Cart)
    func fetchCartOutput(cart: Cart)
    func fetchProductsOutput(products: [ProductList])
    func fetchSuggestedProductsOutput(suggestedProducts: [SuggestedProductList])
    func fetchQuantitiesOutput(quantities: [String : Int])
    func fetchSuggestedProductsQuantitiesOutput(quantities: [String : Int])
    func fetchQuantityOutput(quantity: [String:Int])
}

final class ProductListingInteractor {
    var output: ProductListingInteractorOutputProtocol?
    private let productRepository: ProductRepositoryProtocol!
    private let cartRepository: CartRepositoryProtocol!
    
    init(productRepository: ProductRepositoryProtocol,
         cartRepository: CartRepositoryProtocol)
    {
        self.productRepository = productRepository
        self.cartRepository = cartRepository
    }
}

extension ProductListingInteractor: ProductListingInteractorProtocol {
    func updateCart(productId: String, productName: String, productAttribute: String, productThumbnailURL: String, productPrice: Double, productPriceText: String, productQuantity: Int, increment:Bool, completion: @escaping () -> Void) {
        
        guard let updatedCart = cartRepository.updateQuantity(productId: productId, productName: productName, productAttribute: productAttribute, productThumbnailURL: productThumbnailURL, productPrice: productPrice, productPriceText: productPriceText, productQuantity: productQuantity, increment: increment) else { return }
        output?.updatedCartOutput(cart: updatedCart)
        completion()
    }
    
    func fetchQuantities(products: [ProductDisplayable]) {
        let quantities = cartRepository.fetchQuantities(for: products.map { $0.id ?? "" })
        for product in products {
            product.quantity = quantities[product.id ?? ""] ?? 0
        }
        output?.fetchQuantitiesOutput(quantities: quantities)
    }
    
    func fetchQuantity(product: ProductDisplayable) {
        let quantity = cartRepository.fetchQuantityy(productId: product.id ?? "")
        output?.fetchQuantityOutput(quantity: quantity)
    }
    
    func fetchSuggestedProductsQuantities(suggestedProducts: [ProductDisplayable]) {
        let quantities = cartRepository.fetchQuantities(for: suggestedProducts.map { $0.id ?? "" })
        for suggestedProduct in suggestedProducts {
            suggestedProduct.quantity = quantities[suggestedProduct.id ?? ""] ?? 0
        }
        output?.fetchSuggestedProductsQuantitiesOutput(quantities: quantities)
    }
    
    func fetchSuggestedProducts() {
        Task{
            do {
                let suggestedProducts = try await productRepository.fetchSuggestedProducts()
                output?.fetchSuggestedProductsOutput(suggestedProducts: suggestedProducts)
            } catch {
                
            }
        }
    }
    func fetchProducts() {
        Task{
            do {
                let products = try await productRepository.fetchProducts()
                output?.fetchProductsOutput(products: products)
            } catch {
                
            }
        }
    }
    
    func fetchCart() {
        guard let cart = cartRepository.fetchCart() else { return }
        output?.fetchCartOutput(cart: cart)
    }
}
