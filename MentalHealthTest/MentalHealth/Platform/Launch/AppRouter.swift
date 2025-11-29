//
//  AppRouter.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/1/25.
//

import Foundation
import UIKit

final class AppRouter {
    private let window: UIWindow
    private let authGate = AuthGate()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
        
        #if DEBUG
        DebugPanelInstaller.install(on: window)
        #endif
        Task { @MainActor in
            let dest = await authGate.decideStartDestination()
            switch dest {
            case .home:  setRoot(makeHome())
            case .login: setRoot(makeLogin())
            }
        }
    }
    
    @MainActor
    private func setRoot(_ vc: UIViewController) {
        UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.window.rootViewController = vc.embedInNavIfNeeded()
        })
    }

    private func makeLogin() -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        guard let vc = sb.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController else {
            fatalError("Storyboard ID 'LogInViewController' 확인 필요")
        }
        return vc
    }
    
    private func makeHome() -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        return sb.instantiateViewController(withIdentifier: "HomeTabBarController")
    }
}

private extension UIViewController {
    func embedInNavIfNeeded() -> UIViewController {
        if self is UINavigationController { return self }
        return UINavigationController(rootViewController: self)
    }
}
