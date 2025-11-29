//
//  DebugPanelManager.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

#if DEBUG
import UIKit

// MARK: - Public installer
enum DebugPanelInstaller {
    static func install(on window: UIWindow) {
        DebugPanelManager.shared.install(on: window)
    }
}

final class DebugPanelEnvironment {
    static let shared = DebugPanelEnvironment()
    var onClose: (() -> Void)?
}

// MARK: - Edge swipe -> present panel
final class DebugPanelManager: NSObject {
    static let shared = DebugPanelManager()
    private weak var window: UIWindow?
    private var edgePan: UIScreenEdgePanGestureRecognizer?
    private var isPresenting = false

    func install(on window: UIWindow) {
        self.window = window
        let edge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        edge.edges = .right
        edge.delegate = self
        window.addGestureRecognizer(edge)
        self.edgePan = edge
    }

    @objc private func handleEdgePan(_ g: UIScreenEdgePanGestureRecognizer) {
        guard let view = g.view else { return }
        let tx = g.translation(in: view).x
        if (g.state == .ended || g.state == .cancelled), tx < -40 {
            presentPanel()
        }
    }

    private func presentPanel() {
        guard !isPresenting, let root = window?.rootViewController else { return }
        isPresenting = true
        
        let nav = UINavigationController(rootViewController: DebugRootViewController())
        nav.modalPresentationStyle = .overFullScreen
        let container = DebugPanelSlideInViewController(content: nav)
        container.onDismiss = { [weak self] in self?.isPresenting = false }
        
        DebugPanelEnvironment.shared.onClose = { [weak container] in
            container?.dismissWithSlide()
        }
        root.present(container, animated: false)
    }
}

extension DebugPanelManager: UIGestureRecognizerDelegate { }

#endif
