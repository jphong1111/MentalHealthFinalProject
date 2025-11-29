//
//  FBNetworkLayer.swift
//  MentalHealth
//
//  Created by Yoon on 3/9/24.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import UIKit


enum Environment {
    case local
    case production
    
    var baseURL: String {
        switch self {
        case .local:
            return "http://127.0.0.1:8000"
        case .production:
            return "https://soliu.net"
        }
    }
}

final class FBNetworkLayer {
    static let shared = FBNetworkLayer()
    var authProvider: AuthProviding
    var analytics: AnalyticsLogging
    var userInfoFetcher: UserInfoFetching

    var ref: DatabaseReference!
    var db: Firestore!
    var environment: Environment!
    
    private init(environment: Environment = .production,
                 authProvider: AuthProviding = FirebaseAuthProvider(),
                 analytics: AnalyticsLogging = FirebaseAnalyticsLogger(),
                 userInfoFetcher: UserInfoFetching = FirebaseUserInfoFetcher()) {
        self.environment = environment
        self.authProvider = authProvider
        self.analytics = analytics
        self.userInfoFetcher = userInfoFetcher
        self.ref = Database.database().reference()
        self.db = Firestore.firestore()
    }
    
    func configureDependencies(auth: AuthProviding? = nil,
                               analytics: AnalyticsLogging? = nil,
                               userInfoFetcher: UserInfoFetching? = nil) {
        if let auth { self.authProvider = auth }
        if let analytics { self.analytics = analytics }
        if let userInfoFetcher { self.userInfoFetcher = userInfoFetcher }
    }

    func getCurrentTimeZone() -> String {
        let currentTimeZone = TimeZone.current
        let timeZoneIdentifier = currentTimeZone.identifier
        return timeZoneIdentifier
    }
    
    func checkDuplicateEmail(email: String, completion: @escaping (Bool, Error?) -> Void) {
        // Construct URL with email in the path
        guard let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(environment.baseURL)/api/check_duplicate_email/?email=\(encodedEmail)") else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                completion(false, NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error: checkDuplicateEmail"]))
                return
            }
            
            guard let data = data else {
                completion(false, NSError(domain: "DataError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Data not found: checkDuplicateEmail"]))
                return
            }
            
            do {
                let checkIDResponse = try JSONDecoder().decode(CheckIDResponse.self, from: data)
                completion(checkIDResponse.isDuplicate, nil)
            } catch {
                completion(false, error)
            }
        }
        
        task.resume()
    }
    
    func logIn(email: String, password: String) async -> Result<UserInformation?, CustomError> {
        do {
            try await authProvider.signIn(email: email, password: password)

            let userInfo = try await userInfoFetcher.getUserInformation(email: email)
            LoginManager.shared.loginSucessFetchInformation(userInformation: userInfo)

            analytics.logEvent("sign_in_success", parameters: [
                "uuid": LoginManager.shared.hashedUUID(for: email),
                "timestamp": Date().timeIntervalSince1970
            ])
            analytics.setUserProperty("false", forName: "is_guest_user")
            LoginManager.shared.setLoggedIn(true)

            return .success(nil)

        } catch let error as CustomError {
            analytics.logEvent("sign_in_failed", parameters: [
                "uuid": LoginManager.shared.hashedUUID(for: email),
                "error_type": "CustomError",
                "error_description": error.localizedDescription,
                "timestamp": Date().timeIntervalSince1970
            ])
            return .failure(error)

        } catch {
            let nsError = error as NSError
            let errorMessage: String
            if nsError.domain == AuthErrorDomain {
                errorMessage = "No account found with the provided credentials."
            } else {
                errorMessage = "We encountered an issue while retrieving your account details.\nPlease try again later."
            }

            analytics.logEvent("sign_in_failed", parameters: [
                "uuid": LoginManager.shared.hashedUUID(for: email),
                "error_type": nsError.domain,
                "error_code": nsError.code,
                "error_description": error.localizedDescription,
                "timestamp": Date().timeIntervalSince1970
            ])

            LoginManager.shared.setLoggedIn(false)
            return .failure(.signInFailed(errorMessage))
        }
    }

    
    func getAdvice(userConcernInput: String, disorder: String? = nil, completion: @escaping (Result<String, CustomError>) -> Void) {
        let urlString = "\(environment.baseURL)/api/get_advice/"
        guard let url = URL(string: urlString) else {
            completion(.failure(.generateAdviceFails))
            return
        }
        
        guard !userConcernInput.isEmpty else {
            completion(.failure(.generateAdviceFails))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "userConcernInput": userConcernInput,
            "disorder": disorder ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(.generateAdviceFails))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.generateAdviceFails))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.generateAdviceFails))
                return
            }

            guard let data = data else {
                completion(.failure(.generateAdviceFails))
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let advice = jsonResponse["response"] as? String {
                    completion(.success(advice))
                } else {
                    completion(.failure(.generateAdviceFails))
                }
            } catch {
                completion(.failure(.parsingFails))
            }
        }
        task.resume()
    }
    
    
    func getAverageScore(completion: @escaping (Result<TestAverage, CustomError>) -> Void) {
        let urlString = "\(environment.baseURL)/api/get_average_score/"
        guard let url = URL(string: urlString) else {
            completion(.failure(.fetchingTestScoreFails))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.fetchingTestScoreFails))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.fetchingTestScoreFails))
                return
            }
            
            guard let data = data else {
                completion(.failure(.fetchingTestScoreFails))
                return
            }
            
            do {
                let testInfo = try JSONDecoder().decode(TestAverage.self, from: data)
                completion(.success(testInfo))
            } catch {
                completion(.failure(.fetchingTestScoreFails))
            }
        }
        
        task.resume()
    }
    
    func saveAdvice(adviceItem: AdviceItem, completion: @escaping (CustomError?) -> Void) {
        if !LoginManager.shared.isLoggedIn() {
            return
        }
        guard let url = URL(string: "\(environment.baseURL)/api/save_advice/") else {
            completion(.saveAdviceFails)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestData: [String: Any] = [
            "email": LoginManager.shared.getEmail(),
            "MyDiaryItem": adviceItem.toDictionary()
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestData, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.saveAdviceFails)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.saveAdviceFails)
                return
            }
            
            guard let data = data else {
                completion(.saveAdviceFails)
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let errorMessage = jsonResponse["error"] as? String {
                        _ = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.saveAdviceFails)
                    } else {
                        completion(nil)
                    }
                } else {
                    _ = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    completion(.parsingFails)
                }
            } catch {
                completion(.saveAdviceFails)
            }
        }
        task.resume()
    }
    
    func getUserInformation(email: String) async throws -> UserInformation {
        let urlString = "\(environment.baseURL)/api/get_user_information/\(email)/"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: getUserInformation"])
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            throw NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error: getUserInformation"])
        }

        do {
            let userInfo = try JSONDecoder().decode(UserInformation.self, from: data)
            return userInfo
        } catch {
            print("Decoding error:", error.localizedDescription)
            throw error
        }
    }

    
    func fetchMyDay(userInformation: UserInformation, myDay: MyDay, completion: @escaping (Error?) -> Void) {
        if !LoginManager.shared.isLoggedIn() {
            return
        }

        let urlString = "\(environment.baseURL)/api/fetch_my_day/"
        guard let url = URL(string: urlString) else {
            completion(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        // Create the request body
        let requestBody: [String: Any] = [
            "email": userInformation.email,
            "myDayData": [
                "date": myDay.date,
                "myMood": myDay.myMood.rawValue,
                "isDetoxed": myDay.isDetoxed ?? ""
            ],
            "timeZone": self.getCurrentTimeZone()
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            // Create the URLRequest object
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Create the URLSession data task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"]))
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    completion(nil)
                } else {
                    let statusCode = httpResponse.statusCode
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    completion(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorDescription]))
                }
            }
            
            // Start the task
            task.resume()
            
        } catch {
            completion(error)
        }
    }
    
    func add_feedback(feedback: String, completion: @escaping(Error?) -> Void) {
        let urlString = "\(environment.baseURL)/api/add_feedback/"
        let deviceModel = UIDevice.current.model
        guard let url = URL(string: urlString) else {
            completion(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        // Create the request body
        let requestBody: [String: Any] = [
            "email": LoginManager.shared.getEmail(),
            "feedback": feedback,
            "deviceModel": deviceModel,
            "timestamp": Date().toDefaultDateFormat()
        ]
        
        // Serialize the request body to JSON data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            // Create the URLRequest object
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Create the URLSession data task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"]))
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    completion(nil)
                } else {
                    let statusCode = httpResponse.statusCode
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    completion(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorDescription]))
                }
            }
            
            task.resume()
            
        } catch {
            completion(error)
        }
    }

    func addSurvey(userInfomration: UserInformation, newSurveyResult: SurveyResult, completion: @escaping (CustomError?) -> Void) {
        let urlString = "\(environment.baseURL)/api/save_survey_result/"
        guard let url = URL(string: urlString) else {
            completion(.addSurveyResultFails)
            return
        }
        
        // Create the request body
        let requestBody: [String: Any] = [
            "email": userInfomration.email,
            "surveyDate": newSurveyResult.surveyDate,
            "surveyAnswer": newSurveyResult.surveyAnswer
        ]
        
        // Serialize the request body to JSON data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            // Create the URLRequest object
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Create the URLSession data task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion(.addSurveyResultFails)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.addSurveyResultFails)
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    completion(nil)
                } else {
                    completion(.addSurveyResultFails)
                }
            }
            
            // Start the task
            task.resume()
            
        } catch {
            completion(.addSurveyResultFails)
        }
    }

    func createAccount(email: String, completion: @escaping (Error?) -> Void) {
        let email = LoginManager.shared.getUserInfo().email
        
        // Retrieve the password securely from Keychain
        guard let password = KeychainHelper.shared.getPassword(for: email) else {
            print("Error: Password not found in Keychain")
            let keychainError = NSError(
                domain: "KeychainError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Password not found in Keychain"]
            )
            completion(keychainError)
            return
        }
        
        // Create a new user in Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Firebase Auth Error:", error.localizedDescription)
                completion(error)
            } else if let user = authResult?.user {
                print("Successfully created user with UID:", user.uid)
                completion(nil)
            } else {
                let unexpectedError = NSError(
                    domain: "AuthError",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Unexpected error during account creation"]
                )
                print("Unexpected error: No auth result and no error")
                completion(unexpectedError)
            }
        }
    }

    
    func checkEmailExists(email: String, completion: @escaping (Bool, Error?) -> Void) {
        db.collection("EmailList").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(false, error)
            } else {
                if let documents = querySnapshot?.documents, documents.count > 0 {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            }
        }
    }
    
    func addEmailToList(email: String, completion: @escaping (Error?) -> Void) {
        let emailData: [String: Any] = ["email": email]
        db.collection("EmailList").addDocument(data: emailData) { error in
            completion(error)
        }
    }
    
    func createUserInformation(userInfo: UserInformation, completion: @escaping (Error?) -> Void) {
        let userData: [String: Any] = [
            "uuid": LoginManager.shared.hashedUUID(for: userInfo.email),
            "demographicInformation": [
                "email": userInfo.email,
                "gender": userInfo.gender,
                "work_status" : userInfo.workStatus,
                "ethnicity": userInfo.ethnicity,
                "age": userInfo.age,
                "nickname": userInfo.nickName
            ],
            "surveyResultsList": [],
            "dailyMoodList" : [],
            "adviceItemList" : [],
            "progressStar" : 0,
            "accountCreatedDate": Date().toDefaultDateFormat()
        ]
        
        db.collection("Users").addDocument(data: userData) { error in
            if let error = error {
                completion(error)
                print(error)
            } else {
                completion(nil)
            }
        }
    }
}

//Using inside Demographic Detail ViewController to update demographics
enum DemographicKey {
    case workStatus(WorkStatus)
    case ethnicity(Ethnicity)
    case age(Int)
    case nickname(String)
    case gender(Gender)
}

extension FBNetworkLayer {
    func updateUserDemographics(
        email: String,
        updates: [DemographicKey],
        completion: @escaping (Error?) -> Void
    ) {
        guard !updates.isEmpty else {
            completion(nil)
            return
        }
        
        var updateDict: [String: Any] = [:]
        
        for key in updates {
            switch key {
            case .workStatus(let workStatus):
                updateDict["demographicInformation.work_status"] = workStatus.rawValue
            case .ethnicity(let ethnicity):
                updateDict["demographicInformation.ethnicity"] = ethnicity.rawValue
            case .age(let age):
                updateDict["demographicInformation.age"] = "\(age)"
            case .nickname(let nickname):
                updateDict["demographicInformation.nickname"] = nickname
            case .gender(let gender):
                updateDict["demographicInformation.gender"] = gender.rawValue
            }
        }
        
        db.collection("Users")
            .whereField("demographicInformation.email", isEqualTo: email)
            .limit(to: 1)
            .getDocuments { [weak self] snapshot, error in
                guard self != nil else { return }
                
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let doc = snapshot?.documents.first else {
                    completion(NSError(domain: "Firestore",
                                       code: 404,
                                       userInfo: [NSLocalizedDescriptionKey: "User document not found"]))
                    return
                }
                
                doc.reference.updateData(updateDict) { error in
                    completion(error)
                }
            }
    }
}

extension Auth {
    func signInAsync(withEmail email: String, password: String) async throws -> AuthDataResult {
        return try await withCheckedThrowingContinuation { continuation in
            self.signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result {
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
}
