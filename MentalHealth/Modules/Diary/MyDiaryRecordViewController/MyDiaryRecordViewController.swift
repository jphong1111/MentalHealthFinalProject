//
//  MyDiaryRecordViewController.swift
//  MentalHealth
//
//  Created by Yoon on 5/11/24.
//

import UIKit

final class MyDiaryRecordViewController: BaseViewController {
    @IBOutlet weak var quesitonTitleLabel: SoliULabel!
    @IBOutlet weak var subtitleLabel: SoliULabel!
    @IBOutlet weak var niceView: UIView!
    @IBOutlet weak var badView: UIView!
    @IBOutlet weak var niceLabel: SoliULabel!
    @IBOutlet weak var badLabel: SoliULabel!
    
    var selected = 0

    private lazy var submitButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.startRecording), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = SoliUColor.tabBarBorder
        button.titleLabel?.font = SoliUFont.bold14
        button.layer.cornerRadius = SoliUSpacing.space16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitalUI()
        niceView.tag = 0
        badView.tag = 1
        tapAction(niceView, selector: #selector(selectMyMood))
        tapAction(badView, selector: #selector(selectMyMood))
        self.title = getCurrentMonthAndDate()
        setCustomBackNavigationButton()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        submitButton.layer.cornerRadius = submitButton.bounds.height / 2
    }

    func setupView() {
        submitButton.isEnabled = false
        addAutoLayoutSubView(submitButton)
        submitButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
    }
    
    func setupInitalUI() {
        niceLabel.font = SoliUFont.bold24
        niceLabel.text = .localized(.counselorGood)
        niceLabel.textColor = SoliUColor.newSoliuBlue
        
        badLabel.font = SoliUFont.bold24
        badLabel.text = .localized(.counselorBad)
        badLabel.textColor = .red
        
        quesitonTitleLabel.text = .localized(.counselorQuestionLabel)
        subtitleLabel.text = .localized(.counselorQuestionSubLabel)

        niceView.addBorderAndColor(color: SoliUColor.tabBarBorder, width: 1, corner_radius: SoliUSpacing.space16)
        badView.addBorderAndColor(color: SoliUColor.tabBarBorder, width: 1, corner_radius: SoliUSpacing.space16)
    }
    
    @objc func nextButtonPressed() {
        navigate(to: MyDiaryTextViewController.self, storyboardName: "MyDiaryFlow") { myDiaryTextViewController in
            myDiaryTextViewController.selectedMood = MyDiaryMood(tag: self.selected)
        }
    }
    
    @objc func selectMyMood(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            print("Tagging Error")
            return
        }
        
        submitButton.isEnabled = true
        submitButton.setTitleColor(.black, for: .normal)

        switch view.tag {
        case 0:
            selected = 0
            niceView.addBorderAndColor(color: SoliUColor.newSoliuBlue, width: 1, corner_radius: SoliUSpacing.space16)
            badView.addBorderAndColor(color: SoliUColor.tabBarBorder, width: 1, corner_radius: SoliUSpacing.space16)
            submitButton.backgroundColor = SoliUColor.diarySubmitButton

        case 1:
            selected = 1
            niceView.addBorderAndColor(color: SoliUColor.tabBarBorder, width: 1, corner_radius: SoliUSpacing.space16)
            badView.addBorderAndColor(color: .red, width: 1, corner_radius: SoliUSpacing.space16)
            submitButton.backgroundColor = SoliUColor.diarySubmitButton

        default:
            print("Unknown view selected")
        }
        
        // Force immediate UI update
        self.view.layoutIfNeeded()
    }
}

#if DEBUG
extension MyDiaryRecordViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: MyDiaryRecordViewController

        var quesitonTitleLabel: SoliULabel! { target.quesitonTitleLabel }

        var subtitleLabel: SoliULabel! { target.subtitleLabel }

        var niceView: UIView! { target.niceView }

        var badView: UIView! { target.badView }

        var niceLabel: SoliULabel! { target.niceLabel }

        var badLabel: SoliULabel! { target.badLabel }

        var submitButton: SoliUButton { target.submitButton }

        func setupView() { target.setupView() }

        func setupInitalUI() { target.setupInitalUI() }
    }
}
#endif
