//
//  SoliUITabBarItem.swift
//  MentalHealth
//
//  Created by JungpyoHong on 2/9/25.
//

import UIKit

open class SoliUITabBarItem: UITabBarItem {
    private var localizationKey: SoliULocalizationKey?
    
    init(key: SoliULocalizationKey, image: UIImage? = nil, selectedImage: UIImage? = nil) {
        super.init()
        self.localizationKey = key
        self.image = image
        self.selectedImage = selectedImage
        self.title = .localized(key)
        SoliUTextManager.shared.register(self)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        SoliUTextManager.shared.register(self)
    }
    
    @objc private func updateText() {
        if let key = localizationKey {
            self.title = .localized(key)
        }
    }
    
    func updateLocalization() {
        if let key = localizationKey {
            self.title = .localized(key)
        }
    }
    
    deinit {
        SoliUTextManager.shared.unregister(self)
    }
}
