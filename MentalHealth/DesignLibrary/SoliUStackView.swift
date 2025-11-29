//
//  SoliUStackView.swift
//  MentalHealth
//
//  Created by JungpyoHong on 1/1/25.
//

import Foundation
import UIKit

open class SoliUStackView: UIStackView {
    // Property to store the minimum height
    private var minimumHeight: CGFloat = 0 {
        didSet {
            updateMinimumHeight()
        }
    }

    // Initializer to set axis and spacing
    init(axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required public init(coder: NSCoder) {
        super.init(coder: coder)
        translatesAutoresizingMaskIntoConstraints = false
    }

    // Automatically calculates the minimum height based on the font size of subviews
    open override func layoutSubviews() {
        super.layoutSubviews()
        calculateMinimumHeight()
    }

    // Function to calculate and set the minimum height
    private func calculateMinimumHeight() {
        var maxFontHeight: CGFloat = 0

        for subview in arrangedSubviews {
            if let label = subview as? SoliULabel {
                // Use the lineHeight of the label's font
                maxFontHeight = max(maxFontHeight, label.font.lineHeight)
            }
        }
        // Round up to the nearest integer
        minimumHeight = ceil(maxFontHeight)
    }

    // Update the stack view's height constraint to reflect the minimum height
    private func updateMinimumHeight() {
        // Remove any existing height constraints
        constraints.filter { $0.firstAttribute == .height }.forEach { removeConstraint($0) }

        // Add a new height constraint based on the minimum height
        let heightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: minimumHeight)
        heightConstraint.isActive = true
    }
}
