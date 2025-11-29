//
//  HomeTabBar.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/11/24.
//

import Foundation
import UIKit

@IBDesignable
final class HomeTabBar: UITabBar {
    private let backgroundLayer = UIView()
    private var dividers: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabBarAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTabBarAppearance()
    }

    private func setupTabBarAppearance() {
        // Remove default background
        backgroundImage = UIImage()
        shadowImage = UIImage()
        isTranslucent = true

        // Add custom background
        backgroundLayer.backgroundColor = .white
        backgroundLayer.layer.cornerRadius = 15
        backgroundLayer.layer.shadowColor = UIColor.black.cgColor
        backgroundLayer.layer.shadowOpacity = 0.1
        backgroundLayer.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundLayer.layer.shadowRadius = SoliUSpacing.space8
        addSubview(backgroundLayer)
        sendSubviewToBack(backgroundLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let safeAreaInsets = self.safeAreaInsets
        //Note: edit this to change white background color
        let backgroundHeight: CGFloat = 60
        backgroundLayer.frame = CGRect(
            x: SoliUSpacing.space16,
            y: bounds.height - backgroundHeight + 10 - safeAreaInsets.bottom,
            width: bounds.width - SoliUSpacing.space32,
            height: backgroundHeight
        )

        setupDividers()
    }

    private func setupDividers() {
        dividers.forEach { $0.removeFromSuperview() }
        dividers.removeAll()

        guard let items = items, items.count > 1 else { return }

        let tabBarItemWidth = (backgroundLayer.frame.width) / CGFloat(items.count)
        let dividerHeight: CGFloat = 33 // Height of the divider
        let dividerWidth: CGFloat = 2 // Width of the divider
        let dividerColor = SoliUColor.newSoliuLightGray // Divider color

        for index in 1..<items.count {
            let dividerX = backgroundLayer.frame.minX + CGFloat(index) * tabBarItemWidth
            //Note: edit this to change divider
            let dividerFrame = CGRect(
                x: dividerX - (dividerWidth / 2),
                y: backgroundLayer.frame.minY + 15,
                width: dividerWidth,
                height: dividerHeight
            )

            let divider = UIView(frame: dividerFrame)
            divider.backgroundColor = dividerColor
            addSubview(divider)
            dividers.append(divider)
        }
    }
}

#if DEBUG
extension HomeTabBar {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: HomeTabBar

        var dividers: [UIView] { target.dividers }

    }
}
#endif
