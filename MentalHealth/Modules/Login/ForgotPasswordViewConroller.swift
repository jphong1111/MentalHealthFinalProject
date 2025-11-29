import UIKit
import FirebaseAuth

final class ForgotPasswordViewController: BaseViewController, UITextFieldDelegate {
    private lazy var forgotPasswordTitle: SoliULabel = {
        let forgotPasswordTitle = SoliULabel()
        forgotPasswordTitle.text = .localized(.forgotPasswordTitle)
        forgotPasswordTitle.font = SoliUFont.bold32
        return forgotPasswordTitle
    }()
    
    private lazy var forgotPasswordDescription: SoliULabel = {
        let forgotPasswordDescription = SoliULabel()
        forgotPasswordDescription.text = .localized(.forgotPasswordDescription)
        forgotPasswordDescription.font = SoliUFont.regular14
        forgotPasswordDescription.numberOfLines = 0
        forgotPasswordDescription.textAlignment = .center
        return forgotPasswordDescription
    }()
    
    private lazy var emailLabel: SoliULabel = {
        let emailLabel = SoliULabel()
        emailLabel.text = .localized(.email)
        emailLabel.font = SoliUFont.regular12
        return emailLabel
    }()
    
    private lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = .localized(.enterEmail)
        emailTextField.font = SoliUFont.regular12
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = SoliUColor.tabBarBorder.cgColor
        emailTextField.layer.cornerRadius = SoliUSpacing.space8
        emailTextField.autocorrectionType = .no
        emailTextField.spellCheckingType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.setLeftPaddingPoints(10)
        return emailTextField
    }()
    
    private lazy var emailSentLabel: SoliULabel = {
        let emailSentLabel = SoliULabel()
        emailSentLabel.text = .localized(.codeSentMessage)
        emailSentLabel.font = SoliUFont.regular10
        emailSentLabel.textColor = SoliUColor.newSoliuBlue
        return emailSentLabel
    }()

    private lazy var sendCodeButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.sendCodeButton), for: .normal)
        button.titleLabel?.font = SoliUFont.black14
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = SoliUColor.newSoliuBlue
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setCustomBackNavigationButton()
        emailTextField.delegate = self
        
        sendCodeButton.isEnabled = false
        emailSentLabel.isHidden = true
        
        emailTextField.addTarget(self, action: #selector(checkEmailAndPassword), for: .editingChanged)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendCodeButton.layer.cornerRadius = sendCodeButton.bounds.height / 2
        if sendCodeButton.isEnabled {
            sendCodeButton.backgroundColor = SoliUColor.newSoliuBlue
        }
    }
    
    private func setupUI(){
        view.addSubView(
            [forgotPasswordTitle,
             forgotPasswordDescription,
             emailLabel,
             emailTextField,
             emailSentLabel,
             sendCodeButton]
        )
        
        NSLayoutConstraint.activate([
            forgotPasswordTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            forgotPasswordTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            forgotPasswordDescription.topAnchor.constraint(equalTo: forgotPasswordTitle.bottomAnchor, constant: SoliUSpacing.space16),
            forgotPasswordDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space20),
            forgotPasswordDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space20),

            emailLabel.topAnchor.constraint(equalTo: forgotPasswordDescription.bottomAnchor, constant: 100),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space40),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: SoliUSpacing.space8),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space40),
            emailTextField.heightAnchor.constraint(equalToConstant: SoliUSpacing.space40),

            emailSentLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: SoliUSpacing.space8),
            emailSentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space40),

            sendCodeButton.heightAnchor.constraint(equalToConstant: 45),
            sendCodeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            sendCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            sendCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }

    @objc private func checkEmailAndPassword() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        sendCodeButton.isEnabled = true
    }

    @objc private func submitButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty else { return }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard self == self else { return }
            if let error = error as NSError? {
                var errorTitle = String.localized(.resetFailed)
                var errorMessage = error.localizedDescription
                
                switch error.code {
                case AuthErrorCode.invalidEmail.rawValue:
                    errorTitle = .localized(.invalidEmailTitle)
                    errorMessage = .localized(.invalidEmailMessage)
                case AuthErrorCode.userNotFound.rawValue:
                    errorTitle = .localized(.emailNotFoundTitle)
                    errorMessage = .localized(.emailNotFoundMessage)
                case AuthErrorCode.networkError.rawValue:
                    errorTitle = .localized(.networkErrorTitle)
                    errorMessage = .localized(.networkErrorMessage)
                case AuthErrorCode.tooManyRequests.rawValue:
                    errorTitle = .localized(.tooManyAttemptsTitle)
                    errorMessage = .localized(.tooManyAttemptsMessage)
                default:
                    break
                }
                
                self.showAlert(title: errorTitle, message: errorMessage)
            } else {
                self.emailSentLabel.isHidden = false
                self.emailSentLabel.textColor = SoliUColor.chartMyScoreFill
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: .localized(.ok), style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

#if DEBUG
extension ForgotPasswordViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: ForgotPasswordViewController

        var forgotPasswordTitle: SoliULabel { target.forgotPasswordTitle }

        var forgotPasswordDescription: SoliULabel { target.forgotPasswordDescription }

        var emailLabel: SoliULabel { target.emailLabel }

        var emailTextField: UITextField { target.emailTextField }

        var emailSentLabel: SoliULabel { target.emailSentLabel }

        var sendCodeButton: SoliUButton { target.sendCodeButton }

    }
}
#endif
