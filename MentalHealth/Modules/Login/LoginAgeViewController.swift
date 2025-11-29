//
//  LoginAgeViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/22/24.
//

import UIKit

final class LoginAgeViewController: BaseViewController {
    private lazy var ageTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.whatsYourAge)
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
        button.addTarget(self, action: #selector(navigateToStatusScreen), for: .touchUpInside)
        return button
    }()
    
    lazy var ageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = .localized(.enterYourAge)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.textAlignment = .center
        return textField
    }()
    
    @objc func navigateToStatusScreen() {
        setupAge()
        navigate(LoginStatusViewController())
    }
    
    let maxCharacterLimit = 2 // Change this to your desired character limit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isEnabled = false

        setCustomBackNavigationButton()
        setupUI()
        self.view.backgroundColor = .white

        ageTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupAge() {
        guard let ageText = ageTextField.text else { return }
        guard let age = Int(ageText) else { return }
        LoginManager.shared.setAge(age)
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
        addAutoLayoutSubViews([ageTitleLabel, ageTextField,button])
        
        NSLayoutConstraint.activate([
            ageTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            ageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            ageTextField.topAnchor.constraint(equalTo: ageTitleLabel.bottomAnchor, constant: 120),
            ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            ageTextField.heightAnchor.constraint(equalToConstant: 40),
            
            button.heightAnchor.constraint(equalToConstant: 45),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
}
extension LoginAgeViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(){
        ageTextField.addBorderAndColor(color: SoliUColor.newSoliuBlue, width: 1, corner_radius: SoliUSpacing.space8)
        
        guard let age = ageTextField.text else {return}
        
        if age.isEmpty {
            button.isEnabled = false
        }
        else {
            button.isEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Set your maximum length here
        let maxLength = maxCharacterLimit
        
        // Check if the replacement string only contains numeric characters
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        // Ensure that the input is numeric and respects the maximum length
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

#if DEBUG
extension LoginAgeViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: LoginAgeViewController

        var ageTitleLabel: SoliULabel { target.ageTitleLabel }

        var button: SoliUButton { target.button }

        var ageTextField: UITextField { target.ageTextField }

    }
}
#endif
