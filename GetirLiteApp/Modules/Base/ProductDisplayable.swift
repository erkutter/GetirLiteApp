//
//  ProductDisplayable.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 23.04.2024.
//

import Foundation

class ProductDisplayable {
    var id: String?
    var name: String?
    var attribute: String?
    var price: Double?
    var priceText: String?
    var imageURL: String?
    var thumbnailURL: String?
    var squareThumbnailURL: String?
    var shortDescription: String?
    var quantity: Int

    init(product: ProductProtocol, quantity: Int = 0) {
        self.id = product.id
        self.name = product.name
        self.attribute = product.attribute
        self.price = product.price
        self.priceText = product.priceText
        self.imageURL = product.imageURL
        self.thumbnailURL = product.thumbnailURL
        self.squareThumbnailURL = product.squareThumbnailURL
        self.shortDescription = product.shortDescription
        self.quantity = quantity
    }
}
