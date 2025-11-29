//
//  DiarcyCell.swift
//  MentalHealth
//
//  Created by Yoon on 5/8/24.
//

import UIKit

final class DiarcyCell: UITableViewCell, CellReusable {
    
    @IBOutlet weak var dateLabel: SoliULabel!
    @IBOutlet weak var emotionImageView: UIImageView!
    @IBOutlet weak var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(myDiary: AdviceItem) {
        self.dateLabel.text = .convertDateString(myDiary.date)
        self.emotionImageView.image = myDiary.myDiaryMood.moodImage
        switch myDiary.myDiaryMood {
        case .good:
            self.borderView.addBorderAndColor(color: SoliUColor.newSoliuBlue, width: 1, corner_radius: SoliUSpacing.space8)
        case .bad:
            self.borderView.addBorderAndColor(color: SoliUColor.diaryRedBorder, width: 1, corner_radius: SoliUSpacing.space8)
        }
    }
}

#if DEBUG
extension DiarcyCell {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: DiarcyCell

        var dateLabel: SoliULabel! { target.dateLabel }

        var emotionImageView: UIImageView! { target.emotionImageView }

        var borderView: UIView! { target.borderView }

        func populate(myDiary: AdviceItem) {
            target.populate(myDiary: myDiary)
        }
    }
}
#endif
