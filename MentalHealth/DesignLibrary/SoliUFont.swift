//
//  SoliUFont.swift
//  MentalHealth
//
//  Created by JungpyoHong on 1/25/25.
//

import Foundation
import UIKit

final class SoliUFont: UIFont, @unchecked Sendable {
    enum FontType: String {
        case thin = "Roboto-Thin"
        case light = "Roboto-Light"
        case regular = "Roboto-Regular"
        case medium = "Roboto-Medium"
        case semiBold = "Roboto-SemiBold"
        case bold = "Roboto-Bold"
        case extraBold = "Roboto-ExtraBold"
        case black = "Roboto-Black"
    }

    static let thin8 = SoliUFont(.thin, size: 8)
    static let thin10 = SoliUFont(.thin, size: 10)
    static let thin12 = SoliUFont(.thin, size: 12)
    static let thin14 = SoliUFont(.thin, size: 14)
    static let thin16 = SoliUFont(.thin, size: 16)
    static let thin18 = SoliUFont(.thin, size: 18)
    static let thin20 = SoliUFont(.thin, size: 20)
    
    static let light8 = SoliUFont(.light, size: 8)
    static let light10 = SoliUFont(.light, size: 10)
    static let light12 = SoliUFont(.light, size: 12)
    static let light14 = SoliUFont(.light, size: 14)
    static let light16 = SoliUFont(.light, size: 16)
    static let light18 = SoliUFont(.light, size: 18)
    static let light20 = SoliUFont(.light, size: 20)
    
    static let regular8 = SoliUFont(.regular, size: 8)
    static let regular10 = SoliUFont(.regular, size: 10)
    static let regular12 = SoliUFont(.regular, size: 12)
    static let regular14 = SoliUFont(.regular, size: 14)
    static let regular16 = SoliUFont(.regular, size: 16)
    static let regular18 = SoliUFont(.regular, size: 18)
    static let regular20 = SoliUFont(.regular, size: 20)
    
    static let medium10 = SoliUFont(.medium, size: 10)
    static let medium12 = SoliUFont(.medium, size: 12)
    static let medium14 = SoliUFont(.medium, size: 14)
    static let medium16 = SoliUFont(.medium, size: 16)
    static let medium18 = SoliUFont(.medium, size: 18)
    static let medium20 = SoliUFont(.medium, size: 20)
    
    static let semiBold10 = SoliUFont(.semiBold, size: 10)
    static let semiBold12 = SoliUFont(.semiBold, size: 12)
    static let semiBold14 = SoliUFont(.semiBold, size: 14)
    static let semiBold16 = SoliUFont(.semiBold, size: 16)
    static let semiBold18 = SoliUFont(.semiBold, size: 18)
    static let semiBold20 = SoliUFont(.semiBold, size: 20)
    static let semiBold22 = SoliUFont(.semiBold, size: 22)
    static let semiBold24 = SoliUFont(.semiBold, size: 24)
    static let semiBold32 = SoliUFont(.semiBold, size: 32)
    
    static let bold10 = SoliUFont(.bold, size: 10)
    static let bold12 = SoliUFont(.bold, size: 12)
    static let bold14 = SoliUFont(.bold, size: 14)
    static let bold16 = SoliUFont(.bold, size: 16)
    static let bold18 = SoliUFont(.bold, size: 18)
    static let bold20 = SoliUFont(.bold, size: 20)
    static let bold22 = SoliUFont(.bold, size: 22)
    static let bold24 = SoliUFont(.bold, size: 24)
    static let bold32 = SoliUFont(.bold, size: 32)
    
    static let extraBold10 = SoliUFont(.extraBold, size: 10)
    static let extraBold12 = SoliUFont(.extraBold, size: 12)
    static let extraBold14 = SoliUFont(.extraBold, size: 14)
    static let extraBold16 = SoliUFont(.extraBold, size: 16)
    static let extraBold18 = SoliUFont(.extraBold, size: 18)
    static let extraBold20 = SoliUFont(.extraBold, size: 20)
    static let extraBold22 = SoliUFont(.extraBold, size: 22)
    static let extraBold24 = SoliUFont(.extraBold, size: 24)
    static let extraBold32 = SoliUFont(.extraBold, size: 32)

    static let black10 = SoliUFont(.black, size: 10)
    static let black12 = SoliUFont(.black, size: 12)
    static let black14 = SoliUFont(.black, size: 14)
    static let black16 = SoliUFont(.black, size: 16)
    static let black32 = SoliUFont(.black, size: 32)
    
    private static func SoliUFont(_ type: FontType, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.rawValue, size: size) else {
            print("Failed to load font: \(type.rawValue). Reverting to system font.")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
