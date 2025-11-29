//
//  LoginNickNameViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/24/24.
//

import Foundation
import UIKit

final class LoginNickNameViewController: BaseViewController {
    private static let maxCharacterLimit = 20 
   
    private lazy var nickNameTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.whatsYourNickname)
        label.font = SoliUFont.bold32
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = .localized(.enterYourNickname)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()

    lazy var characterLimitLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = "0/\(LoginNickNameViewController.maxCharacterLimit)"
        label.font = SoliUFont.regular12
        label.textColor = SoliUColor.soliuGrey
        return label
    }()
    
    private lazy var button: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.next), for: .normal)
        button.titleLabel?.font = SoliUFont.black14
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.backgroundColor = SoliUColor.loginNextDisabled
        button.isEnabled = false
        button.addTarget(self, action: #selector(navigateToConfirmScreen), for: .touchUpInside)
        return button
    }()
    
    @objc private func navigateToConfirmScreen() {
        guard let nickName = nicknameTextField.text else { return }
        LoginManager.shared.setNickName(nickName)
        navigate(LoginConfirmViewController())
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setCustomBackNavigationButton()
        setView()
        
        nicknameTextField.delegate = self
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.layer.cornerRadius = button.bounds.height / 2
        if button.isEnabled {
            button.backgroundColor = SoliUColor.newSoliuBlue
            nicknameTextField.layer.borderColor = SoliUColor.newSoliuBlue.cgColor
        } else {
            button.backgroundColor = SoliUColor.loginNextDisabled
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setView() {
        addAutoLayoutSubViews([nickNameTitleLabel, nicknameTextField, characterLimitLabel,button])
        
        NSLayoutConstraint.activate([
            nickNameTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nickNameTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nickNameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nickNameTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            nicknameTextField.topAnchor.constraint(equalTo: nickNameTitleLabel.bottomAnchor, constant: 50),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            characterLimitLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: SoliUSpacing.space8),
            characterLimitLabel.trailingAnchor.constraint(equalTo: nicknameTextField.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 45),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
}

extension LoginNickNameViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(){
        nicknameTextField.addBorderAndColor(color: SoliUColor.newSoliuBlue, width: 1, corner_radius: SoliUSpacing.space8)
        guard let nicknameTextField = nicknameTextField.text else {return}
        characterLimitLabel.text = "\(String(describing: nicknameTextField.count))/\(LoginNickNameViewController.maxCharacterLimit)"
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if newLength <= LoginNickNameViewController.maxCharacterLimit {
            characterLimitLabel.font = SoliUFont.regular12
            if newLength > 0 && newLength <= LoginNickNameViewController.maxCharacterLimit {
                button.isEnabled = true
            } else {
                button.isEnabled = false
            }
            return true
        } else {
            return false
        }
    }
}

#if DEBUG
extension LoginNickNameViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: LoginNickNameViewController

        var nickNameTitleLabel: SoliULabel { target.nickNameTitleLabel }

        var nicknameTextField: UITextField { target.nicknameTextField }

        var characterLimitLabel: SoliULabel { target.characterLimitLabel }

        var button: SoliUButton { target.button }

    }
}
#endif
