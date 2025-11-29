//
//  UpdateCheckViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 8/8/24.
//

import Foundation
import UIKit

final class UpdateCheckViewController: BaseViewController {
    private static let soliuAppStoreURL = URL(string: "itms-apps://apps.apple.com/app/soliu/id6535658392")!

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAsset.soliuLogoOnly.image
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var versionLabel: SoliULabel = {
        let versionLabel = SoliULabel()
        versionLabel.text = "\(String.localized(.version)) \(getCurrentAppVersion())"
        versionLabel.textColor = SoliUColor.soliuBlack
        versionLabel.font = SoliUFont.medium16
        versionLabel.textAlignment = .center
        return versionLabel
    }()
    
    private lazy var latestVersionLabel: SoliULabel = {
        let latestVersionLabel = SoliULabel()
        latestVersionLabel.text = "\(String.localized(.latestVersion)) \(getCurrentAppVersion())"
        latestVersionLabel.textColor = SoliUColor.soliuBlack
        latestVersionLabel.font = SoliUFont.medium16
        latestVersionLabel.textAlignment = .center
        return latestVersionLabel
    }()
    
    private lazy var upToDateLabel: SoliULabel = {
        let statusLabel = SoliULabel()
        statusLabel.text = .localized(.youAreUpToDate)
        statusLabel.textColor = SoliUColor.soliuGrey
        statusLabel.font = SoliUFont.bold12
        statusLabel.textAlignment = .center
        return statusLabel
    }()

    private lazy var updateButton: SoliUButton = {
        let updateButton = SoliUButton()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: SoliUFont.bold12,
            .foregroundColor: SoliUColor.homepageNoBackground,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: .localized(.updateAppVerion), attributes: attributes)
        updateButton.setAttributedTitle(attributedTitle, for: .normal)
        return updateButton
    }()
    
    private lazy var slider: UIView = {
        let slider = UIView()
        slider.backgroundColor = SoliUColor.slider
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomBackNavigationButton()
        setNavigationTitle(title: .localized(.update))
        self.view.backgroundColor = SoliUColor.homepageBackground

        addAutoLayoutSubViews([iconView, versionLabel, latestVersionLabel, slider])
        setupView()
        setupUpdateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupView() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            iconView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            iconView.widthAnchor.constraint(equalToConstant: 88),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),

            versionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20),
            versionLabel.topAnchor.constraint(equalTo: iconView.topAnchor),
            
            latestVersionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20),
            latestVersionLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 5),

            slider.heightAnchor.constraint(equalToConstant: 1),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            slider.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 40)
        ])
    }

    private func setupUpdateUI(){
        isCurrentAppVersion { [weak self] isLatest, latestVersion in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let latestVersion {
                    self.latestVersionLabel.text = "\(String.localized(.latestVersion)) \(latestVersion)"
                }
                if isLatest {
                    self.addAutoLayoutSubView(self.upToDateLabel)
                    NSLayoutConstraint.activate([
                        self.upToDateLabel.leadingAnchor.constraint(equalTo: self.iconView.trailingAnchor, constant: 20),
                        self.upToDateLabel.bottomAnchor.constraint(equalTo: self.iconView.bottomAnchor, constant: 0)
                    ])
                } else {
                    self.addAutoLayoutSubView(self.updateButton)
                    self.updateButton.addTarget(self, action: #selector(self.openAppStore), for: .touchUpInside)
                    NSLayoutConstraint.activate([
                        self.updateButton.leadingAnchor.constraint(equalTo: self.iconView.trailingAnchor, constant: 20),
                        self.updateButton.bottomAnchor.constraint(equalTo: self.iconView.bottomAnchor, constant: 0)
                    ])
                }
            }
        }
    }

    private func isCurrentAppVersion(completion: @escaping (Bool, String?) -> Void) {
        fetchLatestAppStoreVersion { latestVersion in
            let current = self.getCurrentAppVersion()
            let store = latestVersion ?? ""

            let isLatest = (current.compareVersion(to: store) == .orderedSame)
            completion(isLatest, latestVersion)
        }
    }
    
    func getCurrentAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown Version"
    }
    
    @objc private func openAppStore() {
        UIApplication.shared.open(UpdateCheckViewController.soliuAppStoreURL)
    }
}

extension UpdateCheckViewController {
    func fetchLatestAppStoreVersion(completion: @escaping (String?) -> Void) {
        //6535658392 is Soliu App Store ID
        let urlString = "https://itunes.apple.com/lookup?id=6535658392"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appInfo = results.first,
                  let version = appInfo["version"] as? String else {
                completion(nil)
                return
            }
            completion(version)
        }.resume()
    }
}

extension String {
    /// 버전을 [Int]로 변환 (예: "1.2.0" -> [1, 2, 0])
    func versionComponents() -> [Int] {
        self.split(separator: ".").map { Int($0) ?? 0 }
    }

    /// 버전 비교 (self가 최신이면 0, 더 높으면 1, 낮으면 -1)
    func compareVersion(to other: String) -> ComparisonResult {
        let lhs = self.versionComponents()
        let rhs = other.versionComponents()
        let maxLength = max(lhs.count, rhs.count)
        for i in 0..<maxLength {
            let l = i < lhs.count ? lhs[i] : 0
            let r = i < rhs.count ? rhs[i] : 0
            if l < r { return .orderedAscending }
            if l > r { return .orderedDescending }
        }
        return .orderedSame
    }
}

#if DEBUG
extension UpdateCheckViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: UpdateCheckViewController

        var iconView: UIImageView { target.iconView }

        var versionLabel: SoliULabel { target.versionLabel }

        var latestVersionLabel: SoliULabel { target.latestVersionLabel }

        var upToDateLabel: SoliULabel { target.upToDateLabel }

        var updateButton: SoliUButton { target.updateButton }

        var slider: UIView { target.slider }

        func setupView() { target.setupView() }

        func openAppStore() { target.openAppStore() }
    }
}
#endif

