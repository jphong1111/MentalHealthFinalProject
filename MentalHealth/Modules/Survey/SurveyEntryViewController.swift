//
//  SurveyEntryViewController.swift
//  MentalHealth
//
//  Created by Yoon on 5/7/24.
//

import UIKit

final class SurveyEntryViewController: BaseViewController {
    private lazy var surveyEntryTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.beforeWeStart)
        label.textColor = SoliUColor.soliuBlack
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = SoliUFont.black32
        return label
    }()
    
    private lazy var citationInfoLabel: UIButton = {
        let button = UIButton(type: .system)
        let title = NSAttributedString(
            string: "View source information",
            attributes: [
                .font: SoliUFont.medium12,
                .foregroundColor: UIColor.systemGray,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        button.setAttributedTitle(title, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(showCitation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    private lazy var surveyEntrySubTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.testComposedOf)
        label.textColor = SoliUColor.soliuBlack
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = SoliUFont.black14
        return label
    }()

    private lazy var surveyEntryComposeLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.testSections)
        label.textColor = SoliUColor.soliuBlack
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = SoliUFont.bold14
        return label
    }()
    
    private lazy var testStartTitleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.testStartProceeding)
        label.textColor = SoliUColor.soliuBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = SoliUFont.medium12
        return label
    }()
    
    private lazy var startButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.start), for: .normal)
        button.titleLabel?.font = SoliUFont.bold14
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = SoliUColor.newSoliuBlue
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var seeMyScoreButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.seeMyResult), for: .normal)
        button.titleLabel?.font = SoliUFont.bold14
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = SoliUColor.newSoliuBlue
        button.addTarget(self, action: #selector(seeMyResultButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var mostRecentTestScore: [Int: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setCustomBackNavigationButton()
        if !hasTakenTestsBefore() {
            seeMyScoreButton.isHidden = true
        } else {
            seeMyScoreButton.isHidden = false
        }
    }
    
    @objc func showCitation() {
        let citationVC = UIViewController()
        citationVC.view.backgroundColor = .systemBackground

        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = [.link]
        textView.attributedText = .medicalReferenceCitationText()
        textView.font = UIFont.systemFont(ofSize: 14)

        citationVC.view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: citationVC.view.topAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: citationVC.view.bottomAnchor, constant: -16),
            textView.leadingAnchor.constraint(equalTo: citationVC.view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: citationVC.view.trailingAnchor, constant: -16)
        ])

        // Present as modal
        let nav = UINavigationController(rootViewController: citationVC)
        citationVC.title = .localized(.medicalReference)
        citationVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissCitation))

        present(nav, animated: true)
    }

    @objc func dismissCitation() {
        dismiss(animated: true)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startButton.layer.cornerRadius = startButton.bounds.height / 2
        seeMyScoreButton.layer.cornerRadius = seeMyScoreButton.bounds.height / 2
        seeMyScoreButton.backgroundColor = SoliUColor.soliuBlack
    }

    private func hasTakenTestsBefore() -> Bool {
        if LoginManager.shared.getSurveyResult().isEmpty || !LoginManager.shared.isLoggedIn() {
            return false
        }
        return true
    }
    
    private func setupMyRecentTestScore() {
        if let recentScore = LoginManager.shared.getMostRecentTestScore() {
            self.mostRecentTestScore = recentScore.surveyAnswer
                .enumerated().reduce(into: [:])
                { dict, pair in
                        dict[pair.offset] = pair.element
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupMyRecentTestScore()
    }
    
    private func setupView() {
        addAutoLayoutSubViews([surveyEntryTitleLabel, surveyEntrySubTitleLabel, surveyEntryComposeLabel, citationInfoLabel ,testStartTitleLabel, startButton, seeMyScoreButton])
        
        NSLayoutConstraint.activate([
            surveyEntryTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            surveyEntryTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            surveyEntryTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            
            surveyEntrySubTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            surveyEntrySubTitleLabel.topAnchor.constraint(equalTo: surveyEntryTitleLabel.bottomAnchor, constant: 45),
            
            surveyEntryComposeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            surveyEntryComposeLabel.topAnchor.constraint(equalTo: surveyEntrySubTitleLabel.bottomAnchor, constant: 10),
            citationInfoLabel.leadingAnchor.constraint(equalTo: surveyEntryTitleLabel.leadingAnchor),
            citationInfoLabel.topAnchor.constraint(equalTo: surveyEntryComposeLabel.bottomAnchor, constant: 6),

            testStartTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testStartTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            testStartTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
       
            startButton.topAnchor.constraint(equalTo: testStartTitleLabel.bottomAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            startButton.heightAnchor.constraint(equalToConstant: 40),

            seeMyScoreButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 15),
            seeMyScoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            seeMyScoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            seeMyScoreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            seeMyScoreButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func seeMyResultButtonTapped() {
        navigate(to: SurveyResultViewController.self) { surveyResultViewController in
            surveyResultViewController.myTestScore = self.mostRecentTestScore
        }
    }
    
    @objc private func startButtonTapped() {
        navigate(to: SurveyListViewController.self)
    }
}

#if DEBUG
extension SurveyEntryViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: SurveyEntryViewController

        var surveyEntryTitleLabel: SoliULabel { target.surveyEntryTitleLabel }

        var citationInfoLabel: UIButton { target.citationInfoLabel }

        var surveyEntrySubTitleLabel: SoliULabel { target.surveyEntrySubTitleLabel }

        var surveyEntryComposeLabel: SoliULabel { target.surveyEntryComposeLabel }

        var testStartTitleLabel: SoliULabel { target.testStartTitleLabel }

        var startButton: SoliUButton { target.startButton }

        var seeMyScoreButton: SoliUButton { target.seeMyScoreButton }

        var mostRecentTestScore: [Int: Int] { target.mostRecentTestScore }

    }
}
#endif
