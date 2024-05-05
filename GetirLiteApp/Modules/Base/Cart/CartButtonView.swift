//
//  CartButtonView.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 20.04.2024.
//

import Foundation
import UIKit

// MARK: - CartComponent

protocol CartButtonViewProtocol: AnyObject {
    func updateCartPriceLabel(_ text: String)
}

final class CartButtonView: UIView {
    var presenter: CartPresenterProtocol?
    //Init
    init() {
        super.init(frame: .zero)
        setupViews()
        addTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        addTapGestureRecognizer()
    }
   
    // Views for the cart button
    private lazy var cartButtonImageContainerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        containerView.backgroundColor = .white
        return containerView
    }()
    
    private lazy var cartButtonPriceLabelContainerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        containerView.backgroundColor = UIColor(red: 0.949, green: 0.941, blue: 0.98, alpha: 1)
        return containerView
    }()
    
    private lazy var cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cartButton")
        return imageView
    }()
    
    private lazy var cartPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "₺0,00"
        label.font = ThemeSetup.defaultTheme.themeFont.headline
        label.textColor = ThemeSetup.defaultTheme.themeColor.main
        label.textAlignment = .center
        return label
    }()
    
    private func setupViews() {
        addSubview(cartButtonImageContainerView)
        addSubview(cartButtonPriceLabelContainerView)
        cartButtonImageContainerView.addSubview(cartImageView)
        cartButtonPriceLabelContainerView.addSubview(cartPriceLabel)
        
        // Setup constraints
        snp.makeConstraints { make in
            make.width.equalTo(91)
            make.height.equalTo(34)
        }
        cartButtonImageContainerView.snp.makeConstraints { make in
            make.width.equalTo(34)
            make.top.bottom.leading.equalToSuperview()
        }
        cartButtonPriceLabelContainerView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.top.bottom.trailing.equalToSuperview()
        }
        cartImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.leading.equalToSuperview().offset(5)
        }
        cartPriceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.equalToSuperview().offset(5)
            
        }
    }
}

extension CartButtonView: CartButtonViewProtocol {
    // Functions to interact with the cart data
    func updateCartPriceLabel(_ text: String) {
        DispatchQueue.main.async {
            
            AnimationUtility.bounceTextChange(label: self.cartPriceLabel, newText: text)
        }
    }
    
    //Gesture
    func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cartButtonAction))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func cartButtonAction() {
        presenter?.cartButtonClicked()
    }
}
