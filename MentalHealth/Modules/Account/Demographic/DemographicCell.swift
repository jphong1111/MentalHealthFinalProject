//
//  DemographicCell.swift
//  MentalHealth
//
//  Created by JungpyoHong on 9/24/25.
//
import UIKit

final class DemographicCell: UITableViewCell {
    static let identifier = "DemographicCell"
    
    private let titleLabel = SoliULabel()
    private let valueLabel = SoliULabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }

    private func setup() {
        titleLabel.font = SoliUFont.medium14
        valueLabel.font = SoliUFont.regular14
        valueLabel.textColor = .gray

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SoliUSpacing.space24),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SoliUSpacing.space24),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
