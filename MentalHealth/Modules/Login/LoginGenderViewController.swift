//
//  LoginGenderViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/22/24.
//

import UIKit

final class LoginGenderViewController: BaseViewController {
    private lazy var genderTitleLabel: SoliULabel = {
        let genderTitleLabel = SoliULabel()
        genderTitleLabel.text = .localized(.genderTitle)
        genderTitleLabel.font = SoliUFont.bold32
        return genderTitleLabel
    }()

    private lazy var nextButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.next), for: .normal)
        button.titleLabel?.font = SoliUFont.black14
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.backgroundColor = SoliUColor.loginNextDisabled
        button.addTarget(self, action: #selector(navigateToAgeScreen), for: .touchUpInside)
        return button
    }()
    
    @objc func navigateToAgeScreen() {
        navigate(LoginAgeViewController())
    }
    
    let buttonOption: [Gender] = [.male, .female, .other]
    var selectedButtonIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        setCustomBackNavigationButton()
        self.view.backgroundColor = .white
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.bounds.height / 2
        if nextButton.isEnabled {
            nextButton.backgroundColor = SoliUColor.newSoliuBlue
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        view.addSubView([genderTitleLabel, nextButton])

        NSLayoutConstraint.activate([
            genderTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            genderTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nextButton.heightAnchor.constraint(equalToConstant: 45),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        createSelectButton(labels: buttonOption.map { $0.localized.capitalizedEachWord() }, spacing: 10, placement: .below(anchorView: genderTitleLabel)) { selectedButton, buttonEnabled in
            self.selectedButtonIndex = selectedButton
            self.nextButton.isEnabled = buttonEnabled
            LoginManager.shared.setGender(self.buttonOption[self.selectedButtonIndex])
        }
    }
}

#if DEBUG
extension LoginGenderViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: LoginGenderViewController

        var genderTitleLabel: SoliULabel { target.genderTitleLabel }

        var nextButton: SoliUButton { target.nextButton }

    }
}
#endif
