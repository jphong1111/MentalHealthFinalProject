//
//  TestingInformation.swift
//  MentalHealth
//
//  Created by Yoon on 3/31/24.
//

import Foundation

final class TestingInformation {
    var testCount: Int = 30
    
    var testInfoArray: [TestQuestion] = [
        TestQuestion(id: 0, questionNumber: 0, type: "Depression", question: .localized(.testOneFirstQuestion)),
        TestQuestion(id: 0, questionNumber: 1, type: "Depression", question: .localized(.testOneSecondQuestion)),
        TestQuestion(id: 0, questionNumber: 2, type: "Depression", question: .localized(.testOneThirdQuestion)),
        TestQuestion(id: 0, questionNumber: 3, type: "Depression", question: .localized(.testOneForthQuestion)),
        TestQuestion(id: 0, questionNumber: 4, type: "Depression", question: .localized(.testOneFifthQuestion)),
        
        TestQuestion(id: 1, questionNumber: 5, type: "Anxiety", question: .localized(.testTwoFirstQuestion)),
        TestQuestion(id: 1, questionNumber: 6, type: "Anxiety", question: .localized(.testTwoSecondQuestion)),
        TestQuestion(id: 1, questionNumber: 7, type: "Anxiety", question: .localized(.testTwoThirdQuestion)),
        TestQuestion(id: 1, questionNumber: 8, type: "Anxiety", question: .localized(.testTwoForthQuestion)),
        TestQuestion(id: 1, questionNumber: 9, type: "Anxiety", question: .localized(.testTwoFifthQuestion)),
        
        TestQuestion(id: 2, questionNumber: 10, type: "Stress", question: .localized(.testThreeFirstQuestion)),
        TestQuestion(id: 2, questionNumber: 11, type: "Stress", question: .localized(.testThreeSecondQuestion)),
        TestQuestion(id: 2, questionNumber: 12, type: "Stress", question: .localized(.testThreeThirdQuestion)),
        TestQuestion(id: 2, questionNumber: 13, type: "Stress", question: .localized(.testThreeForthQuestion)),
        TestQuestion(id: 2, questionNumber: 14, type: "Stress", question: .localized(.testThreeFifthQuestion)),
        
        TestQuestion(id: 3, questionNumber: 15, type: "Social Media Addiction", question: .localized(.testFourFifthQuestion)),
        TestQuestion(id: 3, questionNumber: 16, type: "Social Media Addiction", question: .localized(.testFourSecondQuestion)),
        TestQuestion(id: 3, questionNumber: 17, type: "Social Media Addiction", question: .localized(.testFourThirdQuestion)),
        TestQuestion(id: 3, questionNumber: 18, type: "Social Media Addiction", question: .localized(.testFourForthQuestion)),
        TestQuestion(id: 3, questionNumber: 19, type: "Social Media Addiction", question: .localized(.testFourFifthQuestion)),
        
        TestQuestion(id: 4, questionNumber: 20, type: "Loneliness", question: .localized(.testFiveFirstQuestion)),
        TestQuestion(id: 4, questionNumber: 21, type: "Loneliness", question: .localized(.testFiveSecondQuestion)),
        TestQuestion(id: 4, questionNumber: 22, type: "Loneliness", question: .localized(.testFiveThirdQuestion)),
        TestQuestion(id: 4, questionNumber: 23, type: "Loneliness", question: .localized(.testFiveForthQuestion)),
        TestQuestion(id: 4, questionNumber: 24, type: "Loneliness", question: .localized(.testFiveFifthQuestion)),
        
         TestQuestion(id: 5, questionNumber: 25, type: "HQ", question: .localized(.testSixFirstQuestion)),
         TestQuestion(id: 5, questionNumber: 26, type: "HQ", question: .localized(.testSixSecondQuestion)),
         TestQuestion(id: 5, questionNumber: 27, type: "HQ", question: .localized(.testSixThirdQuestion)),
         TestQuestion(id: 5, questionNumber: 28, type: "HQ", question: .localized(.testSixForthQuestion)),
         TestQuestion(id: 5, questionNumber: 29, type: "HQ", question: .localized(.testSixFifthQuestion))
    ]
    
    func createTestingSurveyQuestion() -> [TestQuestion] {
        return testInfoArray
    }
    
    func exampleSurveyList() -> [Int:Int] {
        var results = [Int: Int]()
            for key in 0..<testCount {
                results[key] = (Int.random(in: 1..<5))
            }
            return results
    }
    
    func exampleAllSurveyDict() -> [Int:Int] {
        var results = [Int: Int]()
            for key in 0..<testCount {
                results[key] = (Int.random(in: 1..<5))
            }
            return results
    }

}

#if DEBUG
extension TestingInformation {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: TestingInformation

        var testCount: Int { target.testCount }

        var testInfoArray: [TestQuestion] { target.testInfoArray }

        func createTestingSurveyQuestion() -> [TestQuestion] { target.createTestingSurveyQuestion() }

        func exampleSurveyList() -> [Int:Int] { target.exampleSurveyList() }

        func exampleAllSurveyDict() -> [Int:Int] { target.exampleAllSurveyDict() }
    }
}
#endif