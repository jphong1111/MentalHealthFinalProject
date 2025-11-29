//
//  LogoutAlertView.swift
//  MentalHealth
//
//  Created by JungpyoHong on 7/17/24.
//

import Foundation
import UIKit

protocol LogoutAlertViewDelegate: AnyObject {
    func didTapLogoutNoButton()
    func didTapLogoutYesButton()
}

final class LogoutAlertView: UIView {
    weak var delegate: LogoutAlertViewDelegate?

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var logoutTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.logoutConfirmation)
        label.font = SoliUFont.bold16
        label.textAlignment = .center
        label.textColor = SoliUColor.newSoliuBlue
        return label
    }()
    
    private lazy var createAccountTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.goToLoginPage)
        label.font = SoliUFont.bold16
        label.textAlignment = .center
        label.textColor = SoliUColor.newSoliuBlue
        return label
    }()

    private lazy var noButton: SoliUButton = {
        let button = SoliUButton(type: .system)
        button.setTitle(.localized(.no), for: .normal)
        button.titleLabel?.font = SoliUFont.medium14
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = SoliUColor.noStrokeColor.cgColor
        button.layer.cornerRadius = 19
        return button
    }()
    
    private lazy var yesButton: SoliUButton = {
        let button = SoliUButton(type: .system)
        button.setTitle(.localized(.yes), for: .normal)
        button.titleLabel?.font = SoliUFont.medium14
        button.backgroundColor = SoliUColor.newSoliuBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 19
        return button
    }()
    
    init(alertType: AccountAlertType) {
        super.init(frame: .zero)
        backgroundColor = UIColor.clear

        setupView(alertType: alertType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(alertType: AccountAlertType) {
        // Adding container view
        addSubView(containerView)
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 333).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        // Adding title label
        if alertType == .logout {
            containerView.addSubview(logoutTitleLabel)
            logoutTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
            logoutTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
            logoutTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        } else if alertType == .createAccount {
            containerView.addSubview(createAccountTitleLabel)
            createAccountTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
            createAccountTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
            createAccountTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        }
        
        // Adding buttons
        containerView.addSubView([noButton, yesButton])
        
        yesButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        yesButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        yesButton.widthAnchor.constraint(equalToConstant: 132).isActive = true
        yesButton.heightAnchor.constraint(equalToConstant: 38).isActive = true

        noButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        noButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        noButton.widthAnchor.constraint(equalToConstant: 132).isActive = true
        noButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        // Button actions
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
    }
    
    @objc private func noButtonTapped() {
        delegate?.didTapLogoutNoButton()
    }
    
    @objc private func yesButtonTapped() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "savedEmail")
        KeychainHelper.shared.deletePassword(for: LoginManager.shared.getUserInfo().email)
        delegate?.didTapLogoutYesButton()
    }
}

#if DEBUG
extension LogoutAlertView {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: LogoutAlertView

        var containerView: UIView { target.containerView }

        var logoutTitleLabel: SoliULabel { target.logoutTitleLabel }

        var createAccountTitleLabel: SoliULabel { target.createAccountTitleLabel }

        var noButton: SoliUButton { target.noButton }

        var yesButton: SoliUButton { target.yesButton }

        func setupView(alertType: AccountAlertType) {
            target.setupView(alertType: alertType)
        }

        func noButtonTapped() { target.noButtonTapped() }

        func yesButtonTapped() { target.yesButtonTapped() }

    }
}
#endif
