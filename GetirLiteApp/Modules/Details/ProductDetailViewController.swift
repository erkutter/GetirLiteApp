//
//  ProductDetailViewControlelr.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 22.04.2024.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

protocol ProductDetailViewControllerProtocol: AnyObject {
    func showAddtoCartButton()
    func showStepper()
    func configure(product: ProductDisplayable)
    func configureCartButton(cartButton: UIView)
    func setProductImage(_ url: String)
    func setProductPrice(_ priceText: String)
    func setProductName(_ name: String)
    func setProductAttribute(_ attribute: String)
    func setProductQuantity(_ quantity: Int)
}

final class ProductDetailViewController:BaseViewController {
    var cartButton: UIView?
    weak var delegate: ProductDetailViewControllerDelegate?
    var indexPath: IndexPath?
    private var tappedProduct: ProductDisplayable?
    private lazy var horizontalStepper = StepperView(frame: CGRect(x: 0, y: 0, width: 146, height: 48), orientation: .horizontal)
    var presenter: ProductDetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = LabelSetup.productDetailViewHeaderText
        setupNavigationBar()
        configureStepperActions()
        setupView()
    }
    
    private func configureStepperActions() {
        horizontalStepper.setAddAction(target: self, action: #selector(stepperButtonTapped(_:)))
        horizontalStepper.setDecreaseAction(target: self, action: #selector(stepperDecreaseButtonTapped(_:)))
    }
    
    @objc private func addToCartButtonTapped(_ sender: UIButton) {
        presenter.stepperButtonPressed(increment: true)
        delegate?.didUpdateProduct(tappedProduct!, indexPath: self.indexPath!)
    }
    
    @objc private func stepperButtonTapped(_ sender: UIButton) {
        presenter.stepperButtonPressed(increment: true)
        delegate?.didUpdateProduct(tappedProduct!, indexPath: self.indexPath!)
    }
    
    @objc private func stepperDecreaseButtonTapped(_ sender: UIButton) {
        presenter.stepperButtonPressed(increment: false)
        delegate?.didUpdateProduct(tappedProduct!, indexPath: self.indexPath!)
    }
    //MARK - UI RELATED
    lazy var productDetailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.masksToBounds = false
        
        return view
    }()
    lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.masksToBounds = false
        
        return view
    }()
    lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ThemeSetup.defaultTheme.themeColor.main
        button.setTitle("Sepete Ekle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = ThemeSetup.defaultTheme.themeFont.headline
        button.addTarget(self, action: #selector(addToCartButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        
        label.font = ThemeSetup.defaultTheme.themeFont.productDetailPriceSize
        label.textColor = ThemeSetup.defaultTheme.themeColor.main
        label.textAlignment = .left
        return label
    }()
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeSetup.defaultTheme.themeFont.productDetailNameSize
        label.textColor = ThemeSetup.defaultTheme.themeColor.text
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    lazy var productAttributeLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeSetup.defaultTheme.themeFont.subline
        label.textColor = ThemeSetup.defaultTheme.themeColor.subText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}

extension ProductDetailViewController: ProductDetailViewControllerProtocol {
    func configureCartButton(cartButton: UIView) {
        self.cartButton = cartButton
    }
    func showStepper() {
        DispatchQueue.main.async {
            self.addToCartButton.isHidden = true
            self.horizontalStepper.isHidden = false
        }
    }
    func showAddtoCartButton() {
        DispatchQueue.main.async {
            self.addToCartButton.isHidden = false
            self.horizontalStepper.isHidden = true
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
        horizontalStepper.updateQuantityLabel(quantity: quantity)
    }
    func configure(product: ProductDisplayable) {
        self.tappedProduct = product
        presenter.configure(product: product)
    }
}

extension ProductDetailViewController {
    private func setupNavigationBar() {
        guard let cartButton = cartButton else { return }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = ThemeSetup.defaultTheme.themeColor.main
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: ThemeSetup.defaultTheme.themeFont.headline
        ]
        appearance.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupView() {
        view.addSubview(productDetailContainerView)
        view.addSubview(buttonContainerView)
        productDetailContainerView.addSubview(productImageView)
        productDetailContainerView.addSubview(productPriceLabel)
        productDetailContainerView.addSubview(productNameLabel)
        productDetailContainerView.addSubview(productAttributeLabel)
        buttonContainerView.addSubview(horizontalStepper)
        buttonContainerView.addSubview(addToCartButton)
        
        productDetailContainerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(420)
        }
        buttonContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(76)
        }
        addToCartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(50)
            make.width.equalTo(343)
            make.centerX.equalToSuperview()
        }
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(88)
        }
        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.centerX.equalTo(productImageView)
        }
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(productPriceLabel.snp.bottom).offset(4)
            make.width.equalToSuperview()
            make.centerX.equalTo(productImageView)
        }
        productAttributeLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(2)
            make.centerX.equalTo(productImageView)
        }
        horizontalStepper.snp.updateConstraints { make in
            make.top.equalTo(buttonContainerView.snp.top).offset(16)
            make.centerX.equalTo(buttonContainerView.snp.centerX)
        }
    }
}

