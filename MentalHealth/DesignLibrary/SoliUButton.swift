//
//  SoliUButton.swift
//  MentalHealth
//
//  Created by JungpyoHong on 1/31/25.
//

import UIKit

open class SoliUButton: UIButton {
    private var localizationKey: SoliULocalizationKey?

    override init(frame: CGRect) {
        super.init(frame: frame)
        SoliUTextManager.shared.register(self)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        isAccessibilityElement = true
        SoliUTextManager.shared.register(self)
        detectLocalizationKey(from: title(for: .normal))
    }
    /// Overrides the default setTitle(_:for:) method.
    /// When a title is set, the button’s accessibilityLabel (and optionally accessibilityIdentifier) is automatically updated.
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)

        if let title = title, !title.isEmpty {
            self.accessibilityLabel = title
            self.accessibilityIdentifier = title
        }
        detectLocalizationKey(from: title)
    }

    open override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        super.setAttributedTitle(title, for: state)
        
        if let title = title, !title.string.isEmpty {
            self.accessibilityLabel = title.string
            self.accessibilityIdentifier = title.string
        }
        detectLocalizationKey(from: title?.string)
    }

    deinit {
        SoliUTextManager.shared.unregister(self)
    }
}

extension SoliUButton {
    private func detectLocalizationKey(from title: String?) {
        guard let title = title else { return }
        if let key = SoliULocalizationKey.allCases.first(where: { .localized($0) == title }) {
            localizationKey = key
        }
    }

    func updateLocalization() {
        if let key = localizationKey {
            self.setTitle(.localized(key), for: .normal)
        }
    }
}

