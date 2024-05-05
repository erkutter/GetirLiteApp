//
//  ProductEntity.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import Foundation
///Vertical Scroll Products List
struct ProductList: Codable {
    let id: String?
    let name: String?
    let productCount: Int?
    let products: [Product]?
}

struct Product: Codable {
    let id: String?
    let name: String?
    let attribute: String?
    let thumbnailURL: String?
    let imageURL: String?
    let price: Double?
    let priceText: String?
    let shortDescription: String?
}
