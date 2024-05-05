//
//  ProductDetailInteractor.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 24.04.2024.
//

import Foundation

protocol ProductDetailInteractorProtocol {
    func fetchQuantities(product: ProductDisplayable)
    func updateCart(productId: String, productName: String, productAttribute: String, productThumbnailURL: String, productPrice: Double, productPriceText: String, productQuantity: Int, increment:Bool, completion: @escaping () -> Void)
}

protocol ProductDetailInteractorOutputProtocol {
    func fetchProductQuantityOutput(quantity: Int)
}

final class ProductDetailInteractor {
    var output: ProductDetailInteractorOutputProtocol?
    private let cartRepository: CartRepositoryProtocol!
    
    init(cartRepository: CartRepositoryProtocol)
    {
        self.cartRepository = cartRepository
    }
}

extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    func fetchQuantities(product: ProductDisplayable) {
        let quantity = cartRepository.fetchQuantity(productId: product.id ?? "")
        output?.fetchProductQuantityOutput(quantity: quantity)
    }
    
    func updateCart(productId: String, productName: String, productAttribute: String, productThumbnailURL: String, productPrice: Double, productPriceText: String, productQuantity: Int, increment:Bool, completion: @escaping () -> Void) {
        
        guard let _ = cartRepository.updateQuantity(productId: productId, productName: productName, productAttribute: productAttribute, productThumbnailURL: productThumbnailURL, productPrice: productPrice, productPriceText: productPriceText, productQuantity: productQuantity, increment: increment) else { return }
        completion()
        
    }
}
