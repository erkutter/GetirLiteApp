//
//  MockProductDetailPresenter.swift
//  GetirLiteAppTests
//
//  Created by Erkut Ter on 5.05.2024.
//

import Foundation
@testable import GetirLiteApp

final class MockProductDetailPresenter: ProductDetailPresenterProtocol {
    var isAddToCartButtonShown = false
        var productConfigured: ProductDisplayable?
        var stepperPressedIncrement: Bool?
        var quantityFetched: Int?
    
    func isAddToCartShow() -> Bool {
        return isAddToCartButtonShown
    }
    
    func stepperButtonPressed(increment: Bool) {
            stepperPressedIncrement = increment
            // Simulate logic that might be in the actual presenter
            if let product = productConfigured {
                let newQuantity = product.quantity + (increment ? 1 : -1)
                isAddToCartButtonShown = newQuantity == 0
            }
        }
    
    func configure(product: GetirLiteApp.ProductDisplayable) {
            productConfigured = product
            // Simulate setting initial state based on product quantity
            isAddToCartButtonShown = product.quantity == 0
        }
}

extension MockProductDetailPresenter: ProductDetailInteractorOutputProtocol {
    func fetchProductQuantityOutput(quantity: Int) {
            quantityFetched = quantity
            // Simulate updating view based on quantity fetched
            if quantity == 0 {
                isAddToCartButtonShown = true
            } else {
                isAddToCartButtonShown = false
            }
        }
}
