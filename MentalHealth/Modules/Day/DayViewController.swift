//
//  DayViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/4/24.
//

import UIKit
import Foundation
import Combine

final class DayViewController: BaseViewController {
    var imageUpdatePublisher: PassthroughSubject<UIImage, Never>?
    @IBOutlet weak var currentDate: SoliULabel! {
        didSet {
            self.currentDate.text = getCurrentMonthAndDate()
        }
    }
    @IBOutlet weak var sundayView: UIView!
    @IBOutlet weak var mondayView: UIView!
    @IBOutlet weak var tuesdayView: UIView!
    @IBOutlet weak var wednesdayView: UIView!
    @IBOutlet weak var thursdayView: UIView!
    @IBOutlet weak var fridayView: UIView!
    @IBOutlet weak var saturdayView: UIView!
    
    @IBOutlet weak var sundayStar: UIImageView!
    @IBOutlet weak var mondayStar: UIImageView!
    @IBOutlet weak var tuesdayStar: UIImageView!
    @IBOutlet weak var wednesdayStar: UIImageView!
    @IBOutlet weak var thursdayStar: UIImageView!
    @IBOutlet weak var fridayStar: UIImageView!
    @IBOutlet weak var saturdayStar: UIImageView!
    
    @IBOutlet weak var sundayDate: SoliULabel!
    @IBOutlet weak var mondayDate: SoliULabel!
    @IBOutlet weak var tuesdayDate: SoliULabel!
    @IBOutlet weak var wednesdayDate: SoliULabel!
    @IBOutlet weak var thursdayDate: SoliULabel!
    @IBOutlet weak var fridayDate: SoliULabel!
    @IBOutlet weak var saturdayDate: SoliULabel!
    
    @IBOutlet weak var sundayLabel: SoliULabel!
    @IBOutlet weak var mondayLabel: SoliULabel!
    @IBOutlet weak var tuesdayLabel: SoliULabel!
    @IBOutlet weak var wednesdayLabel: SoliULabel!
    @IBOutlet weak var thursdayLabel: SoliULabel!
    @IBOutlet weak var fridayLabel: SoliULabel!
    @IBOutlet weak var saturdayLabel: SoliULabel!
    
    @IBOutlet weak var sundayEmoji: UIImageView!
    @IBOutlet weak var mondayEmoji: UIImageView!
    @IBOutlet weak var tuesdayEmoji: UIImageView!
    @IBOutlet weak var wednesdayEmoji: UIImageView!
    @IBOutlet weak var thursdayEmoji: UIImageView!
    @IBOutlet weak var fridayEmoji: UIImageView!
    @IBOutlet weak var saturdayEmoji: UIImageView!
    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var nameLabel: SoliULabel! {
        didSet {
            if LoginManager.shared.isLoggedIn() {
                self.nameLabel.text = "Hi \(LoginManager.shared.getNickName())!"
            } else {
                self.nameLabel.text = "Hi Guest!"
            }
        }
    }
    @IBOutlet weak var subLabel: SoliULabel! {
        didSet {
            self.subLabel.text = .localized(.howDoYouFeelToday)
        }
    }
    @IBOutlet weak var bigIconImageView: UIImageView!

//    private lazy var bigIconImageView: UIImageView = {
//        let imageView = UIImageView()
//    }()

    private lazy var logYourFeelingLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.logYourFeeling)
        label.font = SoliUFont.bold14
        label.textColor = SoliUColor.soliuBlack
        return label
    }()

    private lazy var badButton: SoliUButton = {
        let button = SoliUButton(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
        button.setImage(UIImage(emotionAssetIdentifier: .badIcon), for: .normal)
        button.tag = 0
        button.addTarget(self, action: #selector(emotionButtonTapped(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 46),
            button.heightAnchor.constraint(equalToConstant: 46)
        ])
        return button
    }()

    private lazy var sadButton: SoliUButton = {
        let button = SoliUButton(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
        button.setImage(UIImage(emotionAssetIdentifier: .sadIcon), for: .normal)
        button.tag = 1
        button.addTarget(self, action: #selector(emotionButtonTapped(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 46),
            button.heightAnchor.constraint(equalToConstant: 46)
        ])
        return button
    }()

    private lazy var decentButton: SoliUButton = {
        let button = SoliUButton(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
        button.setImage(UIImage(emotionAssetIdentifier: .decentIcon), for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(emotionButtonTapped(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 46),
            button.heightAnchor.constraint(equalToConstant: 46)
        ])
        return button
    }()

    private lazy var goodButton: SoliUButton = {
        let button = SoliUButton(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
        button.setImage(UIImage(emotionAssetIdentifier: .goodIcon), for: .normal)
        button.tag = 3
        button.addTarget(self, action: #selector(emotionButtonTapped(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 46),
            button.heightAnchor.constraint(equalToConstant: 46)
        ])
        return button
    }()

    private lazy var niceButton: SoliUButton = {
        let button = SoliUButton(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
        button.setImage(UIImage(emotionAssetIdentifier: .niceIcon), for: .normal)
        button.tag = 4
        button.addTarget(self, action: #selector(emotionButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var emotionButtons: [SoliUButton] = [
        badButton,
        sadButton,
        decentButton,
        goodButton,
        niceButton
    ]

    private lazy var emotionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: emotionButtons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        return stack
    }()

    var hasProgressBeenUpdated: Bool = false
    
    lazy var submitButton: SoliUButton = {
        let button = SoliUButton(frame: CGRect(x: 0, y: 0, width: 78, height: 24))
        button.setTitle(.localized(.submit), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = button.layer.frame.height / 2
        button.titleLabel?.font = SoliUFont.medium12
        button.backgroundColor = SoliUColor.submitButtonBackground
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()

    @objc private func emotionButtonTapped(_ sender: SoliUButton) {
        for button in emotionButtons {
            button.isSelected = false
        }
        sender.isSelected = true

        if !isUserFinishedAction() {
            switch sender {
            case badButton:
                badButton.setImage(UIImage(emotionAssetIdentifier: .badIconSelected), for: .selected)
                bigIconImageView.image = UIImage(emotionAssetIdentifier: .badIconBig)
                bigIconImageView.contentMode = .scaleAspectFill
                badButton.backgroundColor = .clear
                changeButtonState(button: badButton)
            case sadButton:
                sadButton.setImage(UIImage(emotionAssetIdentifier: .sadIconSelected), for: .selected)
                bigIconImageView.image = UIImage(emotionAssetIdentifier: .sadIconBig)
                changeButtonState(button: sadButton)
            case decentButton:
                decentButton.setImage(UIImage(emotionAssetIdentifier: .decentIconSelected), for: .selected)
                bigIconImageView.image = UIImage(emotionAssetIdentifier: .decentIconBig)
                changeButtonState(button: decentButton)
            case goodButton:
                goodButton.setImage(UIImage(emotionAssetIdentifier: .goodIconSelected), for: .selected)
                bigIconImageView.image = UIImage(emotionAssetIdentifier: .goodIconBig)
                changeButtonState(button: goodButton)
            case niceButton:
                niceButton.setImage(UIImage(emotionAssetIdentifier: .niceIconSelected), for: .selected)
                bigIconImageView.image = UIImage(emotionAssetIdentifier: .niceIconBig)
                changeButtonState(button: niceButton)
            default:
                return
            }
        }
    }

    private var dayArry: [SoliULabel: [UIView : SoliULabel]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = SoliUColor.homepageBackground
        setupUI()
        
        dayArry = [sundayDate: [sundayView: sundayLabel], mondayDate: [mondayView: mondayLabel], tuesdayDate: [tuesdayView: tuesdayLabel], wednesdayDate: [wednesdayView: wednesdayLabel], thursdayDate: [thursdayView: thursdayLabel], fridayDate: [fridayView: fridayLabel], saturdayDate: [saturdayView: saturdayLabel]]
        //set alpha to 0 hide all at very first time or  we can fetch data brom backend
        hideWithAlpha([sundayStar, mondayStar, tuesdayStar, wednesdayStar, thursdayStar, fridayStar, saturdayStar])
        makeCircleShape(welcomeView)
        
        applyBoader([sundayView, mondayView, tuesdayView, wednesdayView, thursdayView, fridayView, saturdayView], with: SoliUColor.homepageStroke, backgroundColor: .white)
        
        dateSettingForWeekday([sundayDate, mondayDate, tuesdayDate, wednesdayDate, thursdayDate, fridayDate, saturdayDate])
        setUpMyRecentMood()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setUpMyRecentMood()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyStyle(emotionStackView)
    }

    private func setupUI() {
        addAutoLayoutSubViews([bigIconImageView, logYourFeelingLabel, submitButton, emotionStackView])
        NSLayoutConstraint.activate([
            bigIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logYourFeelingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logYourFeelingLabel.topAnchor.constraint(equalTo: welcomeView.bottomAnchor, constant: SoliUSpacing.space40),

            emotionStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emotionStackView.topAnchor.constraint(equalTo: logYourFeelingLabel.bottomAnchor, constant: SoliUSpacing.space20),
            emotionStackView.heightAnchor.constraint(equalToConstant: SoliUSpacing.space72),
            emotionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space16),
            emotionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space16),
            
            submitButton.heightAnchor.constraint(equalToConstant: SoliUSpacing.space24),
            submitButton.widthAnchor.constraint(equalToConstant: 78),
            submitButton.trailingAnchor.constraint(equalTo: emotionStackView.trailingAnchor),
            submitButton.topAnchor.constraint(equalTo: emotionStackView.bottomAnchor, constant: 5)
        ])
        submitButton.isHidden = true
    }

    func setUpMyRecentMood() {
        let myDayList = WeekViewHelper.createfilteredMood()
        let todayDate = Calendar.current.startOfDay(for: Date())  // Get today's date at the start of day

            for myDay in myDayList {
                if let moodDate = myDay.parsedDate {
                    let startOfMoodDate = Calendar.current.startOfDay(for: moodDate)
                    let weekday = Calendar.current.component(.weekday, from: moodDate)
                    if startOfMoodDate == todayDate && !LoginManager.shared.getTempDetox().isEmpty {
                        // If moodDate is today and tempDetox is not empty, use tempDetox
                        updateRecentMood(for: weekday, mood: myDay.myMood, isDetoxed: LoginManager.shared.getTempDetox())
                    } else {
                        // Otherwise, use regular isDetoxed value
                        updateRecentMood(for: weekday, mood: myDay.myMood, isDetoxed: myDay.isDetoxed ?? "")
                    }
                }
            }
    }
    
    private func updateRecentMood(for weekday: Int, mood: MyMood, isDetoxed: String) {
        
        switch weekday {
        case 1:
            //sundayStar.alpha = 1
            sundayEmoji.image = mood.moodImage
            updateMoodBorderColor(for: sundayView, isDetoxed: isDetoxed)
        case 2:
            //mondayStar.alpha = 1
            mondayEmoji.image = mood.moodImage
            updateMoodBorderColor(for: mondayView, isDetoxed: isDetoxed)
        case 3:
            //tuesdayStar.alpha = 1
            tuesdayEmoji.image = mood.moodImage
            updateMoodBorderColor(for: tuesdayView, isDetoxed: isDetoxed)
        case 4:
            //wednesdayStar.alpha = 1
            wednesdayEmoji.image = mood.moodImage
            updateMoodBorderColor(for: wednesdayView, isDetoxed: isDetoxed)
        case 5:
            //thursdayStar.alpha = 1
            thursdayEmoji.image = mood.moodImage
            updateMoodBorderColor(for: thursdayView, isDetoxed: isDetoxed)
        case 6:
            //fridayStar.alpha = 1
            fridayEmoji.image = mood.moodImage
            updateMoodBorderColor(for: fridayView, isDetoxed: isDetoxed)
        case 7:
            //saturdayStar.alpha = 1
            saturdayEmoji.image = mood.moodImage
            updateMoodBorderColor(for: saturdayView, isDetoxed: isDetoxed)
        default :
            hideWithAlpha([sundayStar, mondayStar, tuesdayStar, wednesdayStar, thursdayStar, fridayStar, saturdayStar])
        }
    }
    
    func updateMoodBorderColor(for dayView: UIView, isDetoxed: String) {
        guard !isDetoxed.isEmpty else {
            return
        }
        
        var borderColor: UIColor = .clear
        if isDetoxed == "Yes" {
            borderColor = SoliUColor.yesButtonColor
        } else if isDetoxed == "No" {
            borderColor = SoliUColor.noButtonColor
        }
        applyBoader(dayView, with: borderColor, backgroundColor: .white)
    }

    func changeButtonState(button: SoliUButton) {
        badButton.isSelected = false
        sadButton.isSelected = false
        decentButton.isSelected = false
        goodButton.isSelected = false
        niceButton.isSelected = false
        button.isSelected = true
        welcomeView.isHidden = true
        submitButton.isHidden = false
    }
    
    private func submitMoodInformation(myMood: MyMood) {
        let myDay = MyDay(date: getDefaultDateFormat(), myMood: myMood, isDetoxed: "")
        //self.addProgressStar()
        FBNetworkLayer.shared.fetchMyDay(userInformation: LoginManager.shared.getUserInfo(),
                                         myDay: myDay) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            if !self.hasProgressBeenUpdated {
               //self.addProgressStar()
               self.hasProgressBeenUpdated = true  // Set the flag to true to prevent further updates
            }
        }
    }
    
    @objc
    func submitButtonTapped() {
        //send backend that user finished for today
        var selectedButton: SoliUButton?
        var mood: MyMood?
        for button in [badButton, sadButton, decentButton, goodButton, niceButton] {
            if button.isSelected == true {
                selectedButton = button
                switch button {
                case badButton:
                    mood = .bad
                case sadButton:
                    mood = .sad
                case decentButton:
                    mood = .decent
                case goodButton:
                    mood = .good
                case niceButton:
                    mood = .nice
                default:
                    break
                }
                break
            }
        }
    
        if let selectedMood = mood {
            submitMoodInformation(myMood: selectedMood)
        }
        guard let selectedButton = selectedButton else {
            return
        }
        let weekday = getTodayWeekday()
       
        switch weekday {
        case "Sunday":
            //sundayStar.alpha = 1
            sundayEmoji.image = iconEmojiMap(button: selectedButton)
            imageUpdatePublisher?.send(sundayEmoji.image.orEmptyImage)
        case "Monday":
            //mondayStar.alpha = 1
            mondayEmoji.image = iconEmojiMap(button: selectedButton)
            imageUpdatePublisher?.send(mondayEmoji.image.orEmptyImage)
        case "Tuesday":
            //tuesdayStar.alpha = 1
            tuesdayEmoji.image = iconEmojiMap(button: selectedButton)
            imageUpdatePublisher?.send(tuesdayEmoji.image.orEmptyImage)
        case "Wednesday":
            //wednesdayStar.alpha = 1
            wednesdayEmoji.image = iconEmojiMap(button: selectedButton)
            imageUpdatePublisher?.send(wednesdayEmoji.image.orEmptyImage)
        case "Thursday":
            //thursdayStar.alpha = 1
            thursdayEmoji.image = iconEmojiMap(button: selectedButton)
            imageUpdatePublisher?.send(thursdayEmoji.image.orEmptyImage)
        case "Friday":
            //fridayStar.alpha = 1
            fridayEmoji.image = iconEmojiMap(button: selectedButton)
            imageUpdatePublisher?.send(fridayEmoji.image.orEmptyImage)
        case "Saturday":
            //saturdayStar.alpha = 1
            saturdayEmoji.image = iconEmojiMap(button: selectedButton)
            imageUpdatePublisher?.send(saturdayEmoji.image.orEmptyImage)
        default :
            hideWithAlpha([sundayStar, mondayStar, tuesdayStar, wednesdayStar, thursdayStar, fridayStar, saturdayStar])
        }
    }
        
    func iconEmojiMap(button: SoliUButton?) -> UIImage? {
        guard let currentImage = button?.currentImage else { return nil }
        
        switch currentImage {
        case UIImage(emotionAssetIdentifier: .badIconSelected):
            return UIImage(emotionAssetIdentifier: .badIcon)
        case UIImage(emotionAssetIdentifier: .sadIconSelected):
            return UIImage(emotionAssetIdentifier: .sadIcon)
        case UIImage(emotionAssetIdentifier: .decentIconSelected):
            return UIImage(emotionAssetIdentifier: .decentIcon)
        case UIImage(emotionAssetIdentifier: .goodIconSelected):
            return UIImage(emotionAssetIdentifier: .goodIcon)
        case UIImage(emotionAssetIdentifier: .niceIconSelected):
            return UIImage(emotionAssetIdentifier: .niceIcon)
        default:
            return nil
        }
    }
    

    func isUserFinishedAction()  -> Bool {
        // need a function that if user already did for today or not
        // true -> if user already finished for today
        // false -> user didnt finish for today
        return false
    }

    func applyStyle(_ view: UIView) {
        view.layer.cornerRadius = view.layer.frame.height / 2
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

#if DEBUG
extension DayViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: DayViewController

        var imageUpdatePublisher: PassthroughSubject<UIImage, Never>? { target.imageUpdatePublisher }

        var currentDate: SoliULabel! { target.currentDate }

        var sundayView: UIView! { target.sundayView }

        var mondayView: UIView! { target.mondayView }

        var tuesdayView: UIView! { target.tuesdayView }

        var wednesdayView: UIView! { target.wednesdayView }

        var thursdayView: UIView! { target.thursdayView }

        var fridayView: UIView! { target.fridayView }

        var saturdayView: UIView! { target.saturdayView }

        var sundayStar: UIImageView! { target.sundayStar }

        var mondayStar: UIImageView! { target.mondayStar }

        var tuesdayStar: UIImageView! { target.tuesdayStar }

        var wednesdayStar: UIImageView! { target.wednesdayStar }

        var thursdayStar: UIImageView! { target.thursdayStar }

        var fridayStar: UIImageView! { target.fridayStar }

        var saturdayStar: UIImageView! { target.saturdayStar }

        var sundayDate: SoliULabel! { target.sundayDate }

        var mondayDate: SoliULabel! { target.mondayDate }

        var tuesdayDate: SoliULabel! { target.tuesdayDate }

        var wednesdayDate: SoliULabel! { target.wednesdayDate }

        var thursdayDate: SoliULabel! { target.thursdayDate }

        var fridayDate: SoliULabel! { target.fridayDate }

        var saturdayDate: SoliULabel! { target.saturdayDate }

        var sundayLabel: SoliULabel! { target.sundayLabel }

        var mondayLabel: SoliULabel! { target.mondayLabel }

        var tuesdayLabel: SoliULabel! { target.tuesdayLabel }

        var wednesdayLabel: SoliULabel! { target.wednesdayLabel }

        var thursdayLabel: SoliULabel! { target.thursdayLabel }

        var fridayLabel: SoliULabel! { target.fridayLabel }

        var saturdayLabel: SoliULabel! { target.saturdayLabel }

        var sundayEmoji: UIImageView! { target.sundayEmoji }

        var mondayEmoji: UIImageView! { target.mondayEmoji }

        var tuesdayEmoji: UIImageView! { target.tuesdayEmoji }

        var wednesdayEmoji: UIImageView! { target.wednesdayEmoji }

        var thursdayEmoji: UIImageView! { target.thursdayEmoji }

        var fridayEmoji: UIImageView! { target.fridayEmoji }

        var saturdayEmoji: UIImageView! { target.saturdayEmoji }

        var welcomeView: UIView! { target.welcomeView }

        var nameLabel: SoliULabel! { target.nameLabel }

        var subLabel: SoliULabel! { target.subLabel }

        var logYourFeelingLabel: SoliULabel! { target.logYourFeelingLabel }

        var bigIconImageView: UIImageView! { target.bigIconImageView }

        var badButton: SoliUButton { target.badButton }

        var sadButton: SoliUButton { target.sadButton }

        var decentButton: SoliUButton { target.decentButton }

        var goodButton: SoliUButton { target.goodButton }

        var niceButton: SoliUButton { target.niceButton }

        var hasProgressBeenUpdated: Bool { target.hasProgressBeenUpdated }

        var submitButton: SoliUButton { target.submitButton }

        func setUpMyRecentMood() { target.setUpMyRecentMood() }

        func updateMoodBorderColor(for dayView: UIView, isDetoxed: String) {
            target.updateMoodBorderColor(for: dayView, isDetoxed: isDetoxed)
        }

        func changeButtonState(button: SoliUButton) {
            target.changeButtonState(button: button)
        }

        func iconEmojiMap(button: SoliUButton?) -> UIImage? {
            target.iconEmojiMap(button: button)
        }

        func isUserFinishedAction() -> Bool { target.isUserFinishedAction() }

        func applyStyle(_ view: UIView) {
            target.applyStyle(view)
        }
    }
}
#endif
