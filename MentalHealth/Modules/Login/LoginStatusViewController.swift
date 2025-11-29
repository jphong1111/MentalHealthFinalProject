//
//  LoginStatusViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/22/24.
//

import Foundation
import UIKit

final class LoginStatusViewController: BaseViewController {
    private lazy var statusTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.whatsYourCurrentStatus)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = SoliUFont.bold32
        return label
    }()

    private lazy var button: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.next), for: .normal)
        button.titleLabel?.font = SoliUFont.black14
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.backgroundColor = SoliUColor.loginNextDisabled
        button.addTarget(self, action: #selector(navigateToEthnicityScreen), for: .touchUpInside)
        return button
    }()
    
    @objc private func navigateToEthnicityScreen() {
        navigate(LoginEthnicityViewController())
    }
    
    let buttonOption: [WorkStatus] = [.student, .employed, .other]
    var selectedButtonIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        button.isEnabled = false
        setCustomBackNavigationButton()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.layer.cornerRadius = button.bounds.height / 2
        if button.isEnabled {
            button.backgroundColor = SoliUColor.newSoliuBlue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        addAutoLayoutSubViews([statusTitleLabel,button])
        
        NSLayoutConstraint.activate([
            statusTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            statusTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            statusTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            button.heightAnchor.constraint(equalToConstant: 45),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        createSelectButton(labels: buttonOption.map { $0.localized.capitalized }, spacing: 10, placement: .below(anchorView: statusTitleLabel)) { selectedButton, buttonEnabled in
            self.selectedButtonIndex = selectedButton
            self.button.isEnabled = buttonEnabled
            LoginManager.shared.setWorkStatus(self.buttonOption[self.selectedButtonIndex])
        }
    }
}

#if DEBUG
extension LoginStatusViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: LoginStatusViewController

        var statusTitleLabel: SoliULabel { target.statusTitleLabel }

        var button: SoliUButton { target.button }

    }
}
#endif
