//
//  ContentViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 3/17/25.
//

import UIKit

struct OnboardingContent {
    let imageName: String
    let title: String
    let boldWords: [String]
    let description: String
}

final class ContentViewController: BaseViewController {
    var pageIndex: Int = 0
    let totalPages: Int = 6
    var pageData: OnboardingContent?
    var onNext: (() -> Void)?
    var onSkip: (() -> Void)?
     
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = SoliUFont.regular20
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = SoliUFont.regular12
        label.textColor = UIColor(hex: "#464646")
        return label
    }()

    private lazy var skipButton: SoliUButton = {
        let button = SoliUButton()
        let attributedString = NSAttributedString(string: "Skip", attributes: [
            .font: SoliUFont.regular16,
            .foregroundColor: UIColor(hex: "#545454"),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: SoliUButton = {
        let button = SoliUButton()
        let nextText = NSMutableAttributedString(string: "Next ", attributes: [
            .font: SoliUFont.black16,
            .foregroundColor: UIColor(hex: "#545454")
        ])
        let arrowAttachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        arrowAttachment.image = UIImage(systemName: "chevron.right", withConfiguration: config)?.withTintColor(UIColor(hex: "#545454"))
        let arrowString = NSAttributedString(attachment: arrowAttachment)
        nextText.append(arrowString)
        
        button.setAttributedTitle(nextText, for: .normal)
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        guard let data = pageData else { return }
        
        imageView.image = UIImage(named: data.imageName)
        titleLabel.attributedText = createBoldedText(fullText: data.title, boldWords: data.boldWords)
        descriptionLabel.text = data.description
        updateNextButtonTitle()
        view.addSubView([imageView, titleLabel, descriptionLabel, skipButton, nextButton])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func updateNextButtonTitle() {
        let buttonText = (pageIndex == totalPages - 1) ? "Get Started " : "Next "
        let nextText = NSMutableAttributedString(string: buttonText, attributes: [
            .font: SoliUFont.black16,
            .foregroundColor: UIColor(hex: "#545454")
        ])
        let arrowAttachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        arrowAttachment.image = UIImage(systemName: "chevron.right", withConfiguration: config)?.withTintColor(UIColor(hex: "#545454"))
        let arrowString = NSAttributedString(attachment: arrowAttachment)
        nextText.append(arrowString)
        
        nextButton.setAttributedTitle(nextText, for: .normal)
    }

    private func createBoldedText(fullText: String, boldWords: [String]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: SoliUFont.regular20
        ])
        
        for boldWord in boldWords {
            let range = (fullText as NSString).range(of: boldWord)
            if range.location != NSNotFound {
                attributedString.addAttributes([
                    .font: SoliUFont.bold20,
                    .foregroundColor: SoliUColor.newSoliuBlue
                ], range: range)
            }
        }
        return attributedString
    }

    @objc private func nextTapped() {
        onNext?()
    }
    
    @objc private func skipTapped() {
        onSkip?()
    }
}

#if DEBUG
extension ContentViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: ContentViewController

        var pageIndex: Int { target.pageIndex }

        var pageData: OnboardingContent? { target.pageData }

        var onNext: (() -> Void)? { target.onNext }

        var onSkip: (() -> Void)? { target.onSkip }

        var imageView: UIImageView { target.imageView }

        var titleLabel: UILabel { target.titleLabel }

        var descriptionLabel: UILabel { target.descriptionLabel }

        var skipButton: SoliUButton { target.skipButton }

        var nextButton: SoliUButton { target.nextButton }

    }
}
#endif
