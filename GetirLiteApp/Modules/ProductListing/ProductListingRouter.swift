//
//  ProductListingRouter.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import Foundation

enum ProductListingRoutes {
    case cart
}

protocol ProductListingRouterProtocol: AnyObject {
    func navigate(_ route: ProductListingRoutes, product: [ProductDisplayable])
    func navigateToProductDetail(_ product: ProductDisplayable, indexPath: IndexPath)
}

final class ProductListingRouter {
    weak var viewController: ProductListingViewController?
    var presenter: ProductListingPresenterProtocol?
    
    static func createModule() -> ProductListingViewController {
        let view = ProductListingViewController()
        let router = ProductListingRouter()
        let service = NetworkService()
        let productRepository = ProductRepository(networkService: service)
        let cartRepository = CartRepository()
        let interactor = ProductListingInteractor(productRepository: productRepository, cartRepository: cartRepository)
        
        let presenter = ProductListingPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        router.presenter = presenter
        return view
    }
}

extension ProductListingRouter: ProductListingRouterProtocol {
    func navigateToProductDetail(_ product: ProductDisplayable, indexPath: IndexPath) {
        let productDetailVC = ProductDetailRouter.createModule()
        
        if let cartButtonView = viewController?.navigationItem.rightBarButtonItem?.customView {
            productDetailVC.configureCartButton(cartButton: cartButtonView)
            productDetailVC.configure(product: product)
            productDetailVC.indexPath = indexPath
            productDetailVC.delegate = self.presenter as? ProductDetailViewControllerDelegate
        }
        viewController?.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    func navigate(_ route: ProductListingRoutes, product: [ProductDisplayable]) {
        switch route {
        case .cart:
            let shoppingCartVC = ShoppingCartRouter.createModule(delegate: self.presenter as? ShoppingCartPresenterDelegate)
            
            if let _ = viewController?.navigationItem.rightBarButtonItem?.customView {
                shoppingCartVC.suggestedProducts = product
            }
            viewController?.navigationController?.pushViewController(shoppingCartVC, animated: true)
        }
    }
}
