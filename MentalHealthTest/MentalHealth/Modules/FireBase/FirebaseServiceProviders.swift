//
//  FirebaseServiceProviders.swift
//  MentalHealth
//
//  Created by JungpyoHong on 9/30/25.
//

import FirebaseAuth
import FirebaseAnalytics

//This is for Dependency Injection of Firebase Services
protocol AuthProviding {
    func signIn(email: String, password: String) async throws
}

protocol AnalyticsLogging {
    func logEvent(_ name: String, parameters: [AnalyticsKey: Any]?)
    func setUserProperty(_ value: String?, forName name: String)
}

protocol UserInfoFetching {
    func getUserInformation(email: String) async throws -> UserInformation
}

struct FirebaseAuthProvider: AuthProviding {
    func signIn(email: String, password: String) async throws {
        _ = try await Auth.auth().signInAsync(withEmail: email, password: password)
    }
}

struct FirebaseAnalyticsLogger: AnalyticsLogging {
    func logEvent(_ name: String, parameters: [AnalyticsKey : Any]?) {
        SoliUAnalytics.logEvent(name, parameters: parameters)
    }
    func setUserProperty(_ value: String?, forName name: String) {
        SoliUAnalytics.setUserProperty(value, forName: name)
    }
}

struct FirebaseUserInfoFetcher: UserInfoFetching {
    func getUserInformation(email: String) async throws -> UserInformation {
        return try await FBNetworkLayer.shared.getUserInformation(email: email)
    }
}
