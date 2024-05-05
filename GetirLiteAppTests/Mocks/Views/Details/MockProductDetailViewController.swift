//
//  MockProductDetailViewController.swift
//  GetirLiteAppTests
//
//  Created by Erkut Ter on 5.05.2024.
//

import Foundation
@testable import GetirLiteApp
import UIKit

final class MockProductDetailViewController: ProductDetailViewControllerProtocol {
    var isAddToCartButtonShown = false
    var isStepperShown = false
    var product: ProductDisplayable?
    var cartButtonConfigured = false
    var productImageURL: String?
    var productPrice: String?
    var productName: String?
    var productAttribute: String?
    var productQuantity: Int?
    
    func showAddtoCartButton() {
        isAddToCartButtonShown = true
        isStepperShown = false
    }
    
    func showStepper() {
        isStepperShown = true
        isAddToCartButtonShown = false
    }
    
    func configure(product: GetirLiteApp.ProductDisplayable) {
        self.product = product
    }
    
    func configureCartButton(cartButton: UIView) {
        cartButtonConfigured = true
    }
    
    func setProductImage(_ url: String) {
        productImageURL = url
        
    }
    
    func setProductPrice(_ priceText: String) {
        productPrice = priceText
        
    }
    
    func setProductName(_ name: String) {
        productName = name
        
    }
    
    func setProductAttribute(_ attribute: String) {
        productAttribute = attribute
        
    }
    
    func setProductQuantity(_ quantity: Int) {
        productQuantity = quantity
        
    }
}
