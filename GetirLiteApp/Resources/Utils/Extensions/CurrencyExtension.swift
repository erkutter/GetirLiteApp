//
//  CurrencyExtension.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 24.04.2024.
//

import Foundation

extension Double {
    func asTurkishLiraCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.currencySymbol = "₺"
        formatter.currencyDecimalSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "₺0,00"
    }
}
