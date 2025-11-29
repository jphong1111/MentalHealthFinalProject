//
//  OnboardingViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 7/6/24.
//

import UIKit

final class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let pages = [
        OnboardingContent(imageName: "Icon/onboarding1", title: "Empower your mind with Quote of the Day", boldWords: ["Quote of the Day"], description: "Embrace the positive energy and make the most of your day!"),
        OnboardingContent(imageName: "Icon/onboarding2", title: "Review your Weekly Mood Log", boldWords: ["Weekly Mood Log"], description: "Log your mood every day and see patterns in your emotions."),
        OnboardingContent(imageName: "Icon/onboarding3", title: "Track your Steps and Mental Health Score!", boldWords: ["Steps", "Mental Health Score"], description: "See your step count and mental health score to see and compare your health and mental status!"),
        OnboardingContent(imageName: "Icon/onboarding4", title: "Take a Self-Test and understand your current state", boldWords: ["Self-Test"], description: "Complete the test every day and take control of your wellness."),
        OnboardingContent(imageName: "Icon/onboarding5", title: "Talk to AI Counselor and get advice!", boldWords: ["AI Counselor"], description: "Ask for questions and tips to improve your physical and mental health."),
        OnboardingContent(imageName: "Icon/onboarding6", title: "Log your mood in Day page", boldWords: ["Day page"], description: "Review your mood log in Calendar and monitor your emotional journey.")
    ]
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = pages.count
        control.currentPage = 0
        control.pageIndicatorTintColor = SoliUColor.newSoliuLightGray
        control.currentPageIndicatorTintColor = SoliUColor.newSoliuBlue
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = getViewController(at: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        setupPageControl()
    }
    
    private func setupPageControl() {
        view.addSubView(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func getViewController(at index: Int) -> ContentViewController? {
        guard index >= 0 && index < pages.count else { return nil }
        
        let contentVC = ContentViewController()
        contentVC.pageIndex = index
        contentVC.pageData = pages[index]
        contentVC.onNext = { [weak self] in self?.goToNextPage() }
        contentVC.onSkip = { [weak self] in self?.dismiss(animated: true, completion: nil) }
        return contentVC
    }
    
    private func goToNextPage() {
        guard let currentVC = viewControllers?.first as? ContentViewController else { return }
        let nextIndex = currentVC.pageIndex + 1
        
        if let nextVC = getViewController(at: nextIndex) {
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
            pageControl.currentPage = nextIndex
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - PageViewController DataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ContentViewController else { return nil }
        return getViewController(at: vc.pageIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ContentViewController else { return nil }
        return getViewController(at: vc.pageIndex + 1)
    }

    // MARK: - PageViewController Delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = viewControllers?.first as? ContentViewController {
            pageControl.currentPage = currentVC.pageIndex
        }
    }
}

#if DEBUG
extension OnboardingViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: OnboardingViewController

        var pageControl: UIPageControl { target.pageControl }
    }
}
#endif
