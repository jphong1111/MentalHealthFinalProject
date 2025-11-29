//
//  FeedbackViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 8/23/24.
//

import Foundation
import UIKit

final class FeedbackViewController: BaseViewController {
    private lazy var feedbacktitle: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.feedbackTitle)
        label.font = SoliUFont.medium16
        label.textColor = SoliUColor.soliuBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var feedbackTextView: UITextView = {
        let textView = UITextView()
        textView.font = SoliUFont.medium16
        textView.textColor = .lightGray
        textView.layer.borderWidth = 0
        textView.text = .localized(.feedbackSubTitle)
        textView.backgroundColor = SoliUColor.homepageBackground
        return textView
    }()
    
    private lazy var submitButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.submit), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = button.layer.frame.height / 2
        button.titleLabel?.font = SoliUFont.medium12
        button.backgroundColor = SoliUColor.soliuBlack
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SoliUColor.homepageBackground
        setCustomBackNavigationButton()
        addAutoLayoutSubViews([feedbacktitle, feedbackTextView, submitButton])
        setupConstraints()
        setNavigationTitle(title: .localized(.feedback))
        feedbackTextView.delegate = self
        feedbackTextView.addBorderAndColor(color: SoliUColor.tabBarBorder, width: 1, corner_radius: SoliUSpacing.space8)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        submitButton.layer.cornerRadius = submitButton.layer.frame.height / 2
    }
    
    private func setupConstraints() {
            NSLayoutConstraint.activate([
                feedbacktitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                feedbacktitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                feedbacktitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                
                feedbackTextView.topAnchor.constraint(equalTo: feedbacktitle.bottomAnchor, constant: 10),
                feedbackTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                feedbackTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                feedbackTextView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7),
                
                
                submitButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 20),
                submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                submitButton.heightAnchor.constraint(equalToConstant: 31),
                submitButton.widthAnchor.constraint(equalToConstant: 87)
            ])
        }
    
    @objc private func submitButtonTapped() {
        let feedback = feedbackTextView.text ?? ""
        FBNetworkLayer.shared.add_feedback(feedback: feedback) { error in
            DispatchQueue.main.async {
                if error != nil {
                    self.showAlert(title: "Submission Failed",
                                   description: "Your feedback could not be submitted at this time. Please try again later")
                } else {
                    self.showAlert(title: "Thank You!",
                                   description: "Your feedback has been successfully submitted. We appreciate your input!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension FeedbackViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray && textView.text == "Write your response here." {
            textView.text = ""
            textView.textColor = .black // Change text color to black when user starts typing
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your response here."
            textView.textColor = .lightGray // Revert text color to placeholder color if text is empty
        }
    }
}

#if DEBUG
extension FeedbackViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: FeedbackViewController

        var feedbacktitle: SoliULabel { target.feedbacktitle }

        var feedbackTextView: UITextView { target.feedbackTextView }

        var submitButton: SoliUButton { target.submitButton }

        func setupConstraints() { target.setupConstraints() }

        func submitButtonTapped() { target.submitButtonTapped() }
    }
}
#endif
