//
//  WeeklyMoodSection.swift
//  MentalHealth
//
//

import Foundation
import UIKit
import Combine

// Note: Each Section Needs to conform to SectionRegisterable to get a unique id
extension WeeklyMoodSectionViewController: SectionRegisterable {
    static var identifier: SectionIdentifier { return .weeklyMood }
}

final class WeeklyMoodSectionViewController: BaseSectionViewController {
    private var cancellables = Set<AnyCancellable>()

    private lazy var titleLabel: SoliULabel = {
        let titleLabel = SoliULabel()
        titleLabel.text = .localized(.weeklyMoodLog)
        titleLabel.font = SoliUFont.medium14
        titleLabel.textColor = .black
        return titleLabel
    }()

    private lazy var moodLogSectionView: WeeklyMoodLogSectionView = {
        let moodLogView = WeeklyMoodLogSectionView()
        return moodLogView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupView()
    }

    override func injectDependencies(_ dependencies: [InjectableDependency]) {
        dependencies.forEach { dependency in
            if let imageDependency = dependency as? ImageUpdatePublisher {
                setupImageSubscriber(publisher: imageDependency.publisher)
            }
        }
    }
    private func setupImageSubscriber(publisher: PassthroughSubject<UIImage, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newImage in
                print(newImage.className)
                self?.moodLogSectionView.updateImageForToday(image: newImage)
            }
            .store(in: &cancellables)
    }

    private func setupView() {
        view.addSubView([titleLabel, moodLogSectionView])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            moodLogSectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            moodLogSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            moodLogSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            moodLogSectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

#if DEBUG
extension WeeklyMoodSectionViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: WeeklyMoodSectionViewController

        var titleLabel: SoliULabel { target.titleLabel }

        var moodLogSectionView: WeeklyMoodLogSectionView { target.moodLogSectionView }
    }
}
#endif
