//
//  MyDiaryTextViewController.swift
//  MentalHealth
//
//  Created by Yoon on 5/14/24.
//

import UIKit

final class MyDiaryTextViewController: BaseViewController {
    var adviceItem: AdviceItem?
    var selectedMood: MyDiaryMood = .good
    
    private lazy var getAdviceButton: SoliUButton = {
        var button = SoliUButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = SoliUFont.bold16
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = SoliUColor.diarySubmitButton
        button.layer.cornerRadius = SoliUSpacing.space16
        button.setTitle(.localized(.getAdvice), for: .normal)
        button.addTarget(self, action: #selector(getAdviceButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: SoliUButton = {
        var button = SoliUButton()
        button.setTitle(.localized(.save), for: .normal)
        button.titleLabel?.font = SoliUFont.bold16
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = SoliUColor.diarySubmitButton
        button.layer.cornerRadius = SoliUSpacing.space16
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = getCurrentMonthAndDate()
        self.setupUI()
        
        if let adviceItem = adviceItem {
            self.addSubViewWithItem(adviceItem: adviceItem)
        }
        else {
            self.addSubViewForInput()
        }
        
    }
    
    private func setupUI() {
        if let adviceItem = adviceItem {
            if adviceItem.myDiaryMood == .good {
                self.setCustomBackNavigationButtonWithRightImage(rightImage: UIImage(emotionAssetIdentifier: .smallDiaryHappy),
                                                                 rightSelector: nil)
            } else {
                self.setCustomBackNavigationButtonWithRightImage(rightImage: UIImage(emotionAssetIdentifier: .smallDiraySad),
                                                                 rightSelector: nil)
            }
        } else {
            self.setCustomBackNavigationButton()
        }
    }
    
    private func addSubViewWithItem(adviceItem: AdviceItem) {
        
        if adviceItem.myDiaryMood == .bad {
            
            
            let question1View = createQuestionSection(
                question: .localized(.savedAdviceTitleBad),
                placeholder: adviceItem.userConcernInput,
                tag: 1,
                fromInput: false,
                canEditable: false
            )
            
            let question2View = createQuestionSection(
                question: .localized(.savedAdviceRecordBad),
                placeholder: adviceItem.aiGeneratedAdvice,
                tag: 2,
                fromInput: false,
                canEditable: false
            )
            
            view.addSubview(question1View)
            view.addSubview(question2View)
            
            NSLayoutConstraint.activate([
                // Question 1
                question1View.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                question1View.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                question1View.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                question1View.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),
                
                // Question 2 (should expand more)
                question2View.leadingAnchor.constraint(equalTo: question1View.leadingAnchor),
                question2View.trailingAnchor.constraint(equalTo: question1View.trailingAnchor),
                question2View.topAnchor.constraint(equalTo: question1View.bottomAnchor, constant: 20),
                question2View.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                question2View.heightAnchor.constraint(greaterThanOrEqualTo: question1View.heightAnchor, multiplier: 1.5)
            ])
        } else {
            
            let question1View = createQuestionSection(
                question: .localized(.savedAdviceTitleGood),
                placeholder: adviceItem.userConcernInput,
                tag: 1,
                fromInput: false,
                canEditable: false
            )
            
            view.addSubview(question1View)
            
            NSLayoutConstraint.activate([
                question1View.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                question1View.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                question1View.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                question1View.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20), // Ensures it expands to the bottom
                question1View.heightAnchor.constraint(greaterThanOrEqualToConstant: 225) // Allows for flexibility
            ])
            
        }
    }
    
    func scrollToTop(of textView: UITextView) {
        let topOffset = CGPoint(x: 0, y: -textView.contentInset.top)
        textView.setContentOffset(topOffset, animated: true)
    }
    
    private func addSubViewForInput() {
        if selectedMood == .bad {
            let question1View = createQuestionSection(
                question: .localized(.counselorAdviceTitleBad),
                placeholder: .localized(.seekerRecordExampleBad),
                tag: 1
            )
            
            let question2View = createQuestionSection(
                question: .localized(.generatedAnswer),
                placeholder: "",
                tag: 2,
                canEditable: false
            )
            
            view.addSubView([question1View, getAdviceButton, question2View, saveButton])
            
            // Apply constraints for the sections
            NSLayoutConstraint.activate([
                // Question 1
                question1View.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                question1View.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                question1View.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                question1View.heightAnchor.constraint(equalToConstant: 225),
                
                // Submit Button
                getAdviceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                getAdviceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                getAdviceButton.topAnchor.constraint(equalTo: question1View.bottomAnchor, constant: 20),
                getAdviceButton.heightAnchor.constraint(equalToConstant: 50),
                
                
                // Question 2
                question2View.leadingAnchor.constraint(equalTo: question1View.leadingAnchor),
                question2View.trailingAnchor.constraint(equalTo: question1View.trailingAnchor),
                question2View.topAnchor.constraint(equalTo: getAdviceButton.bottomAnchor, constant: 20),
                question2View.heightAnchor.constraint(equalToConstant: 225),
                
                // Save Button
                saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                saveButton.topAnchor.constraint(equalTo: question2View.bottomAnchor, constant: 20),
                saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                saveButton.heightAnchor.constraint(equalToConstant: 50),
            ])
        } else {
            let question1View = createQuestionSection(
                question: .localized(.counselorAdviceTitleGood),
                placeholder: .localized(.seekerRecordExampleGood),
                tag: 1
            )
            
            [question1View, saveButton].forEach {
                        $0.translatesAutoresizingMaskIntoConstraints = false
                        view.addSubview($0)
            }
            
            view.addSubview(question1View)
            view.addSubview(saveButton)
            
            NSLayoutConstraint.activate([
                question1View.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                question1View.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                question1View.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                question1View.heightAnchor.constraint(equalToConstant: 225),
                
                saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                saveButton.topAnchor.constraint(equalTo: question1View.bottomAnchor, constant: 20),
                saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                saveButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    
    private func createQuestionSection(question: String, placeholder: String, tag: Int, fromInput: Bool = true, canEditable: Bool = true) -> UIView {
        // Create a container view with a border
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1.0 // Add border
        containerView.layer.borderColor = SoliUColor.tabBarBorder.cgColor // Border color
        containerView.backgroundColor = UIColor.white
        
        // Create question label
        let questionLabel = SoliULabel()
        questionLabel.text = question
        questionLabel.font = SoliUFont.bold16
        questionLabel.numberOfLines = 0 // Allow unlimited lines
        questionLabel.textAlignment = .left
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.systemGray4
        
        // Create text field
        let textView = UITextView()
        textView.backgroundColor = UIColor.white
        textView.font = SoliUFont.regular14
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 0
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.text = placeholder
        textView.textColor = UIColor.lightGray
        
        if !fromInput {
            textView.textColor = .black
        }
        
        textView.isEditable = canEditable
        textView.tag = tag
        
        scrollToTop(of: textView)
        
        textView.delegate = self
        
        containerView.addSubView([questionLabel, separatorView, textView])
        
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            questionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        return containerView
    }
    
    @objc private func submitButtonTapped() {
        guard let userInputView = view.viewWithTag(1) as? UITextView else { return }
        
        var aiAdvice: String = "" // Default to empty string if no AI-generated advice
        
        if selectedMood == .bad {
            guard let adviceView = view.viewWithTag(2) as? UITextView else { return }
            aiAdvice = adviceView.text // Assign AI-generated advice if available
        }
        
        let adviceItem = AdviceItem(
            date: getDefaultDateFormat(),
            myDiaryMood: selectedMood,
            userConcernInput: userInputView.text,
            aiGeneratedAdvice: aiAdvice, // Handles empty string case properly
            userFeedback: "None"
        )
        
        if LoginManager.shared.isLoggedIn() {
            FBNetworkLayer.shared.saveAdvice(adviceItem: adviceItem) { err in
                DispatchQueue.main.async {
                    if err != nil {
                        self.showAlertWithButton(title: .localized(.networkErrorTitle), message: .localized(.adviceSaveErrorMessage))
                        return
                    }
                    self.showSuccessSaveAdvice(adviceItem)
                }
            }
        } else {
            showLoginRequiredAlert(adviceItem)
        }
    }
    
    private func handleAdviceSaveSuccess(_ adviceItem: AdviceItem) {
        if let navigationController = self.navigationController {
            for viewController in navigationController.viewControllers {
                if let myDiaryVC = viewController as? MyDiaryViewController {
                    myDiaryVC.appendToDataSource(newItem: adviceItem)
                    navigationController.popToViewController(myDiaryVC, animated: true)
                    return
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showSuccessSaveAdvice(_ adviceItem: AdviceItem) {
        let alertController = UIAlertController(title: .localized(.success),
                                                message: .localized(.adviceSaveSuccessMessage),
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: .localized(.ok), style: .default) { [weak self] _ in
            self?.handleAdviceSaveSuccess(adviceItem)
            self?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func showLoginRequiredAlert(_ adviceItem: AdviceItem) {
        let loginAlert = UIAlertController(
            title: .localized(.loginRequiredTitle),
            message: .localized(.loginRequiredMessage),
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: .localized(.ok), style: .cancel) { [weak self] _ in
            self?.handleAdviceSaveSuccess(adviceItem) // Ensure it appears in MyDiaryViewController
            
        }
        loginAlert.addAction(okAction)
        present(loginAlert, animated: true, completion: nil)
    }
    
    
    
    @objc private func getAdviceButtonTapped() {
        
        guard let userInputView = view.viewWithTag(1) as? UITextView else { return }
        guard let adviceView = view.viewWithTag(2) as? UITextView else { return }
        
        let userConcernInput = userInputView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !userConcernInput.isEmpty && userConcernInput != .localized(.seekerRecordExampleBad) else {
            adviceView.text = .localized(.adviceEmptyLabel)
            adviceView.textColor = UIColor.red
            return
        }
        
        animateLoadingDots(for: adviceView, baseText: .localized(.generatingAnswer))
        adviceView.textColor = UIColor.gray
        
        FBNetworkLayer.shared.getAdvice(userConcernInput: userConcernInput) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let advice):
                    self?.stopLoadingDotsAnimation()
                    adviceView.text = advice
                    adviceView.textColor = UIColor.black
                case .failure(_):
                    adviceView.text = .localized(.adviceGenerationFailedText)
                    adviceView.textColor = UIColor.red
                }
            }
        }
    }

    private var loadingDotsTimer: Timer?
    
    private func animateLoadingDots(for textView: UITextView, baseText: String) {
        var dotCount = 0
        loadingDotsTimer?.invalidate() // Ensure previous animation is stopped
        
        loadingDotsTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            dotCount = (dotCount + 1) % 4 // Cycle through 0, 1, 2, 3
            let dots = String(repeating: ".", count: dotCount) // "", ".", "..", "..."
            textView.text = "\(baseText) \(dots)"
        }
    }
    
    private func stopLoadingDotsAnimation() {
        loadingDotsTimer?.invalidate()
        loadingDotsTimer = nil
    }
}

extension MyDiaryTextViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.tag == 1 && textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 1 && textView.text.isEmpty {
            // Placeholder behavior for user input
            textView.text = .localized(.seekerRecordExampleBad)
            textView.textColor = UIColor.lightGray
        } else if textView.tag == 2 {
            // Advice text view logic (if needed)
            textView.isEditable = false // Prevent editing for advice section
        }
    }
}

#if DEBUG
extension MyDiaryTextViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: MyDiaryTextViewController

        var adviceItem: AdviceItem? { target.adviceItem }

        var selectedMood: MyDiaryMood { target.selectedMood }

        var getAdviceButton: SoliUButton { target.getAdviceButton }

        var saveButton: SoliUButton { target.saveButton }

        func scrollToTop(of textView: UITextView) {
            target.scrollToTop(of: textView)
        }
    }
}
#endif
