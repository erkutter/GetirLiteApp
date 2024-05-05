//
//  ShoppingCollectionViewCellPresenter.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 23.04.2024.
//

import Foundation

protocol ShoppingCartCollectionViewCellPresenterProtocol: AnyObject {
    func loadProducts()
    func didStepperButtonPressed(increment: Bool)
}

protocol ShoppingCartCollectionViewCellPresenterDelegate: AnyObject {
    func updateCartItem(cartItem: CartItem, increment: Bool)
}

final class ShoppingCartCollectionViewCellPresenter {
    weak var view: ShoppingCartCollectionViewCellProtocol?
    weak var delegate: ShoppingCartCollectionViewCellPresenterDelegate?
    private var cartItem: CartItem?
    
    init(view: ShoppingCartCollectionViewCellProtocol,
         delegate: ShoppingCartCollectionViewCellPresenterDelegate,
         cartItem: CartItem
    ) {
        self.view = view
        self.delegate = delegate
        self.cartItem = cartItem
    }
}

extension ShoppingCartCollectionViewCellPresenter: ShoppingCartCollectionViewCellPresenterProtocol {
    func didStepperButtonPressed(increment: Bool) {
        guard let cartItem = cartItem else { return }
        delegate?.updateCartItem(cartItem: cartItem, increment: increment)
    }
    
    func loadProducts() {
        guard let cartItem = cartItem else { return }
        self.view?.setProductName(cartItem.name)
        self.view?.setProductImage(cartItem.thumbnailURL)
        self.view?.setProductPrice(cartItem.priceText)
        self.view?.setProductQuantity(cartItem.quantity)
        self.view?.setProductAttribute(cartItem.productAttribute)
    }
}
