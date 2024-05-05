//
//  SuggestedProduct.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import Foundation
///Horizontal Scroll Products List
struct SuggestedProductList: Codable {
    let id: String?
    let name: String?
    let products: [SuggestedProduct]?
}

struct SuggestedProduct: Codable {
    let id: String?
    let name: String?
    let squareThumbnailURL: String?
    let imageURL: String?
    let price: Double?
    let priceText: String?
    let shortDescription: String?
    let category: String?
    let unitPrice: Double?
    let status: Int?
}
