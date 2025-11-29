//
//  AccountAlertViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 7/17/24.
//
import UIKit
import FirebaseAuth

public enum AccountAlertType {
    case logout
    case delete
    case createAccount
}

final class AccountAlertViewController: BaseViewController {
    private var alertType : AccountAlertType
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)

        setupUI(alertType: alertType)
    }
    
    init(alertType: AccountAlertType) {
        self.alertType = alertType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(alertType: AccountAlertType) {
        switch alertType {
        case .logout:
            let logoutAlertView = LogoutAlertView(alertType: alertType)
            logoutAlertView.delegate = self
            view.addSubView(logoutAlertView)
            
            NSLayoutConstraint.activate([
                logoutAlertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoutAlertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoutAlertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                logoutAlertView.widthAnchor.constraint(equalToConstant: 300),
                logoutAlertView.heightAnchor.constraint(equalToConstant: 200)
            ])
        case .delete:
            let deleteAccountAlertView = DeleteAccountAlertView()
            deleteAccountAlertView.delegate = self
            view.addSubView(deleteAccountAlertView)
            
            NSLayoutConstraint.activate([
                deleteAccountAlertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                deleteAccountAlertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                deleteAccountAlertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                deleteAccountAlertView.widthAnchor.constraint(equalToConstant: 300),
                deleteAccountAlertView.heightAnchor.constraint(equalToConstant: 200)
            ])
        case .createAccount:
            let createAccountView = LogoutAlertView(alertType: alertType)
            createAccountView.delegate = self
            view.addSubView(createAccountView)
            
            NSLayoutConstraint.activate([
                createAccountView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                createAccountView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                createAccountView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                createAccountView.widthAnchor.constraint(equalToConstant: 300),
                createAccountView.heightAnchor.constraint(equalToConstant: 200)
            ])
        }
    }

    private func navigateToLogInViewController() {
        navigate(to: LogInViewController.self) { logInViewController in
            UserDefaults.standard.set(false, forKey: "isLoggedIn")

            let navigationController = UINavigationController(rootViewController: logInViewController)
            
            DispatchQueue.main.async {
                if let window = UIApplication.shared.currentUIWindow() {
                    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        window.rootViewController = navigationController
                    }, completion: nil)
                } else {
                    assertionFailure("No window found.")
                }
            }
        }
    }
}

/// DELETE ACCOUNT ALERT
extension AccountAlertViewController: DeleteAlertViewDelegate {
    
    //Account Delete NO
    func didTapNoButton() {
        dismiss(animated: true, completion: nil)
    }

    //Account Delete YES
    func didTapYesButton() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error {
                    // Handle error
                    print("Error deleting user \(error)")
                } else {
                    // Successfully deleted the account
                    print("User account deleted successfully.")
                    KeychainHelper.shared.deletePassword(for: LoginManager.shared.getEmail())
                    self.navigateToLogInViewController()
                }
            }
        } else {
            print("No user is currently signed in.")
        }
        dismiss(animated: true, completion: nil)
    }
}

/// LOGOUT ACCOUNT ALERT
extension AccountAlertViewController: LogoutAlertViewDelegate {
    //Account logout NO
    func didTapLogoutNoButton() {
        dismiss(animated: true, completion: nil)
    }
    
    //Account logout YES
    func didTapLogoutYesButton() {
        logoutUser()
    }
    
    private func logoutUser() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            navigateToLogInViewController()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            // Optionally show an error message to the user
        }
    }
}

#if DEBUG
extension AccountAlertViewController {
    var testHooks: TestHooks { .init(target: self) }
    
    struct TestHooks {
        var target: AccountAlertViewController
        
        var alertType: AccountAlertType {
            target.alertType
        }
        
        func setupUI(alertType: AccountAlertType) {
            target.setupUI(alertType: alertType)
        }

        func didTapLogoutNoButton() {
            target.didTapLogoutNoButton()
        }
        
        func didTapLogoutYesButton() {
            target.didTapLogoutYesButton()
        }
    }
}
#endif
