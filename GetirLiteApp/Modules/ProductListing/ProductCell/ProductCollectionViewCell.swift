//
//  ProductCollectionViewCell.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 15.04.2024.
//
import UIKit
import SnapKit
import Kingfisher
import SkeletonView

protocol ProductCollectionViewCellProtocol: AnyObject {
    func showSkeletons()
    func hideSkeletons()
    func setBorderColor(isAdded: Bool)
    func setQuantityLabelVisibility(hidden: Bool)
    func setDecreaseButtonVisibility(hidden: Bool)
    func setProductImage(_ url: String)
    func setProductPrice(_ priceText: String)
    func setProductName(_ name: String)
    func setProductAttribute(_ attribute: String)
    func setProductQuantity(_ quantity: Int)
}

final class ProductCollectionViewCell: UICollectionViewCell {
    private var priceText: String?
    private var productName: String?
    private var productAttribute: String?
    private var productImage: String?
    private var productQuantity: Int?
    var indexPath: IndexPath?
    private lazy var verticalStepper = StepperView(frame: CGRect(x: 0, y: 0, width: 32, height: 96), orientation: .vertical)
    
    var productCollectionViewCellPresenter: ProductCollectionViewCellPresenterProtocol! {
        didSet {
            configureViewsSkeletonable()
            productCollectionViewCellPresenter.loadProducts()
        }
    }
    var sectionIndex: Int = 0 {
        didSet {
            adjustStepperPosition()
        }
    }
    
    func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(productDetailClick))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func productDetailClick() {
        guard let presenter = productCollectionViewCellPresenter, let indexPath = self.indexPath else {
            fatalError("Presenter or IndexPath was not set on ProductCollectionViewCell")
        }
        presenter.productDetailTapped(index: indexPath)
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
        label.text = priceText
        label.font = ThemeSetup.defaultTheme.themeFont.headline
        label.textColor = ThemeSetup.defaultTheme.themeColor.main
        label.textAlignment = .left
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = productName
        label.font = ThemeSetup.defaultTheme.themeFont.subline
        label.textColor = ThemeSetup.defaultTheme.themeColor.text
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var productAttributeLabel: UILabel = {
        let label = UILabel()
        label.text = productAttribute
        label.font = ThemeSetup.defaultTheme.themeFont.subline
        label.textColor = ThemeSetup.defaultTheme.themeColor.subText
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addTapGestureRecognizer()
        configureStepperActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    private func adjustStepperPosition() {
        let stepperPosition = sectionIndex == 0 ? 68 : 80
        verticalStepper.snp.updateConstraints { make in
            make.left.equalToSuperview().inset(stepperPosition)
        }
    }
    
    private func configureStepperActions() {
        verticalStepper.setAddAction(target: self, action: #selector(stepperButtonTapped(_:)))
        verticalStepper.setDecreaseAction(target: self, action: #selector(stepperDecreaseButtonTapped(_:)))
    }
    
    private func configureViewsSkeletonable() {
        productImageViewContainer.isSkeletonable = true
        verticalStepper.isSkeletonable = true
        contentView.isSkeletonable = true
    }
    
    @objc private func stepperButtonTapped(_ sender: UIButton) {
        guard let presenter = productCollectionViewCellPresenter else {
            fatalError("Presenter was not set on ProductCollectionViewCell")
        }
        guard let indexPath = indexPath else {return}
        presenter.stepperButtonPressed(increment: true, indexPath: indexPath)
    }
    
    @objc private func stepperDecreaseButtonTapped(_ sender: UIButton) {
        guard let presenter = productCollectionViewCellPresenter else {
            fatalError("Presenter was not set on ProductCollectionViewCell")
        }
        guard let indexPath = indexPath else { return }
        presenter.stepperButtonPressed(increment: false, indexPath: indexPath)
    }
    
    private func setupViews() {
        contentView.addSubview(productImageViewContainer)
        contentView.addSubview(verticalStepper)
        productImageViewContainer.addSubview(productImageView)
        
        contentView.addSubview(productPriceLabel)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productAttributeLabel)
        
        productImageViewContainer.snp.makeConstraints { make in
            make.width.height.equalTo(sectionIndex == 0 ? 92 : 103)
            make.top.leading.trailing.equalToSuperview()
        }
        productImageView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview().inset(12)
        }
        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageViewContainer.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(productPriceLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        productAttributeLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(16)
        }
    }
}

extension ProductCollectionViewCell: ProductCollectionViewCellProtocol {
    func showSkeletons() {
        contentView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletons() {
        contentView.hideSkeleton()
    }
    
    func setBorderColor(isAdded: Bool) {
        if !isAdded {
            productImageViewContainer.layer.borderColor = ThemeSetup.defaultTheme.themeColor.main.cgColor
        } else {
            productImageViewContainer.layer.borderColor = ThemeSetup.defaultTheme.themeColor.border
        }
    }
    
    func setQuantityLabelVisibility(hidden: Bool) {
        if hidden {
            AnimationUtility.fadeOutView(verticalStepper.getQuantityLabel())
        } else {
            AnimationUtility.fadeInView(verticalStepper.getQuantityLabel())
        }
    }
    
    func setDecreaseButtonVisibility(hidden: Bool) {
        if hidden {
            AnimationUtility.fadeOutView(verticalStepper.getDecreaseButton())
        } else {
            AnimationUtility.fadeInView(verticalStepper.getDecreaseButton())
        }
    }
    
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
        verticalStepper.updateQuantityLabel(quantity: quantity)
    }
}
