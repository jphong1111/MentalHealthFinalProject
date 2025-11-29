//
//  AccountHomeViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 2/5/24.
//

import Foundation
import UIKit

final class AccountHomeViewController: BaseViewController {
    private static let soliuWebsite = "https://soliu.org"
    
    @IBOutlet weak var guestNameLabel: SoliULabel! {
        didSet {
            if LoginManager.shared.isLoggedIn() {
                self.guestNameLabel.text = LoginManager.shared.getNickName()
            } else {
                self.guestNameLabel.text = .localized(.guest)
            }
        }
    }
    @IBOutlet weak var guestEmailLabel: SoliULabel! {
        didSet {
            self.guestEmailLabel.text = LoginManager.shared.getEmail()
        }
    }
    @IBOutlet weak var demographicsButton: SoliUButton! {
        didSet {
            demographicsButton.setTitle(.localized(.demographics), for: .normal)
        }
    }
    @IBOutlet weak var medicalReferenceButton: SoliUButton! {
        didSet {
            self.medicalReferenceButton.setTitle(.localized(.medicalReference), for: .normal)
        }
    }
    @IBOutlet weak var updateButton: SoliUButton! {
        didSet {
            updateButton.setTitle(.localized(.update), for: .normal)
        }
    }
    @IBOutlet weak var upToDateLabel: SoliULabel! {
        didSet {
            self.upToDateLabel.text = .localized(.upToDate)
        }
    }
    @IBOutlet weak var feedbackButton: SoliUButton! {
        didSet {
            self.feedbackButton.setTitle(.localized(.feedback), for: .normal)
        }
    }
    @IBOutlet weak var settingIconImageView: UIImageView! {
        didSet {
            self.settingIconImageView.image = ImageAsset.settingIcon.image.withTintColor(UIColor(hex: "#2d2d2d"))
        }
    }
    @IBOutlet weak var settingButton: SoliUButton! {
        didSet {
            self.settingButton.setTitle(.localized(.setting), for: .normal)
        }
    }
    
    private lazy var visitWebsiteButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.visitWebsite), for: .normal)
        button.setTitleColor(SoliUColor.newSoliuBlue, for: .normal)
        button.titleLabel?.font = SoliUFont.regular14
        button.addTarget(self, action: #selector(goToSoliuWebpage), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteAccountButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.deleteAccount), for: .normal)
        button.setTitleColor(SoliUColor.diaryRedBorder, for: .normal)
        button.titleLabel?.font = SoliUFont.regular14
        button.addTarget(self, action: #selector(showDeleteAlert), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoutButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.logOut), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = SoliUFont.regular14
        button.addTarget(self, action: #selector(showLogoutAlert), for: .touchUpInside)
        return button
    }()
    
    private lazy var createAccountButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.createAccount), for: .normal)
        button.titleLabel?.font = SoliUFont.regular14
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SoliUColor.homepageBackground
        
        setupView()
        addTarget()
        
        if LoginManager.shared.isLoggedIn() {
            deleteAccountButton.isHidden = false
            logoutButton.isHidden = false
            guestEmailLabel.isHidden = false
            createAccountButton.isHidden = true
        } else {
            createAccountButton.isHidden = false
            deleteAccountButton.isHidden = true
            guestEmailLabel.isHidden = true
            logoutButton.isHidden = true
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLanguage),
            name: .languageDidChange,
            object: nil
        )
        
        updateDynamicLanguage()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .languageDidChange, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createAccountButton.layer.cornerRadius = createAccountButton.bounds.height / 2
        createAccountButton.backgroundColor = SoliUColor.newSoliuBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupView() {
        view.addSubView([createAccountButton, visitWebsiteButton, deleteAccountButton, logoutButton])
        
        NSLayoutConstraint.activate([
            createAccountButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            createAccountButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            createAccountButton.widthAnchor.constraint(equalToConstant: 120),
            createAccountButton.heightAnchor.constraint(equalToConstant: 30),
            
            visitWebsiteButton.topAnchor.constraint(equalTo: settingButton.bottomAnchor, constant: 15),
            visitWebsiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            deleteAccountButton.topAnchor.constraint(equalTo: visitWebsiteButton.bottomAnchor, constant: 20),
            deleteAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            logoutButton.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 20),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
        ])
    }
    
    private func addTarget() {
        demographicsButton.addTarget(self, action: #selector(demographicButtonClick), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(createAccountButtonClick), for: .touchUpInside)
        
        medicalReferenceButton.addTarget(self, action: #selector(medicalButtonClick), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(updateButtonClick), for: .touchUpInside)
        feedbackButton.addTarget(self, action: #selector(feedbackButtonClick), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(settingButtonClick), for: .touchUpInside)
    }
    
    @objc private func updateLanguage() {
        DispatchQueue.main.async {
            self.updateDynamicLanguage()
        }
    }
    
    private func updateDynamicLanguage() {
        if LoginManager.shared.isLoggedIn() {
            guestNameLabel.text = LoginManager.shared.getNickName()
        } else {
            guestNameLabel.text = .localized(.guest)
        }
        
        guestEmailLabel.text = LoginManager.shared.getEmail()
        demographicsButton.setTitle(.localized(.demographics), for: .normal)
        medicalReferenceButton.setTitle(.localized(.medicalReference), for: .normal)
        updateButton.setTitle(.localized(.update), for: .normal)
        upToDateLabel.text = .localized(.upToDate)
        feedbackButton.setTitle(.localized(.feedback), for: .normal)
        settingButton.setTitle(.localized(.setting), for: .normal)
        deleteAccountButton.setTitle(.localized(.deleteAccount), for: .normal)
        createAccountButton.setTitle(.localized(.createAccount), for: .normal)
        createUnderLineText(button: logoutButton, text: .localized(.logOut))
        createUnderLineText(button: deleteAccountButton, text: .localized(.deleteAccount))
        createUnderLineText(button: visitWebsiteButton, text: .localized(.visitWebsite))
    }
}

extension AccountHomeViewController {
    @objc private func goToSoliuWebpage() {
        if let url = URL(string: AccountHomeViewController.soliuWebsite) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func demographicButtonClick() {
        navigate(DemographicViewController())
    }
    
    @objc private func medicalButtonClick() {
        navigate(MedicalReferenceViewController())
    }
    
    @objc private func updateButtonClick() {
        navigate(UpdateCheckViewController())
    }
    
    @objc private func feedbackButtonClick() {
        navigate(FeedbackViewController())
    }
    
    @objc private func settingButtonClick() {
        navigate(SettingViewController())
    }
    
    @objc private func showDeleteAlert() {
        let accountAlertVC = AccountAlertViewController(alertType: .delete)
        accountAlertVC.modalPresentationStyle = .overFullScreen
        accountAlertVC.modalTransitionStyle = .crossDissolve
        present(accountAlertVC, animated: true, completion: nil)
    }
    
    @objc private func showLogoutAlert() {
        let accountAlertVC = AccountAlertViewController(alertType: .logout)
        accountAlertVC.modalPresentationStyle = .overFullScreen
        accountAlertVC.modalTransitionStyle = .crossDissolve
        present(accountAlertVC, animated: true, completion: nil)
    }
    
    @objc private func createAccountButtonClick() {
        let accountAlertVC = AccountAlertViewController(alertType: .createAccount)
        accountAlertVC.modalPresentationStyle = .overFullScreen
        accountAlertVC.modalTransitionStyle = .crossDissolve
        present(accountAlertVC, animated: true, completion: nil)
    }
}

