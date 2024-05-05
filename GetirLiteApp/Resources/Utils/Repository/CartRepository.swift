//
//  CartRepositort.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 22.04.2024.
//

import Foundation
import RealmSwift

protocol CartRepositoryProtocol: AnyObject {
    func getCurrentCartTotalPrice() -> Double
    func getCurrentCart() -> Cart?
    func fetchCart() -> Cart?
    func fetchQuantity(productId: String) -> Int
    func deleteAllDataFromRealm()
    func deleteAllItemsInCart()
    func fetchQuantities(for productIds: [String]) -> [String: Int]
    func updateQuantity(productId: String, productName: String, productAttribute: String, productThumbnailURL: String, productPrice: Double, productPriceText: String, productQuantity: Int, increment: Bool) -> Cart?
    func fetchQuantityy(productId: String) -> [String: Int]
    func updateCartItemQuantity(cartItemId: String, increment: Bool)
}

final class CartRepository: CartRepositoryProtocol {
    func deleteAllItemsInCart() {
        let realm = try! Realm()
        try! realm.write {
            let allItems = realm.objects(CartItem.self)
            realm.delete(allItems)
        }
    }
    
    func getCurrentCartTotalPrice() -> Double {
        let realm = try! Realm()
        return realm.objects(Cart.self).first?.totalPrice ?? 0.0
    }
    
    private func createNewCart() -> Cart {
        let realm = try! Realm()
        let newCart = Cart()
        try! realm.write {
            realm.add(newCart)
        }
        return newCart
    }
    
    func deleteAllDataFromRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func getCurrentCart() -> Cart? {
        let realm = try! Realm()
        return realm.objects(Cart.self).first
    }
    
    func fetchCart() -> Cart? {
        let realm = try! Realm()
        if let cart = realm.objects(Cart.self).first {
            return cart
        } else {
            return createNewCart()
        }
    }
    
    func updateQuantity(productId: String, productName: String, productAttribute: String, productThumbnailURL: String, productPrice: Double, productPriceText: String, productQuantity: Int, increment: Bool) -> Cart? {
        let realm = try! Realm()
        try! realm.write {
            if let cart = realm.objects(Cart.self).first {
                let filteredItems = cart.items.filter("id == %@", productId)
                if let product = filteredItems.first {
                    product.quantity += (increment ? 1 : -1)
                    if product.quantity <= 0 {
                        realm.delete(product)
                    }
                } else if increment {
                    let newCartItem = CartItem()
                    newCartItem.id = productId
                    newCartItem.name = productName
                    newCartItem.productAttribute = productAttribute
                    newCartItem.thumbnailURL = productThumbnailURL
                    newCartItem.priceText = productPriceText
                    newCartItem.price = productPrice
                    newCartItem.quantity = 1
                    cart.items.append(newCartItem)
                }
            }
        }
        let updatedCart = self.getCurrentCart()
        return updatedCart
    }
    
    func fetchQuantities(for productIds: [String]) -> [String: Int] {
        let realm = try! Realm()
        var quantities = [String: Int]()
        for id in productIds {
            if let cartItem = realm.objects(CartItem.self).filter("id == %@", id).first {
                quantities[id] = cartItem.quantity
            } else {
                quantities[id] = 0
            }
        }
        return quantities
    }
    
    func fetchQuantity(productId: String) -> Int {
        let realm = try! Realm()
        if let cartItem = realm.objects(CartItem.self).filter("id == %@", productId).first {
            return cartItem.quantity
        } else {
            return 0
        }
    }
    
    func fetchQuantityy(productId: String) -> [String: Int] {
        let realm = try! Realm()
        if let cartItem = realm.objects(CartItem.self).filter("id == %@", productId).first {
            return [productId: cartItem.quantity]  // Returning dictionary with ID and quantity
        } else {
            return [productId: 0]  // Return ID with a quantity of 0 if the product is not found
        }
    }
    
    func updateCartItemQuantity(cartItemId: String, increment: Bool) {
            let realm = try! Realm()

            try! realm.write {
                if let cart = realm.objects(Cart.self).first {
                    let filteredItems = cart.items.filter("id == %@", cartItemId)
                    if let product = filteredItems.first {
                        if increment {
                            product.quantity += 1
                        } else {
                            if product.quantity > 1 {
                                product.quantity -= 1
                            } else if product.quantity == 1 {
                                realm.delete(product)
                            }
                        }
                    }
                }
            }
        }
}
