//
//  ProductCellPresenter.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 15.04.2024.
//

import Foundation
import Kingfisher

protocol ProductCollectionViewCellPresenterProtocol: AnyObject {
    func loadProducts()
    func productDetailTapped(index: IndexPath)
    func stepperButtonPressed(increment: Bool, indexPath: IndexPath)
}

protocol ProductCollectionViewCellPresenterDelegate: AnyObject {
    func didupdateProductView(at: IndexPath)
    func updateCart(product: ProductDisplayable, increment: Bool)
    func productTapped(product: ProductDisplayable, at: IndexPath)
}

final class ProductCollectionViewCellPresenter {
    weak var view:ProductCollectionViewCellProtocol?
    weak var delegate: ProductCollectionViewCellPresenterDelegate?
    private var product: ProductDisplayable
    
    init(view: ProductCollectionViewCellProtocol,
         delegate: ProductCollectionViewCellPresenterDelegate,
         product: ProductDisplayable
    ) {
        self.view = view
        self.product = product
        self.delegate = delegate
    }
}

extension ProductCollectionViewCellPresenter: ProductCollectionViewCellPresenterProtocol {
    func productDetailTapped(index: IndexPath) {
        delegate?.productTapped(product: product, at: index)
    }
    
    func updateQuantityVisibility(product: ProductDisplayable) {
        let shouldChange = product.quantity < 1
        view?.setBorderColor(isAdded: shouldChange)
        view?.setQuantityLabelVisibility(hidden: shouldChange)
        view?.setDecreaseButtonVisibility(hidden: shouldChange)
    }
    
    func stepperButtonPressed(increment: Bool, indexPath: IndexPath) {
        delegate?.updateCart(product: product, increment: increment)
        delegate?.didupdateProductView(at: indexPath)
        view?.setProductQuantity(product.quantity)
    }
    
    func loadProducts() {
        self.view?.showSkeletons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view?.setProductImage(self.product.thumbnailURL ?? "")
            self.view?.setProductPrice(self.product.priceText ?? "")
            self.view?.setProductName(self.product.name ?? "")
            self.view?.setProductAttribute(self.product.attribute ?? "")
            self.view?.setProductQuantity(self.product.quantity)
            
            if self.product.thumbnailURL == nil {
                self.view?.setProductImage(self.product.squareThumbnailURL ?? "")
            }
            
            if self.product.attribute == nil {
                self.view?.setProductAttribute(self.product.shortDescription ?? "")
            }
            self.updateQuantityVisibility(product: self.product)
            self.view?.hideSkeletons()
        }
    }
}
