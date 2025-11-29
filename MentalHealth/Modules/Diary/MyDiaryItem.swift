//
//  MyDiaryItem.swift
//  MentalHealth
//
//  Created by Yoon on 6/17/24.
//

import Foundation
import UIKit


struct AdviceItem: Codable {
    var date: String
    var myDiaryMood: MyDiaryMood
    var userConcernInput: String
    var aiGeneratedAdvice: String
    var userFeedback: String?
    
    enum CodingKeys: String, CodingKey {
           case date
           case myDiaryMood
           case userConcernInput
           case aiGeneratedAdvice
           case userFeedback
    }
    
    func toDictionary() -> [String: Any] {
           return [
               "date": date,
               "myDiaryMood": myDiaryMood.rawValue,
               "userConcernInput": userConcernInput,
               "aiGeneratedAdvice": aiGeneratedAdvice,
               "userFeedback": userFeedback ?? ""
           ]
    }
}

enum MyDiaryMood: String, Codable {
    case bad
    case good
    
    var moodImage: UIImage? {
        switch self {
        case .bad:
            return UIImage(emotionAssetIdentifier: .badBlur)
        case .good:
            return UIImage(emotionAssetIdentifier: .goodBlur)
        }
    }
    
    init(tag: Int) {
        switch tag {
        case 0:
            self = .good
        case 1:
            self = .bad
        default:
            self = .good 
        }
    }
}
