//
//  Error+Extension.swift
//  MentalHealth
//
//  Created by Yoon on 5/21/24.
//

import Foundation

enum CustomError: Error {
    case emptyEmail
    case emptyPassword
    case userIDCheckFailed(String)
    case userIDDoesNotExist
    case signInFailed(String)
    case fetchingUserInfoError
    case fetchingTestScoreFails
    case addSurveyResultFails
    case generateAdviceFails
    case parsingFails
    case saveAdviceFails
    
    var localizedDescription: String {
        switch self {
        case .emptyEmail:
            return "Email cannot be empty."
        case .emptyPassword:
            return "Password cannot be empty."
        case .userIDCheckFailed(let message):
            return "User ID Check Error: \(message)"
        case .userIDDoesNotExist:
            return "User ID does not exist."
        case .signInFailed(let message):
            return "\(message)"
        case .fetchingUserInfoError:
            return "Fail to Fatching Information"
        case .fetchingTestScoreFails:
            return "Unable to retrieve test scores at this time.\nPlease check your connection and try again."
        case .addSurveyResultFails:
            return "Unable to save your survey result at this time.\nPlease try again later."
        case .generateAdviceFails:
            return "Failed to generate AI advice. We’re sorry for the inconvenience. Please try again."
        case .parsingFails:
            return "Unable to load"
        case .saveAdviceFails:
            return "Unable to save advice."
        }
    }
}

