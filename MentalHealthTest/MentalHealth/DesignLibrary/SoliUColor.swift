//
//  SoliUColor.swift
//  MentalHealth
//
//  Created by JungpyoHong on 1/28/25.
//

import UIKit

/// Color system for the app using a structured `struct`
/// Example usage: `view.backgroundColor = SoliUColor.newSoliuOrange`
struct SoliUColor {

//    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }    // MARK: - Dynamic Colors Based on Mental Health State
//    static var newBackgroundColor: UIColor {
//        return SoliUThemeManager.shared.currentState.backgroundColor
//    }

    // MARK: - New Design Colors
    static let newSoliuBlue = color(hex: "#0075FF")
    static let newSoliuOrange = color(hex: "#FF5D00")
    static let newShadowColor = color(hex: "#A8A8A8")
    static let newSoliuLightGray = color(hex: "#F3F3F3")
    
    static let quoteSectionTitleBackground = color(hex: "#0066DE")
    static let tabUnselected = color(hex: "#C5C5C5")
    // MARK: - Old Design Colors
    static let soliuBlue = color(hex: "#00B8F1")
    static let soliuBlack = color(hex: "#2E2E2E")
    static let soliuBlack2 = color(hex: "#555555")
    static let soliuGrey = color(hex: "#9D9D9D")
    static let viewBorder = color(hex: "#63DAFF")
    static let tabBarBorder = color(hex: "#CBCBCB")
    static let progressBar = color(hex: "#FFE500")
    static let progressTrackBar = color(hex: "#F5F5F5")
    static let progressBarBorder = color(hex: "#E4E4E4")

    static let homepageTopBackground = color(hex: "#001835")
    static let homepageBackgroundStart = color(hex: "#0043F1")
    static let homepageBackgroundEnd = color(hex: "#0094FF")
    static let homepageBackground = color(hex: "#FAFAFA")
    static let homepageStroke = color(hex: "#EEEEEE")
    static let homepageOverallStroke = color(hex: "#D6D5D5")
    static let tabBarStroke = color(hex: "#EEECEC")
    static let homepageNoBackground = color(hex: "#FF6B6B")
    static let submitButtonBackground = color(hex: "#232323")
    static let loginNextBackground = color(hex: "#1CBDEF")
    static let loginNextDisabled = color(hex: "#ECECEC")
    static let testNavigationBar = color(hex: "#F1F1F1")
    static let homepageMoodToday = color(hex: "#00A9DD")
    static let yesButtonColor = color(hex: "#00C058")
    static let noButtonColor = color(hex: "#F83765")
    static let noStrokeColor = color(hex: "#D9D9D9")
    static let accountYesButton = color(hex: "#EE1C4E")
    static let slider = color(hex: "#E5E5E5")
    static let darkButton = color(hex: "#030303")
    static let blueButton = color(hex: "#00BAF3")
    static let devider = color(hex: "#ADADAD")

    // MARK: - Survey Result Colors
    static let chartMyScoreFill = color(hex: "#26CCFF")
    static let chartAverageBorder = color(hex: "#1271FF")
    static let depressionColor = color(hex: "#5D6CF3")
    static let anxietyColor = color(hex: "#31BC82")
    static let stressColor = color(hex: "#EC674A")
    static let socialMediaColor = color(hex: "#783BFA")
    static let lonelinessColor = color(hex: "#EC9B3C")
    static let hrqolColor = color(hex: "#EC1C4E")

    static let surveyWarningBackground = color(hex: "#FFEAEA")
    static let surveyWarningLabel = color(hex: "#FF123D")
    static let surveyResultGreen = color(hex: "#00D67C")
    static let surveyResultRed = color(hex: "#FF003D")

    static let surveyResultLow = color(hex: "#0FD274")
    static let surveyResultModerate = color(hex: "#FF8A00")
    static let surveyResultHigh = color(hex: "#FF4242")
    static let surveyStackBorder = color(hex: "#DDDDDD")
    static let surveyAvgTitle = color(hex: "#838383")
    static let detailsIconColor = color(hex: "#A5A5A5")

    // MARK: - Diary Colors
    static let diaryRedBorder = color(hex: "#E64F4F")
    static let showTitle = color(hex: "#686868")
    static let diarySubmitButton = color(hex: "#FFAD49")
    static let diaryBackground = color(hex: "#E5E5E5")

    private static func color(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexValue = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexValue.hasPrefix("#") { hexValue.remove(at: hexValue.startIndex) }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

//TODO: Update color
extension SoliUColor {
    // Brand palette (camelCase)
    static let dodgerBlue = UIColor(hex: "#0075FF")
    static let bitterSweet = UIColor(hex: "#FF6060")
    static let mySin = UIColor(hex: "#FFAD49")
    static let goldenYellow = UIColor(hex: "#FFE500")
    static let conifer = UIColor(hex: "#ACDD4D")
    static let pigmentGreen = UIColor(hex: "#00C058")
    
    static let redOrange = UIColor(hex: "#FF3333")
    static let tomato = UIColor(hex: "#FF6347")
    static let tangerineYellow = UIColor(hex: "#FFC700")
    static let malachite = UIColor(hex: "#0FD274")
    static let cornflowerBlue = UIColor(hex: "#55A7FF")
    static let eastSide = UIColor(hex: "#AD7DB7")
    
    static let nightRider = UIColor(hex: "#2E2E2E")
    static let zambezi = UIColor(hex: "#5A5A5A")
    static let veryLightGrey = UIColor(hex: "#CBCBCB")
    static let whiteSmoke = UIColor(hex: "#F1F1F1")
    static let snow = UIColor(hex: "#FBFBFB")
}
