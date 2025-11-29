//
//  SoliULabel.swift
//  MentalHealth
//
//  Created by JungpyoHong on 1/25/25.
//

import Foundation
import UIKit

// Auto localization applied to SoliULabel
open class SoliULabel: UILabel {
    private var localizationKey: SoliULocalizationKey?

    override public var text: String? {
        didSet {
            if let key = localizationKey, text == .localized(key) { return }
            detectLocalizationKey()
            updateAccessibility()
        }
    }

    init(
        _ key: SoliULocalizationKey? = nil,
        font: UIFont = SoliUFont.medium14,
        textColor: UIColor = SoliUColor.soliuBlack,
        textAlignment: NSTextAlignment = .left
    ) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.translatesAutoresizingMaskIntoConstraints = false
        isAccessibilityElement = true  // Enable accessibility for the label
        
        if let key = key {
            applyLocalization(for: key)
        }
        SoliUTextManager.shared.register(self)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        isAccessibilityElement = true
        SoliUTextManager.shared.register(self)
    }

    private func setLocalizedText(_ key: SoliULocalizationKey) {
        applyLocalization(for: key)
    }

    private func applyLocalization(for key: SoliULocalizationKey) {
        self.localizationKey = key
        self.text = .localized(key)
        updateAccessibility()
    }

    private func detectLocalizationKey() {
        guard let text = text else { return }
        if let key = SoliULocalizationKey.allCases.first(where: { .localized($0) == text }) {
            applyLocalization(for: key)
        }
    }

    @objc private func updateText() {
        if let key = localizationKey {
            updateAccessibility()

            UIView.performWithoutAnimation {
                self.text = .localized(key)
                self.layoutIfNeeded()
            }
        }
    }

    func updateLocalization() {
        if let key = localizationKey {
            self.text = .localized(key)
        }
    }

    private func updateAccessibility() {
        accessibilityLabel = text
        accessibilityTraits = .staticText
    }

    deinit {
        SoliUTextManager.shared.unregister(self)
    }
}
