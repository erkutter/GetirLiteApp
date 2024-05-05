//
//  BackgroundDecorationView.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 15.04.2024.
//

import UIKit

final class ProductListingCellDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
