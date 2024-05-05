//
//  ShoppingCartViewController.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 22.04.2024.
//

import Foundation
import UIKit

protocol ShoppingCartViewControllerProtocol: AnyObject {
    func setupCollectionView()
    func reloadCollectionView()
    func setupView()
    func displayCheckoutAlert(title: String, message: String, buttonText: String, action: @escaping () -> Void)
    func setViewTitle(_ title: String)
    func setCheckoutPrice(_ price: String)
    func reloadCollectionView(_ indexSet: IndexSet)
    func reloadCollectionView(at indexPaths: [IndexPath])
}

final class ShoppingCartViewController: BaseViewController, UICollectionViewDelegate {
    var presenter: ShoppingCartPresenterProtocol!
    var cartButton: UIView?
    var suggestedProducts: [ProductDisplayable]?
    private var collectionView: UICollectionView!
    
    override func viewDidLayoutSubviews() {
        presenter.setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    private lazy var sectionHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = LabelSetup.suggestedProductsHeaderText
        label.font = ThemeSetup.defaultTheme.themeFont.subline
        label.textColor = ThemeSetup.defaultTheme.themeColor.text
        return label
    }()
    
    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private lazy var subButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var checkOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ThemeSetup.defaultTheme.themeColor.main
        button.setTitle(LabelSetup.checkOutButtonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = ThemeSetup.defaultTheme.themeFont.headline
        button.addTarget(self, action: #selector(checkOutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeSetup.defaultTheme.themeFont.productDetailPriceSize
        label.text = ""
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = ThemeSetup.defaultTheme.themeColor.main
        return label
    }()
    @objc private func emptyButtonTapped(_ sender: UIButton) {
        presenter.emptyCart()
    }
    @objc private func checkOutButtonTapped(_ sender: UIButton) {
        presenter.showCheckoutAlert()
    }
}

extension ShoppingCartViewController: ShoppingCartViewControllerProtocol {
    func reloadCollectionView(at indexPaths: [IndexPath]) {
        self.collectionView.reloadItems(at: indexPaths)
    }
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func displayCheckoutAlert(title: String, message: String, buttonText: String, action: @escaping () -> Void) {
        let customAlert = AlertViewController(title: title, message: message, buttonText: buttonText, action: action)
        present(customAlert, animated: true, completion: nil)
    }
    
    func setCheckoutPrice(_ price: String) {
        AnimationUtility.bounceTextChange(label: totalPriceLabel, newText: price)
    }
    
    func setViewTitle(_ title: String) {
        self.title = title
    }
    
    func reloadCollectionView(_ indexSet: IndexSet) {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(indexSet)
        }
    }
}

extension ShoppingCartViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return presenter.cartItemsCount()
        }
        if section == 1 {
            return suggestedProducts?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingCartCollectionViewCell", for: indexPath) as? ShoppingCartCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let cartItem = presenter.cartItem(indexPath.row) {
                let cellPresenter = ShoppingCartCollectionViewCellPresenter(view: cell, delegate: presenter as! ShoppingCartCollectionViewCellPresenterDelegate, cartItem: cartItem)
                cell.shoppingCartCollectionViewCellPresenter = cellPresenter
                cellPresenter.loadProducts()
                cell.setupViews()
            }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
                return UICollectionViewCell()
            }
            let product = suggestedProducts?[indexPath.row]
            if let product = product {
                let delegate = presenter as? ProductCollectionViewCellPresenterDelegate
                if let delegate = delegate {
                    let cellPresenter = ProductCollectionViewCellPresenter(view: cell, delegate: delegate, product: product)
                    cell.productCollectionViewCellPresenter = cellPresenter
                    cellPresenter.loadProducts()
                    cell.indexPath = indexPath
                    cell.sectionIndex = indexPath.section
                } else {
                    print("Error: Presenter does not conform to ProductCollectionViewCellPresenterDelegate.")
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == ShoppingCartViewController.sectionHeaderElementKind {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath)
            setupHeaderLabel(in: header)
            return header
        }
        fatalError("Unexpected element kind")
    }
    
    private func setupHeaderLabel(in header: UICollectionReusableView) {
        header.subviews.forEach { $0.removeFromSuperview() }
        header.addSubview(sectionHeaderLabel)
        sectionHeaderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}

extension ShoppingCartViewController: UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShoppingCartCollectionViewCell.self, forCellWithReuseIdentifier: "ShoppingCartCollectionViewCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: ShoppingCartViewController.sectionHeaderElementKind, withReuseIdentifier: "headerView")
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.register(ProductListingCellDecorationView.self, forSupplementaryViewOfKind: "section-background", withReuseIdentifier: "background")
        collectionView.backgroundColor = ThemeSetup.defaultTheme.themeColor.background
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            switch sectionIndex {
            case 0:
                return self.checkOutItemLayout()
            case 1:
                return self.suggestedProductsLayoutWithHeader()
            default:
                return nil
            }
        }
        layout.register(ProductListingCellDecorationView.self, forDecorationViewOfKind:"section-background")
        return layout
    }
    
    private func checkOutItemLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .absolute(74))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(375), heightDimension: .absolute(99))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0)
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "section-background")
        backgroundDecoration.contentInsets = section.contentInsets
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
    private func suggestedProductsLayoutWithHeader() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .absolute(170))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(800), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(20)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        // Adding header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(12))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ShoppingCartViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "section-background")
        backgroundDecoration.contentInsets = section.contentInsets
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
}
//UI related
extension ShoppingCartViewController {
    func setupView() {
        //empty button
        let emptyCartButton = UIBarButtonItem(image: UIImage(named: "deleteButton"), style: .plain, target: self, action: #selector(emptyButtonTapped))
        emptyCartButton.tintColor = .white
        navigationItem.rightBarButtonItem = emptyCartButton
        view.addSubview(buttonContainerView)
        buttonContainerView.addSubview(subButtonContainerView)
        subButtonContainerView.addSubview(checkOutButton)
        subButtonContainerView.addSubview(totalPriceLabel)
        
        buttonContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(76)
        }
        subButtonContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(50)
            make.width.equalTo(343)
            make.centerX.equalToSuperview()
        }
        checkOutButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(235)
        }
        totalPriceLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(checkOutButton.snp.trailing)
        }
    }
}

extension ShoppingCartViewController {
    static let sectionHeaderElementKind = "section-header-element-kind"
}
