//
//  PreferenceStorage.swift
//  MentalHealth
//
//  Created by JungpyoHong on 1/31/25.
//

import Foundation

final class PreferenceStorage {

    static let shared = PreferenceStorage()

    private init() {}

    // MARK: - Keys

    private enum Keys {
        static let onBoarding = "com.MentalHealth.onBoarding"
        static let homeCustomize = "com.MentalHealth.homeCustomize"
    }

    // MARK: - HomeCustomize Preference
    func setHomeCustomizePreference(_ isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: Keys.homeCustomize)
    }

    func isHomeCustomizeEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.homeCustomize)
    }
    // MARK: - OnBoarding Preference
    func setOnBoardingPreference(_ hasSeen: Bool) {
        UserDefaults.standard.set(hasSeen, forKey: Keys.onBoarding)
    }

    func isOnBoardingSeen() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.onBoarding)
    }
    // MARK: - General Methods

    /// Sets a generic preference value for a given key.
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: A key identifying the preference.
    func setPreference(value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    /// Retrieves a generic preference value for a given key.
    /// - Parameter key: A key identifying the preference.
    /// - Returns: The stored value, or `nil` if not set.
    func getPreference(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    /// Removes a stored preference for a given key.
    /// - Parameter key: The key to remove.
    func removePreference(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

#if DEBUG
extension PreferenceStorage {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: PreferenceStorage

        func setHomeCustomizePreference(_ isEnabled: Bool) {
            target.setHomeCustomizePreference(isEnabled)
        }

        func isHomeCustomizeEnabled() -> Bool { target.isHomeCustomizeEnabled() }

        func setOnBoardingPreference(_ hasSeen: Bool) {
            target.setOnBoardingPreference(hasSeen)
        }

        func isOnBoardingSeen() -> Bool { target.isOnBoardingSeen() }

        func setPreference(value: Any?, forKey key: String) {
            target.setPreference(value: value, forKey: key)
        }

        func getPreference(forKey key: String) -> Any? {
            target.getPreference(forKey: key)
        }

        func removePreference(forKey key: String) {
            target.removePreference(forKey: key)
        }
    }
}
#endif
