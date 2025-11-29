//
//  TestAverage.swift
//  MentalHealth
//
//  Created by Yoon on 7/19/24.
//

import Foundation

struct TestAverage: Decodable {
    var DepressionAverage: Double
    var AnxietyAverage: Double
    var StressAverage: Double
    var SocialMediaAddictionAverage: Double
    var LonelinessAverage: Double
    var HRQOLAverage: Double
    
    enum CodingKeys: String, CodingKey {
          case DepressionAverage = "Depression_Average"
          case AnxietyAverage = "Anxiety_Average"
          case StressAverage = "Stress_Average"
          case SocialMediaAddictionAverage = "Social_Media_Addiction_Average"
          case LonelinessAverage = "Loneliness_Average"
          case HRQOLAverage = "HRQOL_Average"
    }
}

