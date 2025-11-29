//
//  BiometricsViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 7/21/24.
//

import Foundation
import UIKit
import LocalAuthentication

final class BiometricsViewController: BaseViewController {
    private lazy var titleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = "Enable Face ID & Fingerprints"
        label.font = SoliUFont.medium16
        label.textColor = SoliUColor.soliuBlack
        return label
    }()

    private lazy var biometricSwitch: UISwitch = {
        let biometricSwitch = UISwitch()
        biometricSwitch.onTintColor = SoliUColor.newSoliuBlue
        biometricSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        return biometricSwitch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SoliUColor.homepageBackground
        setCustomBackNavigationButton()
        setNavigationTitle(title: "Bio-metrics")
        setupView()
        checkBiometricStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupView() {
        view.backgroundColor = .white
        addAutoLayoutSubViews([titleLabel, biometricSwitch])
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            biometricSwitch.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 10),
            //biometricSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func checkBiometricStatus() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if UserDefaults.standard.bool(forKey: "biometricEnabled") {
                biometricSwitch.isOn = true
            } else {
                biometricSwitch.isOn = false
            }
        } else {
            // Biometrics not available
            biometricSwitch.isEnabled = false
        }
    }

    @objc private func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            enableBiometricLogin()
        } else {
            disableBiometricLogin()
        }
    }

    private func enableBiometricLogin() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Enable Face ID or Touch ID to log in securely.") { success, evaluationError in
                DispatchQueue.main.async {
                    if success {
                        UserDefaults.standard.set(true, forKey: "biometricEnabled")
                        self.biometricSwitch.isOn = true
                    } else {
                        self.biometricSwitch.isOn = false
                    }
                }
            }
        } else {
            biometricSwitch.isOn = false
        }
    }

    private func disableBiometricLogin() {
        UserDefaults.standard.set(false, forKey: "biometricEnabled")
        biometricSwitch.isOn = false
    }
}

#if DEBUG
extension BiometricsViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: BiometricsViewController

        var titleLabel: SoliULabel { target.titleLabel }

        var biometricSwitch: UISwitch { target.biometricSwitch }

        func setupView() { target.setupView() }

        func setupConstraints() { target.setupConstraints() }

        func checkBiometricStatus() { target.checkBiometricStatus() }

        func enableBiometricLogin() { target.enableBiometricLogin() }

        func disableBiometricLogin() { target.disableBiometricLogin() }
    }
}
#endif
