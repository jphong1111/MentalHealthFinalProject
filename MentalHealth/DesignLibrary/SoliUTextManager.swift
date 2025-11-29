//
//  SoliUTextManager.swift
//  MentalHealth
//
//  Created by JungpyoHong on 2/3/25.
//

import Foundation
import UIKit

//This class is to help Button and Label for Dynamic localization setting
final class SoliUTextManager {
    static let shared = SoliUTextManager()

    private var labels: NSHashTable<SoliULabel> = NSHashTable.weakObjects()
    private var buttons: NSHashTable<SoliUButton> = NSHashTable.weakObjects()
    private var tabBarItems: NSHashTable<SoliUITabBarItem> = NSHashTable.weakObjects()

    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAllTexts),
            name: .languageDidChange,
            object: nil
        )
    }

    // MARK: - Register & Unregister Labels
    func register(_ label: SoliULabel) {
        labels.add(label)
    }

    func unregister(_ label: SoliULabel) {
        labels.remove(label)
    }

    // MARK: - Register & Unregister Buttons
    func register(_ button: SoliUButton) {
        buttons.add(button)
    }

    func unregister(_ button: SoliUButton) {
        buttons.remove(button)
    }

    // MARK: - Register & Unregister UITabBarItem
    func register(_ tabBarItem: SoliUITabBarItem) {
        tabBarItems.add(tabBarItem)
    }

    func unregister(_ tabBarItem: SoliUITabBarItem) {
        tabBarItems.remove(tabBarItem)
    }

    // MARK: - Update All Texts on Language Change
    @objc private func updateAllTexts() {
        UIView.performWithoutAnimation {
            for label in labels.allObjects {
                label.updateLocalization()
            }
            for button in buttons.allObjects {
                button.updateLocalization()
            }
            for tabBarItem in tabBarItems.allObjects {
                tabBarItem.updateLocalization()
            }
        }
    }
}

#if DEBUG
extension SoliUTextManager {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: SoliUTextManager

        var labels: NSHashTable<SoliULabel> { target.labels }

        var buttons: NSHashTable<SoliUButton> { target.buttons }

        var tabBarItems: NSHashTable<SoliUITabBarItem> { target.tabBarItems }

        func register(_ label: SoliULabel) {
            target.register(label)
        }

        func unregister(_ label: SoliULabel) {
            target.unregister(label)
        }

        func register(_ button: SoliUButton) {
            target.register(button)
        }

        func unregister(_ button: SoliUButton) {
            target.unregister(button)
        }

        func register(_ tabBarItem: SoliUITabBarItem) {
            target.register(tabBarItem)
        }

        func unregister(_ tabBarItem: SoliUITabBarItem) {
            target.unregister(tabBarItem)
        }
    }
}
#endif