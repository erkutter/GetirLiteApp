//
//  MockProductDetailInteractor.swift
//  GetirLiteAppTests
//
//  Created by Erkut Ter on 5.05.2024.
//

import Foundation
@testable import GetirLiteApp

final class MockProductDetailInteractor: ProductDetailInteractorProtocol {
    var output: ProductDetailInteractorOutputProtocol?
    
    var fetchedProductID: String?
    var updatedProductID: String?
    var updatedProductName: String?
    var updatedProductAttribute: String?
    var updatedProductThumbnailURL: String?
    var updatedProductPrice: Double?
    var updatedProductPriceText: String?
    var updatedProductQuantity: Int?
    var updateIncrement: Bool?
    var fetchQuantitiesCalled = false
    var updateCartCalled = false
    
    func fetchQuantities(product: GetirLiteApp.ProductDisplayable) {
        fetchedProductID = product.id
        fetchQuantitiesCalled = true
        
        let simulatedQuantity = 3
        output?.fetchProductQuantityOutput(quantity: simulatedQuantity)
    }
    
    func updateCart(productId: String, productName: String, productAttribute: String, productThumbnailURL: String, productPrice: Double, productPriceText: String, productQuantity: Int, increment: Bool, completion: @escaping () -> Void) {
        updatedProductID = productId
        updatedProductName = productName
        updatedProductAttribute = productAttribute
        updatedProductThumbnailURL = productThumbnailURL
        updatedProductPrice = productPrice
        updatedProductPriceText = productPriceText
        updatedProductQuantity = productQuantity
        updateIncrement = increment
        updateCartCalled = true
        
        // Assume update is successful and immediately call completion.
        completion()
    }
}
