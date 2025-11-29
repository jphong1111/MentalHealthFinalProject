//
//  HomeSectionViewController.swift
//  MentalHealth
//
//

import Foundation
import UIKit
import Combine

// MARK: - Home View Controller
final class HomeSectionViewController: BaseViewController {
    var imageUpdatePublisher: PassthroughSubject<UIImage, Never>?

    private let sectionFactory = SectionFactory()
    // Based on the Identifiers, we can make it dynamically based on the hard coded or BE response
    private var sectionIdentifiers: [SectionIdentifier] = [
        QuoteSectionViewController.identifier,
        WeeklyMoodSectionViewController.identifier,
        GridSectionViewController.identifier,
        ChartSectionViewController.identifier,
        //MeditationSectionViewController.identifier
    ]
    private var hasShownScrollFooter = false

    // MARK: - ScrollView and StackView
    private lazy var scrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = SoliUSpacing.space8
        return stack
    }()

    private lazy var usageStatsLabel: SoliULabel = {
        let label = SoliULabel()
        label.font = SoliUFont.medium14
        label.textColor = SoliUColor.soliuBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SoliUColor.newSoliuLightGray
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        
        setupScrollView()
        setupDynamicSections()

        if LoginManager.shared.isLoggedIn() {
            showAlert(
                title: "\(String.localized(.welcome)) \(LoginManager.shared.getNickName())",
                description: String.localized(.welcomeDescription)
            )
        } else {
            showAlert(
                title: "\(String.localized(.welcome)) \(String.localized(.guest))",
                description: String.localized(.welcomeDescription)
            )
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if LoginManager.shared.isLoggedIn(){
            refreshUserInformation()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - ScrollView Setup
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubView(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubView(stackView)
        
//        scrollView.addSubView(usageStatsLabel)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: SoliUSpacing.space16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -SoliUSpacing.space16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SoliUSpacing.space8),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -SoliUSpacing.space32), // Prevent horizontal scroll

//            usageStatsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            usageStatsLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 24)
        ])
    }

    // MARK: - Dynamic Section Setup
    // NOTE: - this function will setup dynamic section based on
    // NOTE: - Consider refresh section with BE response
    private func setupDynamicSections() {
        for identifier in sectionIdentifiers {
            guard let sectionVC = sectionFactory.createSection(with: identifier) else { continue }
            // Inject dependencies dynamically
            if identifier == WeeklyMoodSectionViewController.identifier, let publisher = imageUpdatePublisher {
                sectionVC.injectDependencies([ImageUpdatePublisher(publisher: publisher)])
            }

            addChild(sectionVC)
            stackView.addArrangedSubview(sectionVC.view)

            applyStyle(for: sectionVC, identifier: identifier)

            sectionVC.didMove(toParent: self)
        }
        stackView.addArrangedSubview(usageStatsLabel)
    }

    func refreshUserInformation() {
        Task {
            let email = LoginManager.shared.getEmail()

            do {
                let userInfo = try await FBNetworkLayer.shared.getUserInformation(email: email)

                guard LoginManager.shared.isLoggedIn() else { return }

                // UI updates must happen on main thread
                await MainActor.run {
                    LoginManager.shared.loginSucessFetchInformation(userInformation: userInfo)
                    // self.updateUIWithUserInformation(userInfo)
                }
            } catch {
                print("Error fetching user information: \(error.localizedDescription)")
            }
        }
    }
}

extension HomeSectionViewController {
    func applyStyle(for sectionVC: BaseSectionViewController, identifier: SectionIdentifier) {
        if identifier != GridSectionViewController.identifier {
            sectionVC.view.layer.borderColor = UIColor(hex: "CBCBCB").cgColor
            sectionVC.view.layer.borderWidth = 1
            sectionVC.view.layer.cornerRadius = 24
            sectionVC.view.layer.shadowColor = SoliUColor.newShadowColor.cgColor
            sectionVC.view.layer.shadowOpacity = 0.2
            sectionVC.view.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
        // Setup height for each section view
        let height = SectionHeightResolver.height(for: identifier)
        NSLayoutConstraint.activate([
            sectionVC.view.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

extension HomeSectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let maxOffsetY = scrollView.contentSize.height - scrollView.frame.size.height

        if offsetY >= maxOffsetY - 10 {
            // 보여주기
            
            let totalMinutes = UserDefaults.standard.double(forKey: "totalAppUsageMinutes")
            let hours = Int(totalMinutes / 60)
            let minutes = Int(totalMinutes.truncatingRemainder(dividingBy: 60))

            if hours > 0 {
                usageStatsLabel.text = .localized(.usageTime, hours, minutes)
            } else {
                usageStatsLabel.text = .localized(.usageTime, Int(round(totalMinutes)))
            }

            UIView.animate(withDuration: 0.3) {
                self.usageStatsLabel.alpha = 1
            }

            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideUsageStatsLabel), object: nil)
            perform(#selector(hideUsageStatsLabel), with: nil, afterDelay: 2.0)
        } else {
            // 스크롤이 올라오면 바로 숨김
//            UIView.animate(withDuration: 0.3) {
//                self.usageStatsLabel.alpha = 0
//            }
        }
    }

    @objc private func hideUsageStatsLabel() {
        UIView.animate(withDuration: 0.5) {
            self.usageStatsLabel.alpha = 0
        }
    }
}

#if DEBUG
extension HomeSectionViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: HomeSectionViewController

        var imageUpdatePublisher: PassthroughSubject<UIImage, Never>? { target.imageUpdatePublisher }

        var sectionIdentifiers: [SectionIdentifier] { target.sectionIdentifiers }

        func refreshUserInformation() { target.refreshUserInformation() }
    }
}
#endif
