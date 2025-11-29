//
//  QuoteSectionViewController.swift
//  MentalHealth
//
//

import Foundation
import UIKit

// Note: Each Section Needs to conform to SectionRegisterable to get a unique id
extension QuoteSectionViewController: SectionRegisterable {
    static var identifier: SectionIdentifier { return .quote }
}

final class QuoteSectionViewController: BaseSectionViewController {
    private lazy var titleBackgroundView: UIView = {
        let titleBackground = UIView()
        titleBackground.layer.masksToBounds = true
        titleBackground.layer.cornerRadius = 10
        titleBackground.backgroundColor = SoliUColor.quoteSectionTitleBackground
        return titleBackground
    }()
    
    private lazy var titleLabel: SoliULabel = {
        let titleLabel = SoliULabel()
        titleLabel.text = .localized(.quoteOfTheDay)
        titleLabel.font = SoliUFont.regular12
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    private lazy var quoteLabel: SoliULabel = {
        let quoteLabel = SoliULabel()
        quoteLabel.font = SoliUFont.bold16
        quoteLabel.textColor = .white
        quoteLabel.numberOfLines = 0
        quoteLabel.textAlignment = .left
        return quoteLabel
    }()
    
    private lazy var authorLabel: SoliULabel = {
        let authorLabel = SoliULabel()
        authorLabel.font = SoliUFont.regular12
        authorLabel.textColor = .white
        authorLabel.textAlignment = .left
        return authorLabel
    }()

    private lazy var refreshButton: SoliUButton = {
        let refreshButton = SoliUButton()
        let image = UIImage(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysTemplate)
        refreshButton.setImage(image, for: .normal)
        refreshButton.tintColor = .white
        refreshButton.addTarget(self, action: #selector(refreshQuote), for: .touchUpInside)
        return refreshButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateQuote()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateQuote()
    }

    private func setupView() {
        view.backgroundColor = SoliUColor.newSoliuBlue
        view.clipsToBounds = true

        view.addSubView([titleBackgroundView, quoteLabel, authorLabel, refreshButton])
        titleBackgroundView.addSubView(titleLabel)

        NSLayoutConstraint.activate([
            titleBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: SoliUSpacing.space16),
            titleBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space16),
            titleBackgroundView.widthAnchor.constraint(equalToConstant: 110),
            titleBackgroundView.heightAnchor.constraint(equalToConstant: SoliUSpacing.space20),
            
            refreshButton.widthAnchor.constraint(equalToConstant: SoliUSpacing.space20),
            refreshButton.heightAnchor.constraint(equalToConstant: SoliUSpacing.space20),
            refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space16),
            refreshButton.topAnchor.constraint(equalTo: view.topAnchor, constant: SoliUSpacing.space16),
            
            titleLabel.centerXAnchor.constraint(equalTo: titleBackgroundView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleBackgroundView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleBackgroundView.leadingAnchor, constant: SoliUSpacing.space8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: titleBackgroundView.trailingAnchor, constant: -SoliUSpacing.space8),

            quoteLabel.topAnchor.constraint(equalTo: titleBackgroundView.bottomAnchor, constant: 0),
            quoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space16),
            quoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space16),
            quoteLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: 0),
            
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space16),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space16),
            authorLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -SoliUSpacing.space16),
            authorLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    private func updateQuote() {
        if let quote = getRandomQuote() {
            quoteLabel.animate(newTexts: "\"\(quote.quote)\"", lineSpacing: 0, letterSpacing: 0)
            authorLabel.text = quote.name
        } else {
            quoteLabel.text = "Failed to load Quote"
            authorLabel.text = "Failed to load Author"
        }
    }

    @objc private func refreshQuote() {
        UIView.animate(withDuration: 0.3, animations: {
            self.refreshButton.transform = CGAffineTransform(rotationAngle: .pi)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.refreshButton.transform = CGAffineTransform(rotationAngle: .pi * 2)
            }
        }

        UIView.animate(withDuration: 0.2, animations: {
            self.quoteLabel.alpha = 0
            self.authorLabel.alpha = 0
        }) { _ in
            self.updateQuote()
            UIView.animate(withDuration: 0.2) {
                self.quoteLabel.alpha = 1
                self.authorLabel.alpha = 1
            }
        }
    }
}

#if DEBUG
extension QuoteSectionViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: QuoteSectionViewController

        var titleBackgroundView: UIView { target.titleBackgroundView }

        var titleLabel: SoliULabel { target.titleLabel }

        var quoteLabel: SoliULabel { target.quoteLabel }

        var authorLabel: SoliULabel { target.authorLabel }

        var refreshButton: SoliUButton { target.refreshButton }
    }
}
#endif
