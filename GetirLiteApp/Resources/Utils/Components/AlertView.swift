//
//  AlertView.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 24.04.2024.
//

import Foundation
import UIKit
import SnapKit

class AlertViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    
    var titleText: String?
    var messageText: String?
    var buttonText: String?
    var buttonAction: (() -> Void)?
    
    init(title: String, message: String, buttonText: String, action: @escaping () -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.actionButton.setTitle(buttonText, for: .normal)
        self.buttonAction = action
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        titleLabel.font = ThemeSetup.defaultTheme.themeFont.headline
        titleLabel.textColor = ThemeSetup.defaultTheme.themeColor.main
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        messageLabel.font = ThemeSetup.defaultTheme.themeFont.headline
        messageLabel.textColor = ThemeSetup.defaultTheme.themeColor.main
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        containerView.addSubview(messageLabel)
        
        actionButton.layer.cornerRadius = 10
        actionButton.titleLabel?.font = ThemeSetup.defaultTheme.themeFont.headline
        actionButton.backgroundColor = ThemeSetup.defaultTheme.themeColor.main
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        containerView.addSubview(actionButton)
        
        setupConstraints(containerView)
    }
    
    private func setupConstraints(_ containerView: UIView) {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(130)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(10)
            make.left.right.equalTo(containerView).inset(10)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(containerView).inset(10)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.left.right.equalTo(containerView).inset(10)
            make.bottom.equalTo(containerView.snp.bottom).inset(10)
            make.height.equalTo(44)
        }
    }
    
    @objc private func didTapActionButton() {
        dismiss(animated: true, completion: buttonAction)
    }
}
