//
//  MeditationSectionViewController.swift
//  MentalHealth
//
//

import UIKit
import AVFoundation

// Note: Each Section Needs to conform to SectionRegisterable to get a unique id
extension MeditationSectionViewController: SectionRegisterable {
    static var identifier: SectionIdentifier { return .meditation }
}

final class MeditationSectionViewController: BaseSectionViewController {
    private lazy var startButton: SoliUButton = {
        let button = SoliUButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("🧘 start Meditation", for: .normal)
        button.titleLabel?.textColor = SoliUColor.newSoliuBlue
        button.titleLabel?.font = SoliUFont.medium16
        button.layer.cornerRadius = 12
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        startButton.addTarget(self, action: #selector(startMeditation), for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubView(startButton)

        NSLayoutConstraint.activate([
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 180),
            startButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func startMeditation() {
        navigate(MeditationViewController(), animated: true)
    }
}
