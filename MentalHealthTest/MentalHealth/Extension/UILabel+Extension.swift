//
//  SoliULabel+Extension.swift
//  MentalHealth
//
//  Created by JungpyoHong on 3/18/24.
//

import Foundation
import UIKit


private var quoteAnimationTimers: [Timer] = []

extension SoliULabel {
    func animate(
        newTexts: String?,
        interval: TimeInterval = 0.07,
        lineSpacing: CGFloat = 1.2,
        letterSpacing: CGFloat = 1.1
    ) {
        // 1. Cancel any previous timers
        quoteAnimationTimers.forEach { $0.invalidate() }
        quoteAnimationTimers.removeAll()

        guard let newTexts = newTexts else { return }

        // 2. Setup paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.alignment = .left

        var builtText = ""
        self.text = "" // Clear only once

        var pause: TimeInterval = 0
        var charIndex = 0.0

        for letter in newTexts {
            let timer = Timer.scheduledTimer(withTimeInterval: interval * charIndex + pause, repeats: false) { [weak self] _ in
                guard let self = self else { return }

                builtText.append(letter)
                let attributed = NSMutableAttributedString(string: builtText)
                attributed.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributed.length))
                if attributed.length > 1 {
                    attributed.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: attributed.length - 1))
                }

                self.attributedText = attributed
            }
            RunLoop.main.add(timer, forMode: .common)
            quoteAnimationTimers.append(timer)

            charIndex += 1
            if letter == "," || letter == "." {
                pause += 0.3
            }
        }
    }
}
