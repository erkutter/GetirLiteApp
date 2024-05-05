//
//  ShoppingCollectionViewCell.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 23.04.2024.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

protocol ShoppingCartCollectionViewCellProtocol: AnyObject {
    func setProductImage(_ url: String)
    func setProductPrice(_ priceText: String)
    func setProductName(_ name: String)
    func setProductAttribute(_ attribute: String)
    func setProductQuantity(_ quantity: Int)
}

final class ShoppingCartCollectionViewCell: UICollectionViewCell {
    private var productQuantity: Int?
    
    private lazy var horizontalStepper = StepperView(frame: CGRect(x: 0, y: 0, width: 102, height: 32), orientation: .horizontal)
    
    var shoppingCartCollectionViewCellPresenter: ShoppingCartCollectionViewCellPresenterProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStepperActions()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStepperActions() {
        horizontalStepper.setAddAction(target: self, action: #selector(stepperButtonTapped(_:)))
        horizontalStepper.setDecreaseAction(target: self, action: #selector(stepperDecreaseButtonTapped(_:)))
    }
    
    @objc private func stepperButtonTapped(_ sender: UIButton) {
        guard let presenter = shoppingCartCollectionViewCellPresenter else {
            fatalError("Presenter was not set on ProductCollectionViewCell")
        }
        presenter.didStepperButtonPressed(increment: true)
    }
    
    @objc private func stepperDecreaseButtonTapped(_ sender: UIButton) {
        guard let presenter = shoppingCartCollectionViewCellPresenter else {
            fatalError("Presenter was not set on ProductCollectionViewCell")
        }
        presenter.didStepperButtonPressed(increment: false)
    }

    private lazy var productImageViewContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = ThemeSetup.defaultTheme.themeColor.border
        return view
    }()
    
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "₺0,00"
        label.font = ThemeSetup.defaultTheme.themeFont.headline
        label.textColor = ThemeSetup.defaultTheme.themeColor.main
        label.textAlignment = .left
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Name"
        label.font = ThemeSetup.defaultTheme.themeFont.subline
        label.textColor = ThemeSetup.defaultTheme.themeColor.text
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var productAttributeLabel: UILabel = {
        let label = UILabel()
        label.text = "ATTRIBUTE"
        label.font = ThemeSetup.defaultTheme.themeFont.subline
        label.textColor = ThemeSetup.defaultTheme.themeColor.subText
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    //
    private lazy var splitterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.949, green: 0.941, blue: 0.98, alpha: 1) // Degıs
        return view
    }()
    
    func setupViews() {
        contentView.addSubview(productImageViewContainer)
        productImageViewContainer.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productAttributeLabel)
        contentView.addSubview(productPriceLabel)
        contentView.addSubview(splitterView)
        contentView.addSubview(horizontalStepper)
        
        
        productImageViewContainer.snp.makeConstraints { make in
            make.width.height.equalTo(74)
            make.top.leading.bottom.equalToSuperview()
        }
        productImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        productNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageViewContainer.snp.trailing).offset(12)
            make.width.equalTo(120)
            make.top.equalToSuperview().offset(8)
        }
        productAttributeLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageViewContainer.snp.trailing).offset(12)
            make.top.equalTo(productNameLabel.snp.bottom).offset(2)
        }
        productPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageViewContainer.snp.trailing).offset(12)
            make.top.equalTo(productAttributeLabel.snp.bottom).offset(4)
        }
        splitterView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(productImageViewContainer.snp.bottom).offset(12)
        }
        horizontalStepper.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().inset(12)
        }
    }
}

extension ShoppingCartCollectionViewCell: ShoppingCartCollectionViewCellProtocol {
    func setProductImage(_ url: String) {
        guard let url = URL(string: url) else { return }
        productImageView.kf.setImage(with: url)
    }
    
    func setProductPrice(_ priceText: String) {
        productPriceLabel.text = priceText
    }
    
    func setProductName(_ name: String) {
        productNameLabel.text = name
    }
    
    func setProductAttribute(_ attribute: String) {
        productAttributeLabel.text = attribute
    }
    
    func setProductQuantity(_ quantity: Int) {
        horizontalStepper.updateQuantityLabel(quantity: quantity)
    }
}
