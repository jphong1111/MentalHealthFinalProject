////
////  MyDay.swift
////  MentalHealth
////
////  Created by Yoon on 6/6/24.
////

import Foundation
import UIKit

struct MyDay: Codable {
    var date: String
    var myMood: MyMood
    var isDetoxed: String?
    
    enum CodingKeys: String, CodingKey {
        case date
        case myMood
        case isDetoxed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try container.decode(String.self, forKey: .date)
        myMood = try container.decode(MyMood.self, forKey: .myMood)
        
        // Check if `isDetoxed` is present and decode if available
        isDetoxed = try container.decodeIfPresent(String.self, forKey: .isDetoxed)
    }
    
    // You can also provide a custom initializer if needed
    init(date: String, myMood: MyMood, isDetoxed: String? = nil) {
        self.date = date
        self.myMood = myMood
        self.isDetoxed = isDetoxed
        
    }
    
    var parsedDate: Date? {
        return MyDay.parseDate(from: date)
    }
    
    static func parseDate(from dateString: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: dateString) {
            return date
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: dateString)
        }
    }
}

enum MyMood: String, Codable {
    case bad
    case sad
    case decent
    case good
    case nice
    case empty = ""  // Representing an empty string
    
    var moodImage: UIImage? {
        switch self {
        case .bad:
            return UIImage(emotionAssetIdentifier: .badIcon)
        case .sad:
            return UIImage(emotionAssetIdentifier: .sadIcon)
        case .decent:
            return UIImage(emotionAssetIdentifier: .decentIcon)
        case .good:
            return UIImage(emotionAssetIdentifier: .goodIcon)
        case .nice:
            return UIImage(emotionAssetIdentifier: .niceIcon)
        case .empty:
            return nil
        }
    }
}


final class WeekViewHelper {
    static func createfilteredMood() -> [MyDay] {
        if !LoginManager.shared.isLoggedIn() {
            print("User Not Logged In Please set core data here")
            return []
        }
        let userMoodList = LoginManager.shared.getDailyMoodList()
        let dateFormatter = DateFormatter()
        let isoFormatter = ISO8601DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
        let filteredMoods = userMoodList.filter { mood in
            var moodDate: Date?
            
            // Try parsing with ISO8601 formatter first
            if let isoDate = isoFormatter.date(from: mood.date) {
                moodDate = isoDate
            } else if let formattedDate = dateFormatter.date(from: mood.date) {
                // If not ISO, try the "yyyy-MM-dd" format
                moodDate = formattedDate
            }
            
            // Check if moodDate exists and is within the current week
            if let moodDate = moodDate {
                return moodDate >= startOfWeek && moodDate <= endOfWeek
            }
            return false
        }
        return filteredMoods
    }
    
    static func getTodayWeekday() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: date)
        return weekday
    }
    
    static func getMoodDateFormat() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
}
