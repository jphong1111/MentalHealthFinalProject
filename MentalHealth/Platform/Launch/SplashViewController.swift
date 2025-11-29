//
//  SplashViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/1/25.
//

import UIKit

final class SplashViewController: UIViewController {
    private let logoView: UIImageView = {
        let iv = UIImageView(image: ImageAsset.soliuLogo.image)
        iv.contentMode = .scaleAspectFit
        iv.accessibilityIgnoresInvertColors = true
        iv.isAccessibilityElement = true
        iv.accessibilityLabel = "SoliU Logo"
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubView(logoView)

        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 190),
            logoView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
}
