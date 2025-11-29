//
//  GridSection.swift
//  MentalHealth
//
//  Created by JungpyoHong on 12/22/24.
//

import Foundation
import UIKit

extension GridSectionViewController: SectionRegisterable {
    static var identifier: SectionIdentifier { return .grid }
}
public final class GridSectionViewController2: BaseSectionViewController {
    private let tiles: [GridTile]   // 반드시 2개

    public init(tiles: [GridTile]) {
        precondition(tiles.count == 2, "GridSectionViewController needs exactly 2 tiles.")
        self.tiles = tiles
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
}

public final class GridSectionViewController: BaseSectionViewController {
    // Views to switch
    let selfTestView = UIView()
    let counselorView = UIView()
    let viewThree = UIView()

    // Horizontal stack view
    var stackView: UIStackView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStackView()
        //Not like other SectionViewController, GridSection needs to set View sine its contain two other views
        view.backgroundColor = SoliUColor.newSoliuLightGray
        tapAction(selfTestView, selector: #selector(displaySurveyListViewController))
        tapAction(counselorView, selector: #selector(displayMyDiaryViewController))
    }

    // Set up initial views (e.g., colors and content)
    func setupViews() {
        // Configure selfTestView
        selfTestView.backgroundColor = .white
        selfTestView.layer.cornerRadius = 24

        let labelOne = createLabel(text: .localized(.selfTest))
        let imageselfTestView = createImageView(imageName: "Icon/newSelfTest")

        selfTestView.addSubview(labelOne)
        selfTestView.addSubview(imageselfTestView)
        //Note(Ticket1)
        selfTestView.layer.borderColor = UIColor(hex: "CBCBCB").cgColor
        selfTestView.layer.borderWidth = 1
        selfTestView.layer.shadowColor = SoliUColor.newShadowColor.cgColor
        selfTestView.layer.shadowOpacity = 0.2
        selfTestView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        NSLayoutConstraint.activate([
            labelOne.topAnchor.constraint(equalTo: selfTestView.topAnchor, constant: SoliUSpacing.space16),
            labelOne.leadingAnchor.constraint(equalTo: selfTestView.leadingAnchor, constant: SoliUSpacing.space16),
            imageselfTestView.centerXAnchor.constraint(equalTo: selfTestView.centerXAnchor),
            imageselfTestView.centerYAnchor.constraint(equalTo: selfTestView.centerYAnchor)
        ])

        // Configure counselorView
        counselorView.backgroundColor = .white
        counselorView.layer.cornerRadius = 24
        //Note(Ticket1)
        counselorView.layer.borderColor = UIColor(hex: "CBCBCB").cgColor
        counselorView.layer.borderWidth = 1
        counselorView.layer.shadowColor = SoliUColor.newShadowColor.cgColor
        counselorView.layer.shadowOpacity = 0.2
        counselorView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        
        let labelTwo = createLabel(text: .localized(.aiCounselorHome))
        let imagecounselorView = createImageView(imageName: "Icon/counselor")

        counselorView.addSubview(labelTwo)
        counselorView.addSubview(imagecounselorView)

        NSLayoutConstraint.activate([
            labelTwo.topAnchor.constraint(equalTo: counselorView.topAnchor, constant: SoliUSpacing.space16),
            labelTwo.leadingAnchor.constraint(equalTo: counselorView.leadingAnchor, constant: SoliUSpacing.space16),
            imagecounselorView.centerXAnchor.constraint(equalTo: counselorView.centerXAnchor),
            imagecounselorView.centerYAnchor.constraint(equalTo: counselorView.centerYAnchor)
        ])

        // Configure viewThree
        viewThree.backgroundColor = .systemGreen
        viewThree.layer.cornerRadius = 24

        let labelThree = createLabel(text: "Another View")
        let imageViewThree = createImageView(imageName: "exampleImageThree")

        viewThree.addSubview(labelThree)
        viewThree.addSubview(imageViewThree)

        NSLayoutConstraint.activate([
            labelThree.topAnchor.constraint(equalTo: viewThree.topAnchor, constant: SoliUSpacing.space16),
            labelThree.leadingAnchor.constraint(equalTo: viewThree.leadingAnchor, constant: SoliUSpacing.space16),
            imageViewThree.centerXAnchor.constraint(equalTo: viewThree.centerXAnchor),
            imageViewThree.centerYAnchor.constraint(equalTo: viewThree.centerYAnchor)
        ])
    }

    // Set up the stack view
    func setupStackView() {
        stackView = UIStackView(arrangedSubviews: [selfTestView, counselorView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = SoliUSpacing.space8

        view.addSubView(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 40) / 2)
        ])
    }

    // Switch views in the stack view
    public func switchViews(newView: UIView, at index: Int) {
        guard index < stackView.arrangedSubviews.count else { return }

        let oldView = stackView.arrangedSubviews[index]
        stackView.removeArrangedSubview(oldView)
        oldView.removeFromSuperview()

        stackView.insertArrangedSubview(newView, at: index)
    }

    // Helper function to create labels
    func createLabel(text: String) -> SoliULabel {
        let label = SoliULabel()
        label.text = text
        label.textColor = .black
        label.font = SoliUFont.medium16
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    // Helper function to create image views
    func createImageView(imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    //Navigation function, problem with navigating without tab bar
    
    @objc
    func displaySurveyListViewController(_ sender: Any) {
        navigate(to: SurveyEntryViewController.self, hidesBottomBarWhenPushed: true)
    }
    
    @objc
    func displayMyDiaryViewController(_ sender: Any) {
        navigate(to: MyDiaryViewController.self, storyboardName: "MyDiaryFlow", hidesBottomBarWhenPushed: true)
    }
    
}

#if DEBUG
extension GridSectionViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: GridSectionViewController

        var stackView: UIStackView! { target.stackView }

        func setupViews() { target.setupViews() }

        func setupStackView() { target.setupStackView() }

        func createLabel(text: String) -> SoliULabel {
            target.createLabel(text: text)
        }

        func createImageView(imageName: String) -> UIImageView {
            target.createImageView(imageName: imageName)
        }
    }
}
#endif
