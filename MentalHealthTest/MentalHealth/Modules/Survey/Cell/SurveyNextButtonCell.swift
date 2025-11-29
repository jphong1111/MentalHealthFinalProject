//
//  SurveyListNextViewCell.swift
//  MentalHealth
//
//  Created by Yoon on 3/31/24.
//

import Foundation
import UIKit

final class SurveyNextButtonCell: UITableViewCell, CellReusable {
    @IBOutlet var nextButton: SoliUButton! {
        didSet {
            nextButton.layer.cornerRadius = 12
            nextButton.titleLabel?.font = SoliUFont.bold16
            nextButton.titleLabel?.textColor = .white
        }
    }
    
    weak var delegate: SurveyNextButtonCellDelegate?
    
    func populate(readySubmit: Bool, isActive: Bool) {
        nextButton.isEnabled = isActive
        nextButton.alpha = isActive ? 1.0 : 0.5 // Change appearance to show active/inactive state
        nextButton.setTitle(readySubmit ? .localized(.submit) : .localized(.next), for: .normal)
    }
    
    @IBAction func nextButtonClicked() {
        delegate?.nextButtonClicked()
    }
}

protocol SurveyNextButtonCellDelegate: AnyObject {
    func nextButtonClicked()
}

#if DEBUG
extension SurveyNextButtonCell {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: SurveyNextButtonCell

        var nextButton: SoliUButton! { target.nextButton }

        func populate(readySubmit: Bool, isActive: Bool) {
            target.populate(readySubmit: readySubmit, isActive: isActive)
        }
    }
}
#endif