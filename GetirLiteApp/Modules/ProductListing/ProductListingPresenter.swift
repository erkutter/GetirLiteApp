//
//  ProductListingPresenter.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import Foundation

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func suggestedProductsCount() -> Int
    func productsCount() -> Int
    func product(_ index: Int) -> ProductDisplayable?
    func suggestedProduct(_ index: Int) -> ProductDisplayable?
}

protocol ProductDetailViewControllerDelegate: AnyObject {
    func didUpdateProduct(_ product: ProductDisplayable, indexPath: IndexPath)
    func didupdateProductView(at: IndexPath)
}

final class ProductListingPresenter {
    unowned let view: ProductListingViewControllerProtocol!
    private let interactor: ProductListingInteractorProtocol!
    private let router: ProductListingRouterProtocol!
    private var products: [ProductDisplayable] = []
    private var suggestedProducts: [ProductDisplayable] = []
    private var shouldTriggerViewWillAppearActions = false
    weak var delegate: CartPresenterDelegate?
    var updatedCart: Cart?
    
    init(view: ProductListingViewControllerProtocol,
         interactor: ProductListingInteractorProtocol,
         router: ProductListingRouterProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ProductListingPresenter: ProductListingPresenterProtocol {
    func viewDidLoad() {
        view.setViewTitle(LabelSetup.productListingHeaderText)
        fetchProducts()
        fetchSuggestedProducts()
        view.setupNavigationBar()
        view.setupCollectionView()
        fetchCart()
    }
    
    func viewWillAppear() {
        if shouldTriggerViewWillAppearActions {
            fetchCart()
            fetchProductQuantities()
            shouldTriggerViewWillAppearActions = false
        }
    }
    
    private func fetchCart() {
        interactor.fetchCart()
    }
    
    func suggestedProductsCount() -> Int {
        suggestedProducts.count
    }
    
    func productsCount() -> Int {
        products.count
    }
    
    func product(_ index: Int) -> ProductDisplayable? {
        guard index < products.count else { return nil }
        return products[index]
    }
    
    func suggestedProduct(_ index: Int) -> ProductDisplayable? {
        guard index < suggestedProducts.count else { return nil }
        return suggestedProducts[index]
    }
    
    private func fetchProducts() {
        interactor.fetchProducts()
    }
    
    private func fetchSuggestedProducts() {
        interactor.fetchSuggestedProducts()
    }
    
    private func fetchProductQuantities() {
        interactor.fetchSuggestedProductsQuantities(suggestedProducts: suggestedProducts)
        interactor.fetchQuantities(products: products)
        self.view.reloadCollectionView()
    }
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    func fetchQuantityOutput(quantity: [String : Int]) {
        for product in products {
            if let quantity = quantity[product.id ?? ""] {
                product.quantity = quantity
            }
        }
    }
    
    func fetchCartOutput(cart: Cart) {
        self.updatedCart = cart
        let totalCart = cart.totalPrice
        let formattedTotal = totalCart.asTurkishLiraCurrency()
        view.updateCartLabel(formattedTotal)
    }
    
    func fetchQuantitiesOutput(quantities: [String : Int]) {
        for product in products {
            if let quantity = quantities[product.id ?? ""] {
                product.quantity = quantity
                DispatchQueue.main.async {
                    self.view.reloadCollectionView()
                }
                
            }
        }
    }
    
    func fetchSuggestedProductsQuantitiesOutput(quantities: [String : Int]) {
        for suggestedProduct in self.suggestedProducts {
            if let quantity = quantities[suggestedProduct.id ?? ""] {
                suggestedProduct.quantity = quantity
            }
        }
    }
    
    func fetchProductsOutput(products: [ProductList]) {
        self.products = products.flatMap { $0.products?.map { ProductDisplayable(product: $0) } ?? [] }
        self.interactor.fetchQuantities(products: self.products)
        self.view.reloadCollectionView()
    }
    
    func fetchSuggestedProductsOutput(suggestedProducts: [SuggestedProductList]) {
        self.suggestedProducts = suggestedProducts.flatMap { $0.products?.map { ProductDisplayable(product: $0) } ?? [] }
        self.interactor.fetchSuggestedProductsQuantities(suggestedProducts: self.suggestedProducts)
        self.view.reloadCollectionView()
    }
    
    func updatedCartOutput(cart: Cart) {
        self.updatedCart = cart
        let totalCart = cart.totalPrice
        let formattedTotal = totalCart.asTurkishLiraCurrency()
        view.updateCartLabel(formattedTotal)
    }
}

extension ProductListingPresenter: ProductCollectionViewCellPresenterDelegate {
    func updateCart(product: ProductDisplayable, increment: Bool) {
        guard let productId = product.id else { return }
        guard let productName = product.name else { return  }
        let productAttribute = (product.attribute ?? product.shortDescription ?? "")
        guard let productThumbnailURL = product.thumbnailURL else { return }
        guard let productPrice = product.price else { return }
        guard let productPriceText = product.priceText else { return }
        let productQuantity = product.quantity + (increment ? 1 : -1)
        product.quantity = productQuantity
        
        interactor.updateCart(productId: productId, productName: productName, productAttribute: productAttribute, productThumbnailURL: productThumbnailURL, productPrice: productPrice, productPriceText: productPriceText, productQuantity: productQuantity, increment: increment) {
            self.interactor.fetchQuantity(product: product)
        }
    }
    
    func productTapped(product: ProductDisplayable, at: IndexPath) {
        router.navigateToProductDetail(product, indexPath: at)
    }
}

extension ProductListingPresenter: CartPresenterDelegate {
    func cartDidUpdate(cart: Cart) {}
    
    func cartButtonClicked() {
        if (updatedCart?.totalPrice != 0.00) {
            router.navigate(.cart, product: suggestedProducts)
        }
    }
}

extension ProductListingPresenter: ProductDetailViewControllerDelegate {
    func didupdateProductView(at: IndexPath) {
        view.reloadCollectionView(at: [at])
    }
    
    func didUpdateProduct(_ product: ProductDisplayable, indexPath: IndexPath) {
        if indexPath.section == 0 {
            suggestedProducts[indexPath.row] = product
        } else {
            products[indexPath.row] = product
        }
        self.view.reloadCollectionView(at: [indexPath])
        fetchCart()
    }
}

extension ProductListingPresenter: ShoppingCartPresenterDelegate {
    func didProductQuantityChanged() {
        self.interactor.fetchQuantities(products: self.suggestedProducts)
    }
    
    func triggerViewWillAppearManually(_: Bool) {
        shouldTriggerViewWillAppearActions = true
    }
}
