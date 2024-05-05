//
//  BaseViewController.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 14.04.2024.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarApperance()
        setupCartButton()
    }
    
    private func setupCartButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "closeButton"), style: .plain, target: self, action: #selector(popViewController))
        closeButton.tintColor = .white
        navigationItem.leftBarButtonItem = closeButton
        
    }
    @objc private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setNavigationBarApperance() {
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
}
