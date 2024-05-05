//
//  VerticalStepperButton.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 24.04.2024.
//

import Foundation
import UIKit

enum StepperOrientation {
    case vertical
    case horizontal
}

final class StepperView: UIView {
    private var orientation: StepperOrientation
    var productQuantity: Int = 0
    
    private lazy var productStepperButtonContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private lazy var productStepperButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "stepperAdd"), for: .normal)
        button.tintColor = ThemeSetup.defaultTheme.themeColor.main
        button.backgroundColor = .white
        
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var productQuantityLabel: UILabel = {
        let label = UILabel()
        label.text = String(productQuantity)
        label.font = ThemeSetup.defaultTheme.themeFont.subline
        label.backgroundColor = ThemeSetup.defaultTheme.themeColor.main
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var productStepperDecreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "stepperDecrease"), for: .normal)
        button.tintColor = ThemeSetup.defaultTheme.themeColor.main
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return button
    }()
    
    // Initialize View
    init(frame: CGRect, orientation: StepperOrientation) {
        self.orientation = orientation
        super.init(frame: frame)
        configureLayout()
    }
    func reset() {
            productQuantityLabel.text = nil
        productStepperButton.alpha  =  1

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(productStepperButtonContainer)
        productStepperButtonContainer.addSubview(productStepperButton)
        productStepperButtonContainer.addSubview(productQuantityLabel)
        productStepperButtonContainer.addSubview(productStepperDecreaseButton)
        
        switch orientation {
        case .vertical:
            productStepperButtonContainer.snp.makeConstraints { make in
                make.width.equalTo(32)
                make.height.equalTo(96)
                make.edges.equalToSuperview()
            }
            
            productStepperButton.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(32)
            }
            
            productQuantityLabel.snp.makeConstraints { make in
                make.top.equalTo(productStepperButton.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(32)
            }
            
            productStepperDecreaseButton.snp.makeConstraints { make in
                make.top.equalTo(productQuantityLabel.snp.bottom)
                make.bottom.leading.trailing.equalToSuperview()
            }
        case .horizontal:
            productStepperButtonContainer.snp.makeConstraints { make in
                make.width.equalTo(frame.size.width)
                make.height.equalTo(frame.size.height)
                make.edges.equalToSuperview()
            }
            
            productStepperButton.snp.makeConstraints { make in
                make.top.bottom.trailing.equalToSuperview()
                make.width.equalTo(frame.size.height)
            }
            
            productQuantityLabel.snp.makeConstraints { make in
                make.trailing.equalTo(productStepperButton.snp.leading)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(frame.size.height)
            }
            
            productStepperDecreaseButton.snp.makeConstraints { make in
                make.height.equalTo(frame.size.height)
                make.trailing.equalTo(productQuantityLabel.snp.leading)
                make.bottom.leading.leading.equalToSuperview()
            }
        }
    }
    //Public functions
    func setAddAction(target: Any, action: Selector) {
        productStepperButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func setDecreaseAction(target: Any, action: Selector) {
        productStepperDecreaseButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func updateQuantityLabel(quantity: Int) {
        productQuantityLabel.text = String(quantity)
    }
    func getQuantityLabel() -> UIView{
        return productQuantityLabel
    }
    func getDecreaseButton() -> UIView {
        return productStepperDecreaseButton
    }
}
