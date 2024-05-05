//
//  ProductListingViewController.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 13.04.2024.
//

import UIKit
import SnapKit

protocol ProductListingViewControllerProtocol: AnyObject {
    func setupNavigationBar()
    func setupCollectionView()
    func reloadCollectionView()
    func setViewTitle(_ title: String)
    func createLayout() -> UICollectionViewLayout
    func updateCartLabel(_ updatedPriceText: String)
    func reloadCollectionView(at indexPaths: [IndexPath])
}

final class ProductListingViewController: BaseViewController, UICollectionViewDelegate {
    var presenter: ProductListingPresenterProtocol!
    private var collectionView: UICollectionView!
    private var cartButton: CartButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

extension ProductListingViewController: ProductListingViewControllerProtocol {
    func reloadCollectionView(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: indexPaths)
        }
    }
    
    func updateCartLabel(_ updatedPriceText: String) {
        self.cartButton.updateCartPriceLabel(updatedPriceText)
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setViewTitle(_ title: String){
        self.title = title
    }
}

extension ProductListingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return presenter.suggestedProductsCount()
        } else {
            return presenter.productsCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.sectionIndex = indexPath.section
        let product: ProductDisplayable? = indexPath.section == 0 ? presenter.suggestedProduct(indexPath.row) : presenter.product(indexPath.row)
        if let product = product {
            let cellPresenter = ProductCollectionViewCellPresenter(view: cell, delegate: presenter as! ProductCollectionViewCellPresenterDelegate, product: product)
            cell.productCollectionViewCellPresenter = cellPresenter
            cellPresenter.loadProducts()
            cell.indexPath = indexPath
        }
        return cell
    }
}

extension ProductListingViewController: UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.register(ProductListingCellDecorationView.self, forSupplementaryViewOfKind: "section-background", withReuseIdentifier: "background")
        collectionView.backgroundColor = ThemeSetup.defaultTheme.themeColor.background
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        cartButton = CartButtonView()
        if let cartPresenterDelegate = presenter as? CartPresenterDelegate {
            let cartButtonPresenter = CartPresenter(delegate: cartPresenterDelegate, view: cartButton)
            cartButton.presenter = cartButtonPresenter
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            switch sectionIndex {
            case 0:
                return self.verticalScrollSectionSetup()
            default:
                return self.horizontalScrollSectionSetup()
            }
        }
        layout.register(ProductListingCellDecorationView.self, forDecorationViewOfKind:"section-background")
        
        return layout
    }
    
    private func verticalScrollSectionSetup() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .absolute(170))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(1220), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "section-background")
        backgroundDecoration.contentInsets = section.contentInsets
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
    
    private func horizontalScrollSectionSetup() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(103), heightDimension: .absolute(180))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(361), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(16)
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "section-background")
        backgroundDecoration.contentInsets = section.contentInsets
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
}
