//
//  SceneDelegate.swift
//  MentalHealth
//
//  Created by JungpyoHong on 2/3/24.
//

import UIKit
import SwiftEntryKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var sessionStartTime: Date?
    var router: AppRouter!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        router = AppRouter(window: window)
        router.start()
    }
//    
//    private func showAlert(title: String, description: String) {
//        var attributes = EKAttributes.topFloat
//        attributes.entryBackground = .color(color: .white)
//        attributes.displayDuration = 3
//        attributes.statusBar = .dark
//        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
//        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)
//        
//        let title = EKProperty.LabelContent(text: title, style: .init(font: SoliUFont.bold14, color: .black))
//        let description = EKProperty.LabelContent(text: description, style: .init(font: SoliUFont.regular14, color: .black))
//        let image = EKProperty.ImageContent(image: ImageAsset.soliuLogoOnly.image, size: CGSize(width: 40, height: 40))
//        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
//        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
//        let contentView = EKNotificationMessageView(with: notificationMessage)
//        
//        SwiftEntryKit.display(entry: contentView, using: attributes)
//    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        sessionStartTime = Date()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        guard let start = sessionStartTime else { return }
        let sessionDuration = Date().timeIntervalSince(start) / 60
        let previousTotal = UserDefaults.standard.double(forKey: "totalAppUsageMinutes")
        UserDefaults.standard.set(previousTotal + sessionDuration, forKey: "totalAppUsageMinutes")
    }
}
