//
//  DangerView.swift
//  MentalHealth
//
//  Created by Yoon on 6/25/24.
//

import UIKit

class DangerView: UIView {
    private lazy var lowLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.low)
        label.textColor = .white
        label.textAlignment = .center
        label.font = SoliUFont.bold12
        label.backgroundColor = SoliUColor.surveyResultLow
        return label
    }()

    private lazy var moderateLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.moderate)
        label.textColor = .white
        label.textAlignment = .center
        label.font = SoliUFont.bold12
        label.backgroundColor = SoliUColor.surveyResultModerate
        return label
    }()

    private lazy var highLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = .localized(.high)
        label.textColor = .white
        label.font = SoliUFont.bold12
        label.textAlignment = .center
        label.backgroundColor = SoliUColor.surveyResultHigh
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
        addSubview(lowLabel)
        addSubview(moderateLabel)
        addSubview(highLabel)

        // Add constraints
        NSLayoutConstraint.activate([
            lowLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            lowLabel.topAnchor.constraint(equalTo: topAnchor),
            lowLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            moderateLabel.leadingAnchor.constraint(equalTo: lowLabel.trailingAnchor),
            moderateLabel.topAnchor.constraint(equalTo: topAnchor),
            moderateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            moderateLabel.widthAnchor.constraint(equalTo: lowLabel.widthAnchor),

            highLabel.leadingAnchor.constraint(equalTo: moderateLabel.trailingAnchor),
            highLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            highLabel.topAnchor.constraint(equalTo: topAnchor),
            highLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            highLabel.widthAnchor.constraint(equalTo: lowLabel.widthAnchor),
        ])

        // Set corner radius
        layer.cornerRadius = 12
        layer.masksToBounds = true

        lowLabel.layer.masksToBounds = true
        moderateLabel.layer.masksToBounds = true
        highLabel.layer.masksToBounds = true
    }
}
