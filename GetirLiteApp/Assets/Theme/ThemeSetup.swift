//
//  Theme.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//
import Foundation
import UIKit

struct ThemeSetup {
    let themeColor: ThemeColor
    let themeFont: ThemeFont
    
    fileprivate init(themeColor: ThemeColor, themeFont: ThemeFont) {
        self.themeColor = themeColor
        self.themeFont = themeFont
    }
}

struct ThemeColor {
    /// Purple Color
    let main: UIColor
    /// White Color
    let background: UIColor
    /// White (-1 Darker)
    let border: CGColor
    /// Black Color
    let text: UIColor
    /// Gray Color
    let subText: UIColor
    
    fileprivate init(main: UIColor, background: UIColor, border: CGColor, text: UIColor, subText: UIColor) {
        self.main = main
        self.background = background
        self.border = border
        self.text = text
        self.subText = subText
    }
}

struct ThemeFont {
    /// Bold - 14
    let headline: UIFont
    /// SemiBold -12
    let subline: UIFont
    /// Bold -20
    let productDetailPriceSize: UIFont
    /// SemiBold -16
    let productDetailNameSize: UIFont
    
    fileprivate init(headline: UIFont, subline: UIFont, productDetailPriceSize: UIFont, productDetailNameSize: UIFont) {
        self.headline = headline
        self.subline = subline
        self.productDetailPriceSize = productDetailPriceSize
        self.productDetailNameSize = productDetailNameSize
    }
}

extension ThemeSetup {
    static var defaultTheme: ThemeSetup {
        return ThemeSetup(
            themeColor: ThemeColor(
                main: UIColor(resource: .main),
                background: UIColor(resource: .background),
                border: UIColor(resource: .border).cgColor,
                text: UIColor(resource: .text),
                subText: UIColor(resource: .subText)
            ),
            themeFont: ThemeFont(
                headline: UIFont(name: FontSetup.boldFontName, size: FontSetup.headlineSize) ?? .systemFont(ofSize: FontSetup.headlineSize, weight: .bold),
                subline: UIFont(name: FontSetup.semiBoldFontName, size: FontSetup.sublineSize) ?? .systemFont(ofSize: FontSetup.sublineSize, weight: .semibold),
                productDetailPriceSize: UIFont(name: FontSetup.boldFontName, size: FontSetup.productDetailPriceSize) ?? 
                    .systemFont(ofSize: FontSetup.headlineSize, weight: .bold),
                productDetailNameSize:  UIFont(name: FontSetup.semiBoldFontName, size: FontSetup.productDetailNameSize) ?? 
                    .systemFont(ofSize: FontSetup.headlineSize, weight: .semibold)
            )
        )
    }
}
