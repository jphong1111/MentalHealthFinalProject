//
//  DeleteAccountAlertView.swift
//  MentalHealth
//
//  Created by JungpyoHong on 7/15/24.
//

import Foundation
import UIKit

protocol DeleteAlertViewDelegate: AnyObject {
    func didTapNoButton()
    func didTapYesButton()
}

final class DeleteAccountAlertView: UIView {
    weak var delegate: DeleteAlertViewDelegate?

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var titleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.deleteAccountConfirmation)
        label.textAlignment = .center
        label.font = SoliUFont.bold16
        label.textColor = SoliUColor.accountYesButton
        return label
    }()

    private lazy var messageLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.deleteAccountDescription)
        label.textAlignment = .center
        label.font = SoliUFont.regular12
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var yesButton: SoliUButton = {
        let button = SoliUButton(type: .system)
        button.setTitle(.localized(.yes), for: .normal)
        button.titleLabel?.font = SoliUFont.medium14
        button.backgroundColor = SoliUColor.accountYesButton
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 19
        return button
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
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubView(containerView)

        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 333).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        containerView.addSubView(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubView(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
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
        delegate?.didTapNoButton()
    }
    
    @objc private func yesButtonTapped() {
        delegate?.didTapYesButton()
    }
}

#if DEBUG
extension DeleteAccountAlertView {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: DeleteAccountAlertView

        var containerView: UIView { target.containerView }

        var titleLabel: SoliULabel { target.titleLabel }

        var messageLabel: SoliULabel { target.messageLabel }

        var noButton: SoliUButton { target.noButton }

        var yesButton: SoliUButton { target.yesButton }

        func setupView() { target.setupView() }

        func noButtonTapped() { target.noButtonTapped() }

        func yesButtonTapped() { target.yesButtonTapped() }
    }
}
#endif
