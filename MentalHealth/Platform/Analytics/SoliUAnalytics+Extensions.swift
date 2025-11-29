//
//  SoliUAnalytics+Extensions.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

import UIKit
import FirebaseAnalytics

private enum AppAnalytics {
    /// ======================================
    // MARK: - Screen View & Navigation Transition
    // ======================================
    static func logScreenView(name: String, className: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name,
            AnalyticsParameterScreenClass: className,
            AnalyticsKey.timestamp.rawValue: Date().timeIntervalSince1970
        ])
    }

    static func logNavTransition(from: String, to: String) {
        SoliUAnalytics.logEvent("nav_transition", parameters: [
            AnalyticsKey.from: from,
            AnalyticsKey.to: to,
            AnalyticsKey.timestamp: Date().timeIntervalSince1970
        ])
    }

    // ======================================
    // MARK: - Button Click(TODO)
    // ======================================
}

extension UIViewController {
    func trackPush(to target: UIViewController) {
        let fromName = String(describing: type(of: self))
        let toClass  = String(describing: type(of: target))
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            AppAnalytics.logScreenView(name: toClass, className: toClass)
            AppAnalytics.logNavTransition(from: fromName, to: toClass)
        }
        CATransaction.commit()
    }
}
