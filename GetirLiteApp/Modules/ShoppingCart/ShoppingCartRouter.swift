//
//  ShoppingCartRouter.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 22.04.2024.
//

import Foundation

protocol ShoppingCartRouterProtocol: AnyObject {
    func navigateToProductListing()
}

final class ShoppingCartRouter {
    weak var viewController: ShoppingCartViewController?
    
    static func createModule(delegate: ShoppingCartPresenterDelegate?) -> ShoppingCartViewController {
        let view = ShoppingCartViewController()
        let router = ShoppingCartRouter()
        let cartRepository = CartRepository()
        let networkService = NetworkService()
        let productRepository = ProductRepository(networkService: networkService)
        
        let interactor = ShoppingCartInteractor(productRepository: productRepository, cartRepository: cartRepository)
        let presenter = ShoppingCartPresenter(view: view, interactor: interactor, router: router)
        
        presenter.delegate = delegate
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}
extension ShoppingCartRouter: ShoppingCartRouterProtocol {
    func navigateToProductListing() {
        if let rootViewController = viewController?.navigationController?.viewControllers.first as? ProductListingViewController {
            viewController?.navigationController?.popToViewController(rootViewController, animated: true)
        }
    }
}
