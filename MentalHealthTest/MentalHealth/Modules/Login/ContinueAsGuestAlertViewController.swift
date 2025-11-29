//
//  ContinueAsGuestAlertViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/5/25.
//

import UIKit
import Foundation

protocol ContinueAsGuestAlertViewControllerDelegate: AnyObject {
    func didConfirmContinueAsGuest()
}

final class ContinueAsGuestAlertViewController: BaseViewController {
    
    weak var delegate: ContinueAsGuestAlertViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupUI()
    }
    
    private func setupUI() {
        let alertView = ContinueAsGuestAlertView()
        alertView.delegate = self
        view.addSubView(alertView)
        
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 300),
            alertView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension ContinueAsGuestAlertViewController: ContinueAsGuestAlertViewDelegate {
    func didTapNotContinueAsGuestButton() {
        dismiss(animated: true, completion: nil)
    }

    func didTapContinueAsGuestButton() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didConfirmContinueAsGuest()
        }
    }
}

#if DEBUG
extension ContinueAsGuestAlertViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: ContinueAsGuestAlertViewController

        func didTapNotContinueAsGuestButton() { target.didTapNotContinueAsGuestButton() }

        func didTapContinueAsGuestButton() { target.didTapContinueAsGuestButton() }
    }
}
#endif
