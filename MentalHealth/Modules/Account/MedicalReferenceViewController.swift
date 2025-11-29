//
//  MedicalReferenceViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 8/8/24.
//

import Foundation
import UIKit

final class MedicalReferenceViewController: BaseViewController {
    private lazy var referenceTextView: UITextView = {
        let referenceTextView = UITextView()
        referenceTextView.isEditable = false  // Make sure the text view is not editable
        referenceTextView.isSelectable = true  // Enable link interactions
        referenceTextView.dataDetectorTypes = .link  // Allow links to be detected and clickable
        referenceTextView.backgroundColor = SoliUColor.homepageBackground  // Adjust background color if needed
        return referenceTextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomBackNavigationButton()
        setNavigationTitle(title: .localized(.medicalReference))
        self.view.backgroundColor = SoliUColor.homepageBackground
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        view.addSubView(referenceTextView)
        
        NSLayoutConstraint.activate([
            referenceTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SoliUSpacing.space16),
            referenceTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -SoliUSpacing.space32),
            referenceTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: SoliUSpacing.space16),
            referenceTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -SoliUSpacing.space16),
            ])

        referenceTextView.attributedText = .medicalReferenceCitationText()
    }
}

#if DEBUG
extension MedicalReferenceViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: MedicalReferenceViewController

        var referenceTextView: UITextView { target.referenceTextView }

        func setupUI() { target.setupUI() }
    }
}
#endif
