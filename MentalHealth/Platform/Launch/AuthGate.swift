//  AuthGate.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/1/25.
//

import Foundation

enum StartDestination {
    case home
    case login
}

final class AuthGate {
    func decideStartDestination() async -> StartDestination {
        let userDefault = UserDefaults.standard

        // 로그인 상태가 아니면 바로 로그인 화면
        guard userDefault.bool(forKey: "isLoggedIn") else {
            return .login
        }
        
        if let email = userDefault.string(forKey: "savedEmail"),
            let password = KeychainHelper.shared.getPassword(for: email),
            !email.isEmpty, !password.isEmpty
        {
            switch await FBNetworkLayer.shared.logIn(email: email, password: password) {
            case .success:
                userDefault.set(true, forKey: "isLoggedIn")
                return .home

            case .failure:
                userDefault.set(false, forKey: "isLoggedIn")
                return .login
            }
        }

        userDefault.set(false, forKey: "isLoggedIn")
        return .login
    }
}
