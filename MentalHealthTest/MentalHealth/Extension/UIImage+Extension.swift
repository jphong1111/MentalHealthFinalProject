//
//  UIImage+Extension.swift
//  MentalHealth
//
//  Created by JungpyoHong on 2/5/24.
//

import Foundation
import UIKit

public enum ImageAsset: String {
    case soliuLogoOnly
    case newSelfTest
    case selfTest
    case soliuLogo
    case right
    case rightArrow
    case home
    case account
    case dayClick
    case dayUnClick
    case calendar
    case newBackArrow
    case buttonCheck
    case bioMetrics
    case notification
    case writeReview
    case medical
    case demographics
    case homeTab
    case dayTab
    case accountTab
    case settingIcon
    
    var assetName: String {
        switch self {
        case .soliuLogoOnly: return "SoluLogo"
        case .newSelfTest: return "newSelfTest"
        case .selfTest: return "SelfTest"
        case .soliuLogo: return "SoluLogo"
        case .right: return "Right"
        case .rightArrow: return "RightArrow"
        case .home: return "Home"
        case .account: return "Account"
        case .dayClick: return "DayClick"
        case .dayUnClick: return "DayUnClick"
        case .calendar: return "Calendar"
        case .newBackArrow: return "BackArrow"
        case .buttonCheck: return "ButtonCheck"
        case .bioMetrics: return "BioMetrics"
        case .notification: return "Notification"
        case .writeReview: return "WriteReview"
        case .medical: return "Medical"
        case .demographics: return "Demographics"
        case .homeTab: return "homeTab"
        case .dayTab: return "dayTab"
        case .accountTab: return "accountTab"
        case .settingIcon: return "settingIcon"
        }
    }
    
    public var iconAccessibilityLabel: String {
        return assetName
    }
}

enum Emotion: String {
    case star
    case badIcon
    case badIconBig
    case badIconSelected
    case sadIcon
    case sadIconBig
    case sadIconSelected
    case decentIcon
    case decentIconBig
    case decentIconSelected
    case goodIcon
    case goodIconBig
    case goodIconSelected
    case niceIcon
    case niceIconBig
    case niceIconSelected
    case goodBlur
    case badBlur
    case smallDiaryHappy
    case smallDiraySad
    case noIcon
}

enum SurveyImage: String {
    case unmarkedVRare
    case unmarkedRare
    case unmarkedSometimes
    case unmarkedOften
    case unmarkedVOften
    case markedVRare
    case markedRare
    case markedSometimes
    case markedOften
    case markedVOften
//  Survey Result
    case depressionIcon
    case anxietyIcon
    case stressIcon
    case socialmediaIcon
    case lonelinessIcon
    case hrqolIcon
    
    case whiteBackButton
    case myResultLegend
    case averageLegend
}


extension UIImage {
    convenience init?(assetIdentifier: SurveyImage) {
        let imagePath = "Icon/\(assetIdentifier.rawValue)"
        self.init(named: imagePath)
    }

    convenience init?(emotionAssetIdentifier: Emotion) {
        let imagePath = "Icon/Emotion/\(emotionAssetIdentifier.rawValue)"
        self.init(named: imagePath)
    }

    func resized(toScale scale: CGFloat) -> UIImage {
           let newSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)
           UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
           self.draw(in: CGRect(origin: .zero, size: newSize))
           let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           
           return resizedImage ?? self
    }

    func resizeTo(width: CGFloat, height: CGFloat) -> UIImage? {
        let newSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: newSize))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension ImageAsset {
    public var image: UIImage {
        guard let image = UIImage(named: "Icon/\(rawValue)", in: .mentalHealthBundle, compatibleWith: nil) else {
            guard UIImage(named: "Icon/Emotion/\(rawValue)", in: .mentalHealthBundle, compatibleWith: nil) != nil else {
                return UIImage()
            }
            preconditionFailure("No Asset image found named \(rawValue)")
        }
        image.accessibilityLabel = iconAccessibilityLabel
        return image
    }
}
