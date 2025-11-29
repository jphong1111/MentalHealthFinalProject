//
//  SignUpViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/10/24.
//

import Foundation
import UIKit

final class SignUpViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var signupTitleLabel: SoliULabel! {
        didSet {
            self.signupTitleLabel.text = .localized(.signUp)
        }
    }
    @IBOutlet weak var signupSubTitleLabel: SoliULabel! {
        didSet {
            self.signupSubTitleLabel.text = .localized(.enterYourDetails)
        }
    }
    @IBOutlet weak var emailLabel: SoliULabel! {
        didSet {
            self.emailLabel.text = .localized(.email)
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            self.emailTextField.placeholder = .localized(.enterEmail)
            self.emailTextField.autocorrectionType = .no
            self.emailTextField.spellCheckingType = .no
        }
    }
    @IBOutlet weak var passwordLabel: SoliULabel! {
        didSet {
            self.passwordLabel.text = .localized(.password)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.isSecureTextEntry = true
            self.passwordTextField.placeholder = .localized(.enterPassword)
        }
    }

    @IBOutlet weak var passwordToggleLabel: SoliULabel!

    @IBOutlet weak var confirmPasswordLabel: SoliULabel! {
        didSet {
            self.confirmPasswordLabel.text = .localized(.confirmPassword)
        }
    }
    
    @IBOutlet weak var passwordConfirmationTextField: UITextField! {
        didSet {
            self.passwordConfirmationTextField.isSecureTextEntry = true
            self.passwordConfirmationTextField.placeholder = .localized(.enterPassword)
        }
    }

    @IBOutlet weak var passwordConfirmationToggleLabel: SoliULabel!

    private lazy var nextButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.next), for: .normal)
        button.titleLabel?.font = SoliUFont.black14
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = SoliUColor.newSoliuBlue
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(navigateToGenderScreen), for: .touchUpInside)
        return button
    }()

    private lazy var incorrectPasswordLabel: SoliULabel = {
        let label = SoliULabel()
        label.textColor = SoliUColor.noButtonColor
        label.font = SoliUFont.regular10
        label.isHidden = true
        return label
    }()

    private lazy var passwordLengthLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.passwordLengthWarning)
        label.textColor = SoliUColor.noButtonColor
        label.font = SoliUFont.regular10
        label.isHidden = true
        return label
    }()

    private lazy var alreadHaveAccountLabel: SoliULabel = {
        let dontHaveAccountLabel = SoliULabel()
        dontHaveAccountLabel.text = .localized(.alreadyHaveAccount)
        dontHaveAccountLabel.font = SoliUFont.regular12
        return dontHaveAccountLabel
    }()

    private lazy var loginButton: SoliUButton = {
        let signupButton = SoliUButton()
        signupButton.setTitle(.localized(.login), for: .normal)
        signupButton.titleLabel?.font = SoliUFont.bold12
        signupButton.setTitleColor(SoliUColor.newSoliuBlue, for: .normal)
        signupButton.addTarget(self, action: #selector(navigateToLogin), for: .touchUpInside)
        return signupButton
    }()
    
    private lazy var alreadHaveAccountStackView: SoliUStackView = {
        let dontHaveStackView = SoliUStackView()
        dontHaveStackView.addArrangedSubView([alreadHaveAccountLabel, loginButton])
        dontHaveStackView.axis = .horizontal
        dontHaveStackView.spacing = 5
        return dontHaveStackView
    }()

    private lazy var continueAsGuestButton: SoliUButton = {
        let continueAsGuestButton = SoliUButton()
        let titleText = String.localized(.continueAsGuest)
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: SoliUColor.soliuBlack,
            .font: SoliUFont.regular12
        ]
        
        let attributedTitle = NSAttributedString(string: titleText, attributes: attributes)
        continueAsGuestButton.setAttributedTitle(attributedTitle, for: .normal)
        continueAsGuestButton.addTarget(self, action: #selector(tapAsGuest), for: .touchUpInside)
        return continueAsGuestButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomBackNavigationButton()
        setupUI()

        // Set the delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        
        addPasswordToggleButton()
        emailTextField.addTarget(self, action: #selector(emailTextFieldsDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldsDidChange), for: .editingChanged)
        passwordConfirmationTextField.addTarget(self, action: #selector(passwordTextFieldsDidChange(_:)), for: .editingChanged)
        continueAsGuestButton.addTarget(self, action: #selector(tapAsGuest), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.bounds.height / 2
        if nextButton.isEnabled {
            nextButton.backgroundColor = SoliUColor.newSoliuBlue
        }
    }

    private func setupUI() {
        view.addSubView([incorrectPasswordLabel, passwordLengthLabel, alreadHaveAccountStackView, nextButton, continueAsGuestButton])

        NSLayoutConstraint.activate([
            passwordLengthLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
            passwordLengthLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordLengthLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            incorrectPasswordLabel.leadingAnchor.constraint(equalTo: passwordLengthLabel.leadingAnchor),
            incorrectPasswordLabel.topAnchor.constraint(equalTo: passwordConfirmationTextField.bottomAnchor, constant: 5),
            
            nextButton.heightAnchor.constraint(equalToConstant: 45),
            nextButton.topAnchor.constraint(equalTo: passwordConfirmationTextField.bottomAnchor, constant: 60),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            alreadHaveAccountStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alreadHaveAccountStackView.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 10),
            
            continueAsGuestButton.topAnchor.constraint(greaterThanOrEqualTo: alreadHaveAccountStackView.bottomAnchor, constant: 20),
            continueAsGuestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueAsGuestButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func tapAsGuest() {
        showAlert(title: .localized(.success), description: .localized(.continueAsGuest))
        LoginManager.shared.setLoggedIn(false)
        navigate(to: HomeTabBarController.self)
    }
    
    @objc private func navigateToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func navigateToGenderScreen() {
        guard let email = emailTextField.text else { return }

        FBNetworkLayer.shared.checkDuplicateEmail(email: email) { isDuplicate, error in
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Server Issue",
                                                  message: "We encountered an issue while processing your request. Please try again later.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: .localized(.ok), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                if isDuplicate {
                    let alert = UIAlertController(title: "Email Used",
                                                  message: "The email you entered is already in use. Please choose a different email.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: .localized(.ok), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    self.setIDAndPassword()
                    self.navigate(LoginGenderViewController())
                    return
                }
            }
        }
    }
    
    private func checkEmailAndPassword() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmation = passwordConfirmationTextField.text, !confirmation.isEmpty,
              checkPassword(password), checkEmailFormat(email),
              password == confirmation else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
            passwordTextField.textColor = .black
            return
        }
        nextButton.isEnabled = true
        nextButton.alpha = 1
    }
    
    private func checkPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    private func checkEmailFormat(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func addPasswordToggleButton() {
        passwordToggleLabel.text = .localized(.show)
        passwordToggleLabel.textColor = SoliUColor.showTitle
        passwordToggleLabel.font = SoliUFont.regular8
        passwordToggleLabel.isUserInteractionEnabled = true
        
        passwordConfirmationToggleLabel.text = .localized(.show)
        passwordConfirmationToggleLabel.textColor = SoliUColor.showTitle
        passwordConfirmationToggleLabel.font = SoliUFont.regular8
        passwordConfirmationToggleLabel.isUserInteractionEnabled = true

        let togglePasswordViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordView))
        passwordToggleLabel.addGestureRecognizer(togglePasswordViewTapGesture)
        
        let toggleConfirmPasswordViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleConfirmPasswordView))
        passwordConfirmationToggleLabel.addGestureRecognizer(toggleConfirmPasswordViewTapGesture)
    }
    
    @objc private func toggleConfirmPasswordView(_ sender: SoliUButton) {
        passwordConfirmationTextField.isSecureTextEntry.toggle()
        if let label = passwordConfirmationTextField.rightView as? SoliULabel {
            label.text = passwordConfirmationTextField.isSecureTextEntry ? .localized(.show) : .localized(.hide)
        }
    }
    
    @objc private func togglePasswordView(_ sender: SoliUButton) {
        passwordTextField.isSecureTextEntry.toggle()
        if let label = passwordTextField.rightView as? SoliULabel {
            label.text = passwordTextField.isSecureTextEntry ? .localized(.show) : .localized(.hide)
        }
    }
    
    private func setIDAndPassword() {
        guard let email = emailTextField.text, checkEmailFormat(email),
              let password = passwordTextField.text, checkPassword(password) else {
            nextButton.isEnabled = false
            passwordTextField.textColor = .black
            return
        }
        LoginManager.shared.setEmail(email)
        KeychainHelper.shared.savePassword(password, for: email)
    }
    
    @objc func emailTextFieldsDidChange(_ textField: UITextField) {
        checkEmailAndPassword()
    }
    
    @objc func passwordTextFieldsDidChange(_ textField: UITextField) {
        checkEmailAndPassword()
        updatePasswordValidation()
        updatePasswordConfirmationTextField()
    }

    private func updatePasswordValidation() {
        guard let password = passwordTextField.text else { return }

        if password.count < 6 {
            passwordLengthLabel.isHidden = false
        } else {
            passwordLengthLabel.isHidden = true
        }
    }

    private func updatePasswordConfirmationTextField() {
        guard let password = passwordTextField.text, let confirmation = passwordConfirmationTextField.text else {
            return
        }

        DispatchQueue.main.async {
            if !confirmation.isEmpty {
                self.incorrectPasswordLabel.isHidden = false
                
                if password == confirmation && self.checkPassword(confirmation) {
                    self.incorrectPasswordLabel.text = .localized(.correctPassword)
                    self.incorrectPasswordLabel.textColor = SoliUColor.yesButtonColor
                    self.passwordConfirmationTextField.addBorderAndColor(color: SoliUColor.yesButtonColor, width: 1, corner_radius: 5)
                    
                    if let email = self.emailTextField.text, self.checkEmailFormat(email) {
                        self.nextButton.isEnabled = true
                        self.nextButton.alpha = 1.0
                    }
                } else {
                    self.incorrectPasswordLabel.text = .localized(.incorrectPassword)
                    self.incorrectPasswordLabel.textColor = SoliUColor.noButtonColor
                    self.passwordConfirmationTextField.addBorderAndColor(color: SoliUColor.noButtonColor, width: 1, corner_radius: 5)
                    self.nextButton.isEnabled = false
                    self.nextButton.alpha = 0.5
                }
            }
            else {
                self.incorrectPasswordLabel.isHidden = true
                self.passwordConfirmationTextField.addBorderAndColor(color: .clear, width: 1, corner_radius: 5)
                self.nextButton.isEnabled = false
                self.nextButton.alpha = 0.5
            }
        }
    }
}

#if DEBUG
extension SignUpViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: SignUpViewController

        var signupTitleLabel: SoliULabel! { target.signupTitleLabel }

        var signupSubTitleLabel: SoliULabel! { target.signupSubTitleLabel }

        var emailLabel: SoliULabel! { target.emailLabel }

        var emailTextField: UITextField! { target.emailTextField }

        var passwordLabel: SoliULabel! { target.passwordLabel }

        var passwordTextField: UITextField! { target.passwordTextField }

        var passwordToggleLabel: SoliULabel! { target.passwordToggleLabel }

        var confirmPasswordLabel: SoliULabel! { target.confirmPasswordLabel }

        var passwordConfirmationTextField: UITextField! { target.passwordConfirmationTextField }

        var nextButton: SoliUButton { target.nextButton }

        var incorrectPasswordLabel: SoliULabel { target.incorrectPasswordLabel }

        var passwordLengthLabel: SoliULabel { target.passwordLengthLabel }

        var alreadHaveAccountLabel: SoliULabel { target.alreadHaveAccountLabel }

        var loginButton: SoliUButton { target.loginButton }

        var alreadHaveAccountStackView: SoliUStackView { target.alreadHaveAccountStackView }

        var continueAsGuestButton: SoliUButton { target.continueAsGuestButton }

    }
}
#endif
