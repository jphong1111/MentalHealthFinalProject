//
//  SettingViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 2/4/25.
//

import UIKit

final class SettingViewController: BaseViewController {
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowRadius = SoliUSpacing.space8
        view.layer.shadowOffset = CGSize(width: 0, height: SoliUSpacing.space4)
        return view
    }()

    private lazy var languageTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.languageSetting)
        label.font = SoliUFont.medium16
        label.textColor = SoliUColor.soliuBlack
        return label
    }()

    private lazy var selectedLanguageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(currentLanguageName(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.tintColor = SoliUColor.newSoliuBlue
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.layer.cornerRadius = SoliUSpacing.space8
        button.isUserInteractionEnabled = false
        return button
    }()

    private lazy var languagePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    //----------------------------------------------------------------------
    private lazy var notificationToggleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Notifications"
        label.font = SoliUFont.medium16
        label.textColor = SoliUColor.soliuBlack
        return label
    }()

    private lazy var notificationSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true  // 기본값
        toggle.addTarget(self, action: #selector(didToggleNotification), for: .valueChanged)
        return toggle
    }()

    private lazy var timePickerLabel: UILabel = {
        let label = UILabel()
        label.text = "Set Notification time"
        label.font = SoliUFont.medium16
        label.textColor = SoliUColor.soliuBlack
        return label
    }()

    private lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR") // 한국어 기준
        picker.date = defaultAlarmTime()
        picker.addTarget(self, action: #selector(didChangeTimePicker), for: .valueChanged)
        return picker
    }()

    private let languages = ["English", "한국어"]

    private var selectedLanguage: String {
        get { SoliULanguageManager.shared.currentLanguage }
        set { SoliULanguageManager.shared.currentLanguage = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SoliUColor.homepageBackground
        setCustomBackNavigationButton()
        setNavigationTitle(title: .localized(.setting))

        view.addSubView(cardView)
        cardView.addSubView([
            languageTitleLabel,
            selectedLanguageButton,
            languagePickerView,
            notificationToggleLabel,
            notificationSwitch,
            timePickerLabel,
            timePicker
        ])
        setupConstraints()

        // 언어에 맞게 Picker 선택 고정
        if let index = (selectedLanguage == "ko" ? languages.firstIndex(of: "한국어") : languages.firstIndex(of: "English")) {
            languagePickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            languageTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 22),
            languageTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 22),
            
            selectedLanguageButton.centerYAnchor.constraint(equalTo: languageTitleLabel.centerYAnchor),
            selectedLanguageButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),
            selectedLanguageButton.heightAnchor.constraint(equalToConstant: 36),
            selectedLanguageButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),

            languagePickerView.topAnchor.constraint(equalTo: languageTitleLabel.bottomAnchor, constant: 14),
            languagePickerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            languagePickerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            languagePickerView.heightAnchor.constraint(equalToConstant: 140),
            
            notificationToggleLabel.topAnchor.constraint(equalTo: languagePickerView.bottomAnchor, constant: 20),
            notificationToggleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 22),

            notificationSwitch.centerYAnchor.constraint(equalTo: notificationToggleLabel.centerYAnchor),
            notificationSwitch.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),

            timePickerLabel.topAnchor.constraint(equalTo: notificationToggleLabel.bottomAnchor, constant: 20),
            timePickerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 22),

            timePicker.topAnchor.constraint(equalTo: timePickerLabel.bottomAnchor, constant: 10),
            timePicker.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            timePicker.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
        ])
    }

    private func currentLanguageName() -> String {
        switch selectedLanguage {
        case "ko": return "한국어"
        default: return "English"
        }
    }

    private func updateSelectedLanguageUI() {
        selectedLanguageButton.setTitle(currentLanguageName(), for: .normal)
    }
    
    // MARK: - Notification Actions
    @objc private func didToggleNotification(_ sender: UISwitch) {
        if !sender.isOn {
            LocalNotificationManager.shared.removeScheduledNotification(identifier: LocalNotificationManager.dailyReminderIdentifier)
        }
        print("🔔 알림 상태: \(sender.isOn ? "켜짐" : "꺼짐")")
    }

    @objc private func didChangeTimePicker(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        print("⏰ 선택된 알림 시간: \(formatter.string(from: selectedDate))")
        // Store selected time to UserDefaults, etc.
    }

    private func defaultAlarmTime() -> Date {
        var components = DateComponents()
        components.hour = 21
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
}

// MARK: - UIPickerViewDelegate & DataSource
extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { languages.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        languages[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = languages[row]
        switch selected {
        case "English":
            selectedLanguage = "en"
        case "한국어":
            selectedLanguage = "ko"
        default:
            selectedLanguage = "en"
        }
        updateSelectedLanguageUI()
    }
}


#if DEBUG
extension SettingViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: SettingViewController

        var languagePickerView: UIPickerView { target.languagePickerView }

        func setupConstraints() { target.setupConstraints() }
    }
}
#endif
