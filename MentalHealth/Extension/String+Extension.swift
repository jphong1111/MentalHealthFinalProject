//
//  String+Extension.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/9/24.
//

import Foundation

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
}

extension String {
    func capitalizedEachWord() -> String {
        if self == self.capitalized {
            return self
        } else {
            let words = self.components(separatedBy: " ")
            let capitalizedWords = words.map { $0.capitalized }
            return capitalizedWords.joined(separator: " ")
        }
    }
    
    static func convertDateString(_ dateString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: dateString) else { return nil }
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "MMMM dd" // Output date format
        let formattedDateString = dateFormatter.string(from: date)
        return formattedDateString
    }
}

extension Date {
    func toDefaultDateFormat() -> String {
        let isoFormatter = ISO8601DateFormatter()
        return isoFormatter.string(from: self)
    }
}
