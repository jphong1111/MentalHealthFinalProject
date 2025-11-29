//
//  DemographicDetailViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 9/25/25.
//

import UIKit

enum DetailType {
    case ethnicity
    case workStatus
    case age
}

final class DemographicDetailViewController: BaseViewController {
    struct Model {
        let title: String
        let type: DetailType
    }
    
    var model: Model? {
        didSet {
            applyModel()
        }
    }
    //현재 바로바로 업데이트가 안되는데 @Published 로 바꿔도 괜찮을듯 <-loginmanager
//    var onDidSave: (() -> Void)?
    private var selectedButtonIndex = 0
    private let ethnicityOptions: [Ethnicity] = [
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
    private let workStatusOptions: [WorkStatus] = [.student, .employed, .other]
    
    private lazy var saveButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.save), for: .normal)
        button.titleLabel?.font = SoliUFont.black14
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.backgroundColor = SoliUColor.loginNextDisabled
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    private lazy var ageTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.placeholder = .localized(.enterYourAge)
        textField.addTarget(self, action: #selector(ageEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private func applyModel() {
        guard let model else { return }
        setNavigationTitle(title: model.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SoliUColor.homepageBackground
        saveButton.isEnabled = false
        setCustomBackNavigationButton()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.layer.cornerRadius = saveButton.bounds.height / 2
        if saveButton.isEnabled {
            saveButton.backgroundColor = SoliUColor.newSoliuBlue
        }
    }
    
    private func setupUI() {
        addAutoLayoutSubViews([saveButton])
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 45),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        guard let type = model?.type else { return }
        switch type {
        case .ethnicity:
            let labels = ethnicityOptions.map { $0.localized.capitalizedEachWord() }
            createSelectButton(
                labels: labels,
                spacing: 10,
                placement: .centered(yOffset: -SoliUSpacing.space40)
            ) { [weak self] selected, enabled in
                guard let self else { return }
                self.selectedButtonIndex = selected
                self.saveButton.isEnabled = enabled
            }
            
        case .workStatus:
            let labels = workStatusOptions.map { $0.localized.capitalizedEachWord() }
            createSelectButton(
                labels: labels,
                spacing: 10,
                placement: .centered(yOffset: -SoliUSpacing.space40)
            ) { [weak self] selected, enabled in
                guard let self else { return }
                self.selectedButtonIndex = selected
                self.saveButton.isEnabled = enabled
            }
            
        case .age:
            addAutoLayoutSubView(ageTextField)
            NSLayoutConstraint.activate([
                ageTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -SoliUSpacing.space40),
                ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space24),
                ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space24),
                ageTextField.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
    }
    
    @objc private func ageEditingChanged() {
        if let txt = ageTextField.text, let age = Int(txt), (1...100).contains(age) {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        view.setNeedsLayout()
    }
    
    @objc private func handleSave() {
        guard let type = model?.type else { return }
        var updatedArray: [DemographicKey] = []
        
        switch type {
        case .ethnicity:
            let selected = ethnicityOptions[selectedButtonIndex]
            LoginManager.shared.setEthnicity(selected)
            updatedArray.append(.ethnicity(selected))
        case .workStatus:
            let selected = workStatusOptions[selectedButtonIndex]
            LoginManager.shared.setWorkStatus(selected)
            updatedArray.append(.workStatus(selected))
        case .age:
            guard let txt = ageTextField.text, let age = Int(txt), (1...100).contains(age) else { return }
            LoginManager.shared.setAge(age)
            updatedArray.append(.age(age))
        }

        FBNetworkLayer.shared.updateUserDemographics(
            email: LoginManager.shared.getEmail(),
            updates: updatedArray
        ) { error in
            if error != nil {
                self.showAlert(title: .localized(.errorTitle), description: "\(String.localized(.errorTryAgain))")
            } else {
                self.showAlert(title: .localized(.success), description: .localized(.infoUpdated))
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

