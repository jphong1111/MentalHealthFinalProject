//
//  HomeTabBarController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/11/24.
//

import Foundation
import UIKit
import Combine

final class HomeTabBarController: BaseTabBarController {
    var homeSectionViewController: HomeSectionViewController!
    var dayViewController: DayViewController!
    let imageUpdatePublisher = PassthroughSubject<UIImage, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkOnboarding()
        let customTabBar = HomeTabBar()
        setValue(customTabBar, forKey: "tabBar")

        setRootViewControllers()
   }

    private func setRootViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //MARK: Configure Home
        let homeSectionVC = UINavigationController(rootViewController: HomeSectionViewController())
        homeSectionVC.tabBarItem = SoliUITabBarItem(key: .home, image: ImageAsset.homeTab.image.withTintColor(SoliUColor.tabUnselected).resizeTo(width: 30, height: 30), selectedImage: ImageAsset.homeTab.image.resizeTo(width: 30, height: 30))
        
        //MARK: Configure DayView
        let dayVC = UINavigationController(rootViewController: storyboard.instantiateViewController(identifier: "DayViewController") as! DayViewController)
        dayVC.tabBarItem = SoliUITabBarItem(key: .day, image: ImageAsset.dayTab.image.resizeTo(width: 35, height: 35), selectedImage: ImageAsset.dayTab.image.withTintColor(SoliUColor.newSoliuBlue).resizeTo(width: 35, height: 35))
        if let dayViewController = dayVC.viewControllers.first as? DayViewController {
            self.dayViewController = dayViewController
            self.dayViewController.imageUpdatePublisher = self.imageUpdatePublisher
        }
        
        //MARK: Configure Account
        let accountVC = UINavigationController(rootViewController: storyboard.instantiateViewController(identifier: "AccountHomeViewController") as! AccountHomeViewController)
        accountVC.tabBarItem = SoliUITabBarItem(key: .account, image: ImageAsset.accountTab.image.resizeTo(width: 30, height: 30), selectedImage: ImageAsset.accountTab.image.withTintColor(SoliUColor.newSoliuBlue).resizeTo(width: 30, height: 30))
        //Note: Setting up the viewcontrollers in TabBar
        self.viewControllers = [homeSectionVC, dayVC, accountVC]
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    
        if let homeVC = homeSectionVC.viewControllers.first as? HomeSectionViewController {
            homeVC.imageUpdatePublisher = self.imageUpdatePublisher
        }
    }

    func checkOnboarding() {
        let hasSeenOnboarding = PreferenceStorage.shared.isOnBoardingSeen()
        if !hasSeenOnboarding {
            PreferenceStorage.shared.setOnBoardingPreference(true)
            presentOnboarding()
        }
    }
    
    private func presentOnboarding() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.modalPresentationStyle = .fullScreen
        self.present(onboardingVC, animated: true, completion: nil)
    }
}

extension HomeTabBarController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navigationController = self.navigationController,
           navigationController.viewControllers.last is HomeTabBarController {
            return false
        }
        return true
    }
}

#if DEBUG
extension HomeTabBarController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: HomeTabBarController

        var homeSectionViewController: HomeSectionViewController! { target.homeSectionViewController }

        var dayViewController: DayViewController! { target.dayViewController }

        func checkOnboarding() { target.checkOnboarding() }
    }
}
#endif
