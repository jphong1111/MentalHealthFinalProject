//
//  BaseSectionView.swift
//  MentalHealth
//
//  Created by JungpyoHong on 12/18/24.
//

import Foundation
import UIKit
import os.log
import Combine

/// BaseSection View can contain either analytics for user behavior, accessibility, and internal logs
open class BaseSectionViewController: BaseViewController {
    public let signpostID: OSSignpostID!
    public static let pointOfInterrest = OSLog(subsystem: "com.soliu.mentalHealth", category: .pointsOfInterest)

    private var isFirstLayout = true

    open override func viewWillAppear(_ animated: Bool) {
        os_signpost(.begin, log: Self.pointOfInterrest, name: SignPostName.appearing, signpostID: signpostID)
        super.viewWillAppear(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        os_signpost(.end, log: Self.pointOfInterrest, name: SignPostName.appearing, signpostID: signpostID)
        super.viewDidAppear(animated)
    }

    open override func loadView() {
        os_signpost(.begin, log: Self.pointOfInterrest, name: SignPostName.loading, signpostID: signpostID)
        super.loadView()
        os_signpost(.end, log: Self.pointOfInterrest, name: SignPostName.loading, signpostID: signpostID)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureAccessibility(for: view)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLayout {
            os_signpost(.event, log: Self.pointOfInterrest, name: "FirstLayoutComplete", signpostID: signpostID)
            isFirstLayout = false
        }
        
        view.subviews.forEach { configureAccessibility(for: $0) }
    }

    public override init(nibName: String?, bundle: Bundle?) {
        signpostID = OSSignpostID(log: Self.pointOfInterrest)
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required public init?(coder: NSCoder) {
        self.signpostID = OSSignpostID(log: Self.pointOfInterrest)
        super.init(coder: coder)
    }
    
    // Note: Override to inject custom dependencies
    func injectDependencies(_ dependencies: [InjectableDependency]) {}

    // Adding Accessibility label for all UI elements
    private func configureAccessibility(for view: UIView) {
        switch view {
        case let imageView as UIImageView:
            imageView.isAccessibilityElement = true
            imageView.accessibilityLabel = "\(imageView.accessibilityLabel ?? "Image")"
        default:
            break
        }
    }
}

public enum SignPostName {
    static let appearing: StaticString = "ViewControllerAppearing"
    static let loading: StaticString = "ViewControllerLoading"
}
