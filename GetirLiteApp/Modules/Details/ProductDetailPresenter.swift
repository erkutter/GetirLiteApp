//
//  ProductDetailPresenter.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 24.04.2024.
//

import Foundation

protocol ProductDetailPresenterProtocol: AnyObject {
    func isAddToCartShow() -> Bool
    func stepperButtonPressed(increment: Bool)
    func configure(product: ProductDisplayable)
}

final class ProductDetailPresenter {
    weak var view: ProductDetailViewControllerProtocol!
    private let interactor: ProductDetailInteractorProtocol!
    private let router: ProductDetailRouterProtocol!
    private var product: ProductDisplayable?
    
    init(view: ProductDetailViewControllerProtocol!, interactor: ProductDetailInteractorProtocol!, router: ProductDetailRouterProtocol!) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    private func fetchUpdatedProductQuantity() {
        guard let product = self.product else { return }
        interactor.fetchQuantities(product: product)
        if product.quantity == 0 {
            self.view.showAddtoCartButton()
        } else {
            self.view.showStepper()
        }
    }
    
    func stepperButtonPressed(increment: Bool) {
        guard let productId = product?.id else { return }
        guard let productName = product?.name else { return  }
        let productAttribute = (product?.attribute ?? product?.shortDescription ?? "")
        guard let productThumbnailURL = product?.thumbnailURL else { return }
        guard let productPrice = product?.price else { return }
        guard let productPriceText = product?.priceText else { return }
        let productQuantity = (product?.quantity ?? 0) + (increment ? 1 : -1)
        product?.quantity = productQuantity
        
        interactor.updateCart(productId: productId, productName: productName, productAttribute: productAttribute, productThumbnailURL: productThumbnailURL, productPrice: productPrice, productPriceText: productPriceText, productQuantity: productQuantity, increment: increment) {
            self.fetchUpdatedProductQuantity()
        }
    }
    
    func isAddToCartShow() -> Bool {
        if product?.quantity == 0 {
            return true
        } else {
            return false
        }
    }
    
    func configure(product: ProductDisplayable) {
        view.setProductName(product.name ?? "")
        view.setProductImage(product.thumbnailURL ?? "")
        view.setProductPrice(product.priceText ?? "")
        view.setProductAttribute(product.attribute ?? "")
        view.setProductQuantity(product.quantity)
        self.product = product
        
        if product.quantity == 0 {
            self.view.showAddtoCartButton()
        } else {
            self.view.showStepper()
        }
    }
}

extension ProductDetailPresenter: ProductDetailInteractorOutputProtocol {
    func fetchProductQuantityOutput(quantity: Int) {
        view.setProductQuantity(quantity)
    }
}
