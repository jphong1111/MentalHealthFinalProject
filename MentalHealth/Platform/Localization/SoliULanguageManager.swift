//
//  SoliULanguageManager.swift
//  MentalHealth
//
//  Created by JungpyoHong on 2/1/25.
//

import Foundation

final class SoliULanguageManager {
    static let shared = SoliULanguageManager()
    
    private let userDefaults = UserDefaults.standard
    private let languageKey = "selectedLanguage"

    private var systemPreferredLanguage: String {
        let preferred = Locale.preferredLanguages.first ?? "en"
        if preferred.hasPrefix("ko") {
            return "ko"
        } else {
            return "en"
        }
    }

    var currentLanguage: String {
        get {
            if let lang = userDefaults.string(forKey: languageKey) {
                return lang
            } else {
                let systemLang = systemPreferredLanguage
                userDefaults.set(systemLang, forKey: languageKey)
                userDefaults.synchronize()
                return systemLang
            }
        }
        set {
            userDefaults.set(newValue, forKey: languageKey)
            userDefaults.synchronize()
            notifyLanguageChange()
        }
    }
    
    var currentLanguageWithFullName: String {
        switch currentLanguage {
        case "ko":
            return "ko-KR"
        case "en":
            return "en-US"
        default:
            return currentLanguage  // fallback if already full or unrecognized
        }
    }

    private func rawLocalized(_ key: SoliULocalizationKey) -> String {
        guard let path = Bundle.mentalHealthBundle.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key.rawValue, bundle: .mentalHealthBundle, comment: "")
        }
        return NSLocalizedString(key.rawValue, bundle: bundle, comment: "")
    }

    func localized(_ key: SoliULocalizationKey) -> String {
        rawLocalized(key)
    }

    func localized(_ key: SoliULocalizationKey, _ args: CVarArg...) -> String {
        let template = rawLocalized(key)
        guard !args.isEmpty else { return template }
        return String(
            format: template,
            locale: Locale(identifier: currentLanguageWithFullName),
            arguments: args
        )
    }

    func localized(_ key: SoliULocalizationKey, arguments: [CVarArg]) -> String {
        let template = rawLocalized(key)
        guard !arguments.isEmpty else { return template }
        return String(
            format: template,
            locale: Locale(identifier: currentLanguageWithFullName),
            arguments: arguments
        )
    }

    private func notifyLanguageChange() {
        NotificationCenter.default.post(name: .languageDidChange, object: nil)
    }
}


#if DEBUG
extension SoliULanguageManager {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: SoliULanguageManager

        var currentLanguage: String { target.currentLanguage }

        func localized(_ key: SoliULocalizationKey) -> String {
            target.localized(key)
        }
    }
}
#endif
