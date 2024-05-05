//
//  ShoppingCartPresenter.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 22.04.2024.
//

import Foundation

protocol ShoppingCartPresenterProtocol: AnyObject {
    func viewDidLoad()
    func setupViews()
    func fetchCartItems()
    func emptyCart()
    func setCheckoutPrice()
    func showCheckoutAlert()
    func fetchSuggestedProducts()
    func viewWillAppear()
    func cartItemsCount() -> Int
    func cartItem(_ index: Int) -> CartItem?
    func suggestedProduct(_ index: Int) -> ProductDisplayable?
    func getSuggestedProducts() -> [ProductDisplayable]
}

protocol ShoppingCartPresenterDelegate: AnyObject {
    func didProductQuantityChanged()
    func triggerViewWillAppearManually(_ :Bool)
}

final class ShoppingCartPresenter {
    unowned let view: ShoppingCartViewControllerProtocol!
    private let interactor: ShoppingCartInteractorProtocol!
    private let router: ShoppingCartRouterProtocol!
    private var cartItems: [CartItem] = []
    private var suggestedProducts: [ProductDisplayable] = []
    weak var delegate: ShoppingCartPresenterDelegate?
    var updatedCart: Cart?
    var cartTotal: Double?
    
    init(view: ShoppingCartViewControllerProtocol,
         interactor: ShoppingCartInteractorProtocol,
         router: ShoppingCartRouterProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ShoppingCartPresenter: ShoppingCartPresenterProtocol {
    func viewWillAppear() {}
    
    func getSuggestedProducts() -> [ProductDisplayable] {
        return suggestedProducts
    }
    
    func suggestedProduct(_ index: Int) -> ProductDisplayable? {
        guard index < suggestedProducts.count else { return nil }
        return suggestedProducts[index]
    }
    
    func fetchSuggestedProducts() {
        interactor.fetchSuggestedProducts()
    }
    
    func showCheckoutAlert() {
        view.displayCheckoutAlert(
            title: LabelSetup.checkOutAlertText ,
            message: "Sipariş Tutarınız: \(cartTotal?.asTurkishLiraCurrency() ?? "")",
            buttonText: LabelSetup.checkOutButtonText,
            action: {
                self.interactor.emptyCart {}
                self.delegate?.triggerViewWillAppearManually(true)
                self.router.navigateToProductListing()
            }
        )
    }
    
    func setCheckoutPrice() {
        var totalCart = 0.00
        for cartItem in self.cartItems {
            totalCart += cartItem.price * Double(cartItem.quantity)
        }
        self.cartTotal = totalCart
        let formattedTotal = totalCart.asTurkishLiraCurrency()
        view.setCheckoutPrice(formattedTotal)
    }
    
    func emptyCart() {
        interactor.deleteItemsInCart()
        self.delegate?.triggerViewWillAppearManually(true)
        self.router.navigateToProductListing()
    }
    
    func setupViews() {
        view.setupView()
    }
    
    func cartItemsCount() -> Int {
        cartItems.count
    }
    
    func cartItem(_ index: Int) -> CartItem? {
        guard index < cartItems.count else { return nil }
        return cartItems[index]
    }
    
    func fetchCartItems() {
        interactor.fetchCartItems()
    }
    
    func viewDidLoad() {
        fetchCartItems()
        fetchSuggestedProducts()
        view.setViewTitle(LabelSetup.shoppingCartViewHeaderText)
        view.setupCollectionView()
        setCheckoutPrice()
    }
}

extension ShoppingCartPresenter: ShoppingCartInteractorOutputProtocol {
    func updatedCartOutput(cart: Cart) {
        self.updatedCart = cart
    }
    
    func fetchQuantityOutput(quantity: [String : Int]) {
        for product in suggestedProducts {
            if let quantity = quantity[product.id ?? ""] {
                product.quantity = quantity
                view.reloadCollectionView()
            }
        }
    }
    
    func fetchSuggestedProductsOutput(suggestedProducts: [SuggestedProductList]) {
        self.suggestedProducts = suggestedProducts.flatMap { $0.products?.map { ProductDisplayable(product: $0) } ?? [] }
    }
    
    func fetchCartItemsOutput(cartItems: Cart) {
        self.cartItems = []
        for cartItem in cartItems.items {
            self.cartItems.append(cartItem)
            view.reloadCollectionView()
        }
    }
}

extension ShoppingCartPresenter: ShoppingCartCollectionViewCellPresenterDelegate {
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
    
    func updateCartItem(cartItem: CartItem, increment: Bool) {
        interactor.updateItemQuantity(cartItem: cartItem, increment: increment)
        if cartItem.isInvalidated {
            cartItems.removeAll { $0.isInvalidated }
            if cartItems.isEmpty {
                router.navigateToProductListing()
            } else {
                setCheckoutPrice()
            }
        } else {
            setCheckoutPrice()
        }
        self.view.reloadCollectionView()
        self.delegate?.didProductQuantityChanged()
        self.delegate?.triggerViewWillAppearManually(true)
    }
}

extension ShoppingCartPresenter: ProductCollectionViewCellPresenterDelegate {
    func productTapped(product: ProductDisplayable, at: IndexPath) {}
    
    func didupdateProductView(at: IndexPath) {
        view.reloadCollectionView(at: [at])
        fetchCartItems()
        setCheckoutPrice()
        view.reloadCollectionView(IndexSet(integer: 0))
    }
}
