//
//  ProductDetailPresenterTests.swift
//  GetirLiteAppTests
//
//  Created by Erkut Ter on 5.05.2024.
//

import XCTest
@testable import GetirLiteApp

final class ProductDetailPresenterTests: XCTestCase {
    var presenter: ProductDetailPresenter!
    var mockView: MockProductDetailViewController!
    var mockInteractor: MockProductDetailInteractor!
    var mockRouter: MockProductDetailRouter!
    var testProduct: ProductDisplayable!
    
    override func setUp() {
        super.setUp()
        mockView = MockProductDetailViewController()
        mockInteractor = MockProductDetailInteractor()
        mockRouter = MockProductDetailRouter()
        presenter = ProductDetailPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        testProduct = ProductDisplayable(product: Product(id: "123", name: "Test Product", attribute: "attribute", thumbnailURL: "http://example.com/image.png", imageURL: "http://example.com/image.png", price: 10.0, priceText: "10", shortDescription: "shortDescription"), quantity: 5)
    }
    
    override func tearDown() {
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        presenter = nil
        super.tearDown()
    }
    
    func testConfigureProduct() {
        presenter.configure(product: testProduct)
        
        XCTAssertEqual(mockView.productName, "Test Product")
        XCTAssertEqual(mockView.productPrice, "10")
        XCTAssertEqual(mockView.productImageURL, "http://example.com/image.png")
        XCTAssertEqual(mockView.productAttribute, "attribute")
        XCTAssertEqual(mockView.productQuantity, 5)
        XCTAssertFalse(mockView.isAddToCartButtonShown)
        XCTAssertTrue(mockView.isStepperShown)
    }
    
    func testStepperButtonPressedIncrement() {
        presenter.configure(product: testProduct)
        presenter.stepperButtonPressed(increment: true)
        XCTAssertFalse(mockView.isAddToCartButtonShown)
        XCTAssertTrue(mockView.isStepperShown)
    }
    
    func testStepperButtonPressedDecrement() {
        presenter.configure(product: testProduct)
        presenter.stepperButtonPressed(increment: false)
        XCTAssertFalse(mockView.isAddToCartButtonShown)
        XCTAssertTrue(mockView.isStepperShown)
    }
    
    func testFetchProductQuantityOutput() {
        presenter.configure(product: testProduct)
        mockInteractor.output?.fetchProductQuantityOutput(quantity: testProduct.quantity)
        XCTAssertTrue((mockView.productQuantity == testProduct.quantity) )
    }
}
