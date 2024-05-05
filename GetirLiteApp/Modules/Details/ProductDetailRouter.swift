//
//  ProductDetailRouter.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 22.04.2024.
//

import Foundation

protocol ProductDetailRouterProtocol {}

final class ProductDetailRouter {
    weak var viewController: ProductDetailViewController?
    
    static func createModule() -> ProductDetailViewController {
        let view = ProductDetailViewController()
        let router = ProductDetailRouter()
        let cartRepository = CartRepository()
        let interactor = ProductDetailInteractor(cartRepository: cartRepository)
        let presenter = ProductDetailPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension ProductDetailRouter: ProductDetailRouterProtocol {}
