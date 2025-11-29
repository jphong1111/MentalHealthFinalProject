//
//  LoginEthnicityViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/22/24.
//

import Foundation
import UIKit

final class LoginEthnicityViewController: BaseViewController {
    private lazy var ethnicityTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.whatsYourEthnicity)
        label.font = SoliUFont.bold32
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var button: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.next), for: .normal)
        button.titleLabel?.font = SoliUFont.black14
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.backgroundColor = SoliUColor.loginNextDisabled
        button.addTarget(self, action: #selector(navigateToNickNameScreen), for: .touchUpInside)
        return button
    }()
    
    @objc private func navigateToNickNameScreen() {
        navigate(LoginNickNameViewController())
    }
    
    let buttonOption: [Ethnicity] = [
        .americanIndian,
        .alaskaNative,
        .asian,
        .black,
        .africanAmerican,
        .nativeHawaiian,
        .otherPacificIslander,
        .white,
        .other
    ]
    var selectedButtonIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isEnabled = false
        setCustomBackNavigationButton()
        view.backgroundColor = .white
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
        addAutoLayoutSubViews([ethnicityTitleLabel,button])
        
        NSLayoutConstraint.activate([
            ethnicityTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            ethnicityTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ethnicityTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            ethnicityTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            button.heightAnchor.constraint(equalToConstant: 45),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        createSelectButton(labels: buttonOption.map { $0.localized.capitalizedEachWord() }, spacing: 10, placement: .below(anchorView: ethnicityTitleLabel)) { selectedButton, buttonEnabled in
            self.selectedButtonIndex = selectedButton
            self.button.isEnabled = buttonEnabled
            LoginManager.shared.setEthnicity(self.buttonOption[self.selectedButtonIndex])
        }
    }
}

#if DEBUG
extension LoginEthnicityViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: LoginEthnicityViewController

        var ethnicityTitleLabel: SoliULabel { target.ethnicityTitleLabel }

        var button: SoliUButton { target.button }

    }
}
#endif
