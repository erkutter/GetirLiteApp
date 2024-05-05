//
//  CartPresenter.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 19.04.2024.
//

import Foundation

protocol CartPresenterProtocol: AnyObject {
    func cartButtonClicked()
}
protocol CartPresenterDelegate: AnyObject {
    func cartButtonClicked()
    func cartDidUpdate(cart: Cart)
}

final class CartPresenter {
    weak var delegate: CartPresenterDelegate?
    var view: CartButtonViewProtocol!
    private var cart: Cart?
    
    init(delegate: CartPresenterDelegate, view: CartButtonViewProtocol) {
        self.delegate = delegate
        self.view = view
      
    }
}

extension CartPresenter: CartPresenterProtocol {
    func cartButtonClicked() {
        delegate?.cartButtonClicked()
    }
}
extension CartPresenter: CartPresenterDelegate {
    func cartDidUpdate(cart: Cart) {
        let cartTotal = cart.totalPrice
        let formattedTotal = String(format: "%.2f", cartTotal)
        view.updateCartPriceLabel(formattedTotal)
    }
}
