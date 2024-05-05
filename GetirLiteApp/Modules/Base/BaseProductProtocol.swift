//
//  BaseProductProtocol.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 23.04.2024.
//

import Foundation

protocol ProductProtocol {
    var id: String? { get }
    var name: String? { get }
    var attribute: String? { get }
    var price: Double? { get }
    var priceText: String? { get }
    var imageURL: String? { get }
    var thumbnailURL: String? { get }
    var squareThumbnailURL: String? { get }
    var shortDescription: String? { get }
    var quantity: Int { get set }
}

extension Product: ProductProtocol {
    var quantity: Int {
        get { return 0 }
        set {}
    }
    var squareThumbnailURL: String? { return self.thumbnailURL }
}

extension SuggestedProduct: ProductProtocol {
    var quantity: Int {
        get { return 0 }
        set {}
    }
    var attribute: String? { return self.shortDescription }
    var thumbnailURL: String? { return self.imageURL }
}
