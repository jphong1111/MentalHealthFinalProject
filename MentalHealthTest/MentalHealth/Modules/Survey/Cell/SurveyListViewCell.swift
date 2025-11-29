//
//  SurveyListCell.swift
//  MentalHealth
//
//  Created by Yoon on 3/31/24.
//

import Foundation
import UIKit

final class SurveyListViewCell: UITableViewCell, CellReusable {
    
    @IBOutlet var surveyQuestionLabel: SoliULabel! {
        didSet {
            surveyQuestionLabel.font = SoliUFont.bold16
        }
    }
    
    @IBOutlet var surveyAnswerLabel1: SoliULabel! {
        didSet{
            surveyAnswerLabel1.font = SoliUFont.regular10
        }
    }
    @IBOutlet var surveyAnswerLabel2: SoliULabel! {
        didSet{
            surveyAnswerLabel2.font = SoliUFont.regular10
        }
    }
    @IBOutlet var surveyAnswerLabel3: SoliULabel! {
        didSet{
            surveyAnswerLabel3.font = SoliUFont.regular10
        }
    }
    @IBOutlet var surveyAnswerLabel4: SoliULabel! {
        didSet{
            surveyAnswerLabel4.font = SoliUFont.regular10
        }
    }
    @IBOutlet var surveyAnswerLabel5: SoliULabel! {
        didSet{
            surveyAnswerLabel5.font = SoliUFont.regular10
        }
    }
    
    @IBOutlet var surveyAnswerImage1: UIImageView!
    @IBOutlet var surveyAnswerImage2: UIImageView!
    @IBOutlet var surveyAnswerImage3: UIImageView!
    @IBOutlet var surveyAnswerImage4: UIImageView!
    @IBOutlet var surveyAnswerImage5: UIImageView!
    
    
    private var imageMappings: [UIImageView: (unmarked: UIImage?, marked: UIImage?)] = [:]
    private var testQuestion: TestQuestion?
    private var selectedValue: Int?
    weak var delegate: SurveyListViewCellDelegate?
    
    
    func populate(testQuestion: TestQuestion) {
        self.testQuestion = testQuestion
        surveyQuestionLabel.text = testQuestion.question
        setupSureyAnswer(testQuestion.questionNumber)
    }
    
    private func setupSureyAnswer(_ testquestionNumber: Int) {
        switch testquestionNumber {
        case 25:
            surveyAnswerLabel1.text = .localized(.poor)
            surveyAnswerLabel2.text = .localized(.fair)
            surveyAnswerLabel3.text = .localized(.good)
            surveyAnswerLabel4.text = .localized(.veryGood)
            surveyAnswerLabel5.text = .localized(.excellent)
        case 26...29:
            surveyAnswerLabel1.text = .localized(.veryFrequentlyDays)
            surveyAnswerLabel2.text = .localized(.frequentlyDays)
            surveyAnswerLabel3.text = .localized(.occasionallyDays)
            surveyAnswerLabel4.text = .localized(.rarelyDays)
            surveyAnswerLabel5.text = .localized(.neverDays)
        default:
            surveyAnswerLabel1.text = .localized(.veryOften)
            surveyAnswerLabel2.text = .localized(.often)
            surveyAnswerLabel3.text = .localized(.sometimes)
            surveyAnswerLabel4.text = .localized(.rarely)
            surveyAnswerLabel5.text = .localized(.veryRarely)
        }
    }

    private func setupImageMappings() {
        imageMappings[surveyAnswerImage1] = (UIImage(assetIdentifier: .unmarkedVRare), UIImage(assetIdentifier: .markedVRare))
        imageMappings[surveyAnswerImage2] = (UIImage(assetIdentifier: .unmarkedRare), UIImage(assetIdentifier: .markedRare))
        imageMappings[surveyAnswerImage3] = (UIImage(assetIdentifier: .unmarkedSometimes), UIImage(assetIdentifier: .markedSometimes))
        imageMappings[surveyAnswerImage4] = (UIImage(assetIdentifier: .unmarkedOften), UIImage(assetIdentifier: .markedOften))
        imageMappings[surveyAnswerImage5] = (UIImage(assetIdentifier: .unmarkedVOften), UIImage(assetIdentifier: .markedVOften))
    }
    
    private var surveyImageView: [UIImageView] {
            return [surveyAnswerImage1, surveyAnswerImage2, surveyAnswerImage3, surveyAnswerImage4, surveyAnswerImage5]
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupGestureRecognizers()
        initialImageSetup()
        setupImageMappings()
    }
    
    private func initialImageSetup() {
        surveyAnswerImage1.image = UIImage(assetIdentifier:.unmarkedVRare)
        surveyAnswerImage2.image = UIImage(assetIdentifier:.unmarkedRare)
        surveyAnswerImage3.image = UIImage(assetIdentifier:.unmarkedSometimes)
        surveyAnswerImage4.image = UIImage(assetIdentifier:.unmarkedOften)
        surveyAnswerImage5.image = UIImage(assetIdentifier:.unmarkedVOften)
    }
    
    func resetImagesToUnmarked(row: Int) {
        surveyImageView.forEach { imageView in
            if let unmarkedImage = imageMappings[imageView]?.unmarked {
                imageView.image = unmarkedImage
            }
        }
    }
    
    private func setupGestureRecognizers() {
        surveyImageView.forEach { imageView in
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let selectedImageView = sender.view as? UIImageView else { return }
        guard let testQuestion = testQuestion else { return }
        if let selectedIndex = surveyImageView.firstIndex(of: selectedImageView) {
                selectedValue = selectedIndex
                delegate?.mappingSelectedValue(id: testQuestion.id,
                                               questionNumber: testQuestion.questionNumber,
                                               value: 6 - (selectedIndex + 1))
                resetImages(except: selectedImageView)
           }
    }
    
    private func resetImages(except selectedImageView: UIImageView) {
        surveyImageView.forEach { imageView in
            if imageView == selectedImageView {
                if let markedImage = imageMappings[imageView]?.marked {
                    imageView.image = markedImage
                }
            } else {
                if let unmarkedImage = imageMappings[imageView]?.unmarked {
                    imageView.image = unmarkedImage
                }
            }
        }
    }
}

protocol SurveyListViewCellDelegate: AnyObject {
    func mappingSelectedValue(id: Int, questionNumber: Int , value: Int)
}

#if DEBUG
extension SurveyListViewCell {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: SurveyListViewCell

        var surveyQuestionLabel: SoliULabel! { target.surveyQuestionLabel }

        var surveyAnswerLabel1: SoliULabel! { target.surveyAnswerLabel1 }

        var surveyAnswerLabel2: SoliULabel! { target.surveyAnswerLabel2 }

        var surveyAnswerLabel3: SoliULabel! { target.surveyAnswerLabel3 }

        var surveyAnswerLabel4: SoliULabel! { target.surveyAnswerLabel4 }

        var surveyAnswerLabel5: SoliULabel! { target.surveyAnswerLabel5 }

        var surveyAnswerImage1: UIImageView! { target.surveyAnswerImage1 }

        var surveyAnswerImage2: UIImageView! { target.surveyAnswerImage2 }

        var surveyAnswerImage3: UIImageView! { target.surveyAnswerImage3 }

        var surveyAnswerImage4: UIImageView! { target.surveyAnswerImage4 }

        var surveyAnswerImage5: UIImageView! { target.surveyAnswerImage5 }

        var imageMappings: [UIImageView: (unmarked: UIImage?, marked: UIImage?)] { target.imageMappings }

        var testQuestion: TestQuestion? { target.testQuestion }

        var selectedValue: Int? { target.selectedValue }

        func populate(testQuestion: TestQuestion) {
            target.populate(testQuestion: testQuestion)
        }

        func resetImagesToUnmarked(row: Int) {
            target.resetImagesToUnmarked(row: row)
        }
    }
}
#endif