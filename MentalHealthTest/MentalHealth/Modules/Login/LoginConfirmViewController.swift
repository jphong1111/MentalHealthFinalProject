//
//  LoginConfirmViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/22/24.
//

import UIKit

final class LoginConfirmViewController: BaseViewController {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorderAndColor(color: SoliUColor.newSoliuBlue, width: 2, corner_radius: 20)
        return view
    }()
    
    private lazy var nickNameLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = "\(String.localized(.nickname)): \(LoginManager.shared.getNickName())"
        label.font = SoliUFont.medium16
        label.textAlignment = .center
        return label
    }()
    
    private lazy var genderLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = "\(String.localized(.gender)): \(LoginManager.shared.getGender())"
        label.font = SoliUFont.medium16
        label.textAlignment = .center
        return label
    }()
    
    private lazy var ageLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = "\(String.localized(.age)): \(LoginManager.shared.getAge())"
        label.font = SoliUFont.medium16
        label.textAlignment = .center
        return label
    }()
    
    private lazy var statusLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = "\(String.localized(.status)): \(LoginManager.shared.getWorkStatus())"
        label.font = SoliUFont.medium16
        label.textAlignment = .center
        return label
    }()
    
    private lazy var ethnicityLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = "\(String.localized(.ethnicity)): \(LoginManager.shared.getEthnicity())"
        label.font = SoliUFont.medium16
        label.textAlignment = .center
        return label
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nickNameLabel,
            genderLabel,
            ageLabel,
            statusLabel,
            ethnicityLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var confirmTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.confirmDataTitle)
        label.font = SoliUFont.bold32
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var button: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.confirm), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = SoliUFont.black14
        button.backgroundColor = SoliUColor.newSoliuBlue
        button.addTarget(self, action: #selector(navigateToHomeScreen), for: .touchUpInside)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setCustomBackNavigationButton()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.layer.cornerRadius = button.bounds.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        view.addSubView([containerView, confirmTitleLabel, button])
        containerView.addSubView(infoStackView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            containerView.heightAnchor.constraint(equalToConstant: 250),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 225),

            infoStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            infoStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            infoStackView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: SoliUSpacing.space16),
            infoStackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -SoliUSpacing.space16),
            
            confirmTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            confirmTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space40),
            confirmTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space40),
            
            button.heightAnchor.constraint(equalToConstant: 45),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    /// Navigate to Hom View
    @objc private func navigateToHomeScreen() {
        self.clickedConfirmation { [weak self] success in
            guard let self = self else { return }
            if !success {
                print("Login Failed")
            }
            else {
                showAlert(title: .localized(.success), description: "\(String.localized(.success)) \(LoginManager.shared.getNickName())!")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                navigate(to: HomeTabBarController.self)
            }}
    }

    func clickedConfirmation(completion: @escaping (Bool) -> Void) {
        let userInfo = LoginManager.shared.getUserInfo()
        UserDefaults.standard.set(userInfo.email, forKey: "savedEmail")

        FBNetworkLayer.shared.createAccount(email: userInfo.email) { error in
                if let error = error as? CustomError {
                    self.showAlert(error: error)
                    print("Failed to create account: \(error)")
                    completion(false)
                } else {
                    FBNetworkLayer.shared.createUserInformation(userInfo: userInfo) { error in
                        if let error = error as? CustomError {
                            self.showAlert(error: error)
                            print("Failed to fetch user information: \(error)")
                            completion(false)
                        } else {
                            FBNetworkLayer.shared.addEmailToList(email: userInfo.email) { error in
                                if let error = error as? CustomError {
                                    self.showAlert(error: error)
                                    print("Failed to add email lists: \(error)")
                                    completion(false)
                                }
                                else {
                                    completion(true)
                                    LoginManager.shared.setMyUserInformation(userInfo)
                                    LoginManager.shared.setLoggedIn(true)
                                    print("User information successfully updated")
                                }
                            }
                        }
                    }
                }
            }
    }
}

#if DEBUG
extension LoginConfirmViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: LoginConfirmViewController

        var containerView: UIView! { target.containerView }

        var nickNameLabel: SoliULabel! { target.nickNameLabel }

        var genderLabel: SoliULabel! { target.genderLabel }

        var ageLabel: SoliULabel! { target.ageLabel }

        var statusLabel: SoliULabel! { target.statusLabel }

        var ethnicityLabel: SoliULabel! { target.ethnicityLabel }

        var confirmTitleLabel: SoliULabel { target.confirmTitleLabel }

        var button: SoliUButton { target.button }

        func clickedConfirmation(completion: @escaping (Bool) -> Void) {
            target.clickedConfirmation(completion: completion)
        }
    }
}
#endif
