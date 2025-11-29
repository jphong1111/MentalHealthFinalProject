//
//  WeeklyMoodCell.swift
//  MentalHealth
//
//  Created by JungpyoHong on 1/21/25.
//

import Foundation
import UIKit

final class WeeklyMoodCell: UICollectionViewCell {
    static let identifier = "WeeklyMoodCell"

    private let moodImageView: UIImageView = {
        let moodImageView = UIImageView()
        moodImageView.image = UIImage(emotionAssetIdentifier: .noIcon)
        return moodImageView
    }()

    private let dayLabel: SoliULabel = {
        let label = SoliULabel()
        label.font = SoliUFont.regular14
        label.textAlignment = .center
        label.textColor = SoliUColor.soliuBlack
        return label
    }()

    private let dateLabel: SoliULabel = {
        let label = SoliULabel()
        label.font = SoliUFont.medium12
        label.textAlignment = .center
        label.textColor = SoliUColor.soliuBlack2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        contentView.addSubView([moodImageView, dayLabel, dateLabel])

        NSLayoutConstraint.activate([
            moodImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            moodImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SoliUSpacing.space8),
            moodImageView.widthAnchor.constraint(equalToConstant: 28),
            moodImageView.heightAnchor.constraint(equalToConstant: 28),
            dayLabel.topAnchor.constraint(equalTo: moodImageView.bottomAnchor, constant: SoliUSpacing.space4),
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            dateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 2),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    func configure(day: String, date: String, moodImage: UIImage?, isToday: Bool) {
        dayLabel.text = day
        dateLabel.text = date
        moodImageView.image = moodImage ?? UIImage(emotionAssetIdentifier: .noIcon)

        // if its today, show different color and font
        if isToday {
            contentView.backgroundColor = UIColor(hex: "F6F6F6")
            contentView.layer.cornerRadius = 10
            dayLabel.textColor = SoliUColor.newSoliuBlue
            dayLabel.font = SoliUFont.black14
            dateLabel.textColor = SoliUColor.newSoliuBlue
        } else {
            contentView.backgroundColor = .clear
            dayLabel.textColor = SoliUColor.soliuBlack
            dayLabel.font = SoliUFont.regular14
            dateLabel.textColor = SoliUColor.soliuBlack2
        }
    }
}

#if DEBUG
extension WeeklyMoodCell {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: WeeklyMoodCell

        func configure(day: String, date: String, moodImage: UIImage?, isToday: Bool) {
            target.configure(day: day, date: date, moodImage: moodImage, isToday: isToday)
        }
    }
}
#endif
