//
//  Cart.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 19.04.2024.
//

import Foundation
import RealmSwift

class CartItem: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var productAttribute: String = ""
    @objc dynamic var thumbnailURL: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var priceText: String = ""
    @objc dynamic var quantity: Int = 0

    override static func primaryKey() -> String? {
        return "id"
    }
}

class Cart: Object {
    // List of items (to-many relationship)
    let items = List<CartItem>()

    var totalPrice: Double {
        return items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}

