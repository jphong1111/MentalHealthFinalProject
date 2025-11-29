//
//  Date+Extension.swift
//  MentalHealth
//
//  Created by Yoon on 6/6/24.
//

import UIKit


extension NSAttributedString {
    static func medicalReferenceCitationText() -> NSAttributedString {
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: SoliUFont.bold14]
        let plainAttributes: [NSAttributedString.Key: Any] = [.font: SoliUFont.medium14]
        let linkFont = UIFont.systemFont(ofSize: 12)
        let disclaimerFont = UIFont.italicSystemFont(ofSize: 12)
        let disclaimerColor = UIColor.systemGray

        let boldText1 = NSAttributedString(string: "Depression, Anxiety, and Stress Test Source:\n", attributes: boldAttributes)
        let plainText1 = NSAttributedString(string: "The items used in the depression, anxiety, and stress assessments are adapted from the DASS-42 (Depression Anxiety Stress Scales), developed by S.H. Lovibond & P.F. Lovibond...\n", attributes: plainAttributes)
        let linkText1 = NSAttributedString(string: "Source: https://www2.psy.unsw.edu.au/dass/\n\n", attributes: [.link: URL(string: "https://www2.psy.unsw.edu.au/dass/")!, .font: linkFont])

        let boldText2 = NSAttributedString(string: "HRQOL (Health-Related Quality of Life) Source:\n", attributes: boldAttributes)
        let plainText2 = NSAttributedString(string: "Information about HRQOL was taken from the CDC’s NIOSH Science Blog...\n", attributes: plainAttributes)
        let linkText2 = NSAttributedString(string: "Source: https://blogs.cdc.gov/niosh-science-blog/2017/07/26/hrqol/\n\n", attributes: [.link: URL(string: "https://blogs.cdc.gov/niosh-science-blog/2017/07/26/hrqol/")!, .font: linkFont])

        let boldText3 = NSAttributedString(string: "Social Media Addiction Source:\n", attributes: boldAttributes)
        let plainText3 = NSAttributedString(string: "Our insights on social media addiction come from the Addiction Center...\n", attributes: plainAttributes)
        let linkText3 = NSAttributedString(string: "Source: https://www.addictioncenter.com/behavioral-addictions/social-media-addiction/\n\n", attributes: [.link: URL(string: "https://www.addictioncenter.com/behavioral-addictions/social-media-addiction/")!, .font: linkFont])

        let disclaimerText = NSAttributedString(
            string: .localized(.disclaimerText),
            attributes: [
                .font: disclaimerFont,
                .foregroundColor: disclaimerColor
            ]
        )

        let fullReference = NSMutableAttributedString()
        fullReference.append(boldText1)
        fullReference.append(plainText1)
        fullReference.append(linkText1)
        fullReference.append(boldText2)
        fullReference.append(plainText2)
        fullReference.append(linkText2)
        fullReference.append(boldText3)
        fullReference.append(plainText3)
        fullReference.append(linkText3)
        fullReference.append(NSAttributedString(string: "\n"))
        fullReference.append(disclaimerText)

        return fullReference
    }
}
