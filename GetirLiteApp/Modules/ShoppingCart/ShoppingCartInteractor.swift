//
//  ShoppingCartInteractor.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 22.04.2024.
//

import Foundation

protocol ShoppingCartInteractorProtocol {
    func fetchCartItems()
    func fetchSuggestedProducts()
    func deleteItemsInCart()
    func fetchQuantity(product: ProductDisplayable)
    func emptyCart(completion: @escaping () -> Void)
    func updateItemQuantity(cartItem: CartItem, increment: Bool)
    func updateCart(productId: String, productName: String, productAttribute: String, productThumbnailURL: String, productPrice: Double, productPriceText: String, productQuantity: Int, increment:Bool, completion: @escaping () -> Void)
}

protocol ShoppingCartInteractorOutputProtocol {
    func fetchCartItemsOutput(cartItems: Cart)
    func fetchSuggestedProductsOutput(suggestedProducts: [SuggestedProductList]) 
    func updatedCartOutput(cart: Cart)
    func fetchQuantityOutput(quantity: [String:Int])
}

final class ShoppingCartInteractor {
    var output: ShoppingCartInteractorOutputProtocol?
    private let productRepository: ProductRepositoryProtocol!
    private let cartRepository: CartRepositoryProtocol!
    
    init(productRepository: ProductRepositoryProtocol, cartRepository: CartRepositoryProtocol) {
        self.productRepository = productRepository
        self.cartRepository = cartRepository
    }
}

extension ShoppingCartInteractor: ShoppingCartInteractorProtocol {
    func fetchQuantity(product: ProductDisplayable) {
        let quantity = cartRepository.fetchQuantityy(productId: product.id ?? "")
        output?.fetchQuantityOutput(quantity: quantity)
    }
    
    func updateCart(productId: String, productName: String, productAttribute: String, productThumbnailURL: String, productPrice: Double, productPriceText: String, productQuantity: Int, increment: Bool, completion: @escaping () -> Void) {
        guard let updatedCart = cartRepository.updateQuantity(productId: productId, productName: productName, productAttribute: productAttribute, productThumbnailURL: productThumbnailURL, productPrice: productPrice, productPriceText: productPriceText, productQuantity: productQuantity, increment: increment) else { return }
        output?.updatedCartOutput(cart: updatedCart)
        completion()
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
    
    func updateItemQuantity(cartItem: CartItem, increment: Bool) {
        cartRepository.updateCartItemQuantity(cartItemId: cartItem.id, increment: increment)
    }
    
    func deleteItemsInCart() {
        cartRepository.deleteAllItemsInCart()
    }
    
    func emptyCart(completion: @escaping () -> Void) {
        cartRepository.deleteAllDataFromRealm()
    }
    
    func fetchCartItems() {
        guard let cartItems = cartRepository.getCurrentCart() else { return }
        output?.fetchCartItemsOutput(cartItems: cartItems)
    }
}
