
import Foundation
import UIKit

struct UserInformation: Decodable {
    var email: String
    var nickName: String
    var gender: String
    var age: String
    var workStatus: String
    var ethnicity: String
    var surveyResultsList: [SurveyResult]
    var dailyMoodList: [MyDay]
    var adviceItemList: [AdviceItem]
    var progressStar: Int
    var uuid: String?

    enum CodingKeys: String, CodingKey {
        case demographicInformation
        case surveyResultsList
        case progressStar
        case dailyMoodList
        case adviceItemList
    }
    
    enum DemographicCodingKeys: String, CodingKey {
        case email
        case nickname
        case gender
        case age
        case workStatus = "work_status"
        case ethnicity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let demographicContainer = try container.nestedContainer(keyedBy: DemographicCodingKeys.self, forKey: .demographicInformation)
        email = try demographicContainer.decode(String.self, forKey: .email)
        nickName = try demographicContainer.decode(String.self, forKey: .nickname)
        gender = try demographicContainer.decode(String.self, forKey: .gender)
        age = try demographicContainer.decode(String.self, forKey: .age)
        workStatus = try demographicContainer.decode(String.self, forKey: .workStatus)
        ethnicity = try demographicContainer.decode(String.self, forKey: .ethnicity)
        
        progressStar = try container.decode(Int.self, forKey: .progressStar)
        surveyResultsList = try container.decode([SurveyResult].self, forKey: .surveyResultsList)
        dailyMoodList = try container.decode([MyDay].self, forKey: .dailyMoodList)
        adviceItemList = try container.decode([AdviceItem].self, forKey: .adviceItemList)
    }
    
    init(email: String, password: String, nickName: String, gender: String, age: String, workStatus: String, ethnicity: String, surveyResultsList: [SurveyResult], dailyMoodList: [MyDay], adviceItemList: [AdviceItem], progressStar: Int) {
        self.email = email
        self.nickName = nickName
        self.gender = gender
        self.age = age
        self.workStatus = workStatus
        self.ethnicity = ethnicity
        self.surveyResultsList = surveyResultsList
        self.dailyMoodList = dailyMoodList
        self.adviceItemList = adviceItemList
        self.progressStar = progressStar
    }
}

struct SurveyResult: Codable {
    var surveyDate: String
    var surveyAnswer: [Int]
}
