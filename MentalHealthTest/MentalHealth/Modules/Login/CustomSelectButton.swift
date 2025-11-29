//
//  CustomSelectButton.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/24/24.
//

import Foundation
import UIKit

final class CustomSelectButton: SoliUButton {
    private var buttonTappedCallback: ((Int, Bool) -> Void)?
    var checkmarkImageView: UIImageView?
    var index: Int

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    required init(titleString: String, index: Int, buttonTappedCallback: ((Int, Bool) -> Void)? = nil) {
        self.index = index
        super.init(frame: .zero)
        self.buttonTappedCallback = buttonTappedCallback
        layer.borderWidth = 0.5
        layer.borderColor = SoliUColor.tabBarBorder.cgColor
        backgroundColor = .white
        setTitleColor(SoliUColor.soliuBlack, for: .normal)
        
        setTitle(titleString, for: .normal)
        titleLabel?.font = SoliUFont.medium14
        addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped(_ sender: SoliUButton) {
        guard !isSelected else {
            return
        }
        
        if isSelected {
            // Deselect the button
            isSelected = false
            defaultButtonSet()
            
            // Remove checkmark image
            checkmarkImageView?.removeFromSuperview()
        } else {
            // Select the button
            isSelected = true
            buttonTappedCallback?(index, isSelected)
            layer.borderWidth = 1.5
            layer.borderColor = SoliUColor.newSoliuBlue.cgColor
            setTitleColor(SoliUColor.newSoliuBlue, for: .normal)
            
            // Add checkmark image
            addCheckmarkImage()
            
            // Disable all other buttons
            guard let stackView = superview as? UIStackView else { return }
            for case let button as CustomSelectButton in stackView.arrangedSubviews where button != self {
                button.isSelected = false
                button.defaultButtonSet()
                button.checkmarkImageView?.removeFromSuperview()
            }
        }
    }
    
    func defaultButtonSet() {
        layer.borderWidth = 0.5
        layer.borderColor = SoliUColor.tabBarBorder.cgColor
        setTitleColor(SoliUColor.soliuBlack, for: .normal)
    }
    
    func addCheckmarkImage() {
        let imageSize: CGFloat = SoliUSpacing.space16
        let image = ImageAsset.buttonCheck.image
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: bounds.width - imageSize - 15, y: (bounds.height - imageSize) / 2, width: imageSize, height: imageSize)
        addSubview(imageView)
        
        checkmarkImageView = imageView
    }
}

#if DEBUG
extension CustomSelectButton {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: CustomSelectButton

        var buttonTappedCallback: ((Int, Bool) -> Void)? { target.buttonTappedCallback }

        var checkmarkImageView: UIImageView? { target.checkmarkImageView }

        var index: Int { target.index }

        func defaultButtonSet() { target.defaultButtonSet() }

        func addCheckmarkImage() { target.addCheckmarkImage() }
    }
}
#endif
