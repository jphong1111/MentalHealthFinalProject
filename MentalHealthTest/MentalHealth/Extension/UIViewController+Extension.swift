//
//  UIViewController+Extension.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/3/24.
//

import UIKit
import SwiftEntryKit

/// General Extension
extension UIViewController {
    func getCurrentMonthAndDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        let preferredLanguage = SoliULanguageManager.shared.currentLanguage

        dateFormatter.locale = Locale(identifier: preferredLanguage)
        if preferredLanguage == "ko" {
            dateFormatter.dateFormat = "M월 d일"
        } else {
            dateFormatter.dateFormat = "MMMM d"
        }
        return dateFormatter.string(from: currentDate)
    }
    
    //  Default Date Format
    func getDefaultDateFormat() -> String {
        let isoFormatter = ISO8601DateFormatter()
        let isoDateString = isoFormatter.string(from: Date())
        return isoDateString
    }
    
    func getCurrentDate() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: currentDate)
        return "\(day)"
    }
    
    func getTodayWeekday() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: date)
        return weekday
    }
    
    func dateSettingForWeekday(_ date: [SoliULabel]) {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else { return }
        var count = 0
        for eachDate in date {
            if let day = calendar.date(byAdding: .day, value: count, to: startOfWeek) {
                let dayString = dateFormatter.string(from: day)
                eachDate.text = dayString
                count += 1
            }
        }
    }
}

/// Navigation Extension
extension UIViewController {
    func tapAction(_ view: UIView, selector: Selector) {
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: selector)
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }

    func addEdgeSwipeToGoBack() {
        // Only add if not the root view controller
        if let nav = self.navigationController, nav.viewControllers.first != self {
            let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgeSwipe(_:)))
            edgeSwipe.edges = .left
            self.view.addGestureRecognizer(edgeSwipe)
        }
    }

    @objc private func handleEdgeSwipe(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

/// UI Extension
extension UIViewController {
    func applyBoader(_ view: [UIView], with color: UIColor = SoliUColor.viewBorder, backgroundColor: UIColor = .clear) {
        view.forEach { view in
            view.layer.borderColor = color.cgColor
            view.layer.cornerRadius = 12
            view.layer.borderWidth = 0.7
            view.backgroundColor = backgroundColor
        }
    }
    
    func showAlert(title: String = "Error", error: CustomError) {
        let alertController = UIAlertController(title: title, message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: .localized(.ok), style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
            if let viewControllers = self.navigationController?.viewControllers {
                for vc in viewControllers {
                    if vc.isKind(of: ofClass) {
                        self.navigationController?.popToViewController(vc, animated: animated)
                        break
                    }
                }
            }
        }
    
    func showAlertWithButton(title: String, message: String, popVC: Bool = false, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: .localized(.ok), style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func applyBoader(_ view: UIView, with color: UIColor = SoliUColor.viewBorder, backgroundColor: UIColor = .clear) {
        view.layer.borderColor = color.cgColor
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.backgroundColor = backgroundColor
    }
    
    func makeCircleShape(_ view: UIView) {
        view.layer.cornerRadius = view.layer.frame.size.width/2
    }
    
    func applyGradientBackground(to view: UIView, startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = 25
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func showAlert(title: String, description: String) {
        var attributes = EKAttributes.topFloat
        attributes.entryBackground = .color(color: .white)
        attributes.displayDuration = 3
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: SoliUFont.bold14, color: .black))
        let description = EKProperty.LabelContent(text: description, style: .init(font: SoliUFont.regular14, color: .black))
        let image = EKProperty.ImageContent(image: ImageAsset.soliuLogoOnly.image, size: CGSize(width: 40, height: 40))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    enum SelectButtonsPlacement {
        case below(anchorView: UIView, offset: CGFloat = SoliUSpacing.space48)
        case centered(yOffset: CGFloat = 0)
    }

    func createSelectButton(
        labels: [String],
        spacing: CGFloat,
        placement: SelectButtonsPlacement,
        horizontalInset: CGFloat = SoliUSpacing.space24,
        buttonHeight: CGFloat = 40,
        buttonTappedCallback: ((Int, Bool) -> Void)? = nil
    ) {
        guard !labels.isEmpty else { return }

        var buttons: [SoliUButton] = []
        var userClicked = false
        var selectedIndex = 0

        for (idx, text) in labels.enumerated() {
            let customButton = CustomSelectButton(titleString: text, index: idx) { buttonIndex, isEnabled in
                selectedIndex = buttonIndex
                userClicked = isEnabled
                buttonTappedCallback?(selectedIndex, userClicked)
            }
            customButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
            buttons.append(customButton)
        }

        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = .fill
        stackView.distribution = .fill
        addAutoLayoutSubView(stackView)

        let totalHeight = CGFloat(labels.count) * buttonHeight + CGFloat(max(labels.count - 1, 0)) * spacing
        let heightConstraint = stackView.heightAnchor.constraint(equalToConstant: totalHeight)
        heightConstraint.isActive = true


        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalInset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalInset)
        ])

        switch placement {
        case .below(let anchorView, let offset):
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: offset)
            ])

        case .centered(let yOffset):
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yOffset)
            ])
        }
    }

    
    func createUnderLineText(button: SoliUButton, text: String) {
        let buttonTitle = text
        let attributedString = NSMutableAttributedString(string: buttonTitle)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: buttonTitle.count))
        button.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UIViewController {
    func addAutoLayoutSubViews(_ view: [UIView]) {
        view.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
    
    func addAutoLayoutSubView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
    }
    
    func hideWithAlpha(_ views:[UIView]) {
        views.forEach { view in
            view.alpha = 0.0
        }
    }
}

/// Set Navigation Back Button Extension
extension UIViewController {
    func setCustomBackNavigationButton(_ selector: Selector = #selector(UINavigationController.popViewController(animated:))) {
        let backButton = UIBarButtonItem(
            image: ImageAsset.newBackArrow.image.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: navigationController,
            action: selector
        )

        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 10

        navigationItem.leftBarButtonItems = [spacer, backButton]
        addEdgeSwipeToGoBack()
    }
    
    func setCustomBackNavigationButtonWithRightImage(_ selector: Selector = #selector(UINavigationController.popViewController(animated:)), rightImage: UIImage?, rightSelector: Selector?) {
        let backButton = UIBarButtonItem(image: ImageAsset.newBackArrow.image.withRenderingMode(.alwaysOriginal),
                                         style: .plain,
                                         target: navigationController,
                                         action: selector)
        
        var rightButton: UIBarButtonItem?
        if let rightImage = rightImage {
            rightButton = UIBarButtonItem(image: rightImage.withRenderingMode(.alwaysOriginal),
                                          style: .plain,
                                          target: navigationController,
                                          action: rightSelector)
        }
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setNavigationTitle(title: String) {
        let titleLabel = SoliULabel()
        titleLabel.text = title
        titleLabel.font = SoliUFont.bold16
        titleLabel.textColor = SoliUColor.soliuBlack
        self.navigationItem.titleView = titleLabel
    }
}

extension UIViewController {
    /// Navigates to a view controller of the specified type from the given storyboard.
    ///
    /// - Parameters:
    ///   - type: The type of the view controller to navigate to.
    ///   - identifier: The storyboard identifier for the view controller.
    ///   - storyboardName: The name of the storyboard (default is "Main").
    ///   - animated: Whether the transition is animated.
    ///   - hidesBottomBarWhenPushed: hidesBottomBarWhenPushed deafult setting is false
    func navigate<T: UIViewController>(to: T.Type,
                                       identifier: String = T.className,
                                       storyboardName: String = "Main",
                                       animated: Bool = true,
                                       hidesBottomBarWhenPushed: Bool = false,
                                       configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            print("Can't find \(identifier)")
            return
        }
        viewController.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
        navigationController?.pushViewController(viewController, animated: animated)
        configure?(viewController)
        self.trackPush(to: viewController)
    }

    // Navigate to viewController with no storyboard
    func navigate(_ viewController: BaseViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
        self.trackPush(to: viewController)
    }
}
