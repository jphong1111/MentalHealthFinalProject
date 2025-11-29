//
//  DebugPanelSlideInViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

#if DEBUG
import UIKit

final class DebugPanelSlideInViewController: UIViewController {
    private let content: UIViewController
    private let dimView = UIControl()
    private let panelView = UIView()
    private let panelWidthRatio: CGFloat = 1
    var onDismiss: (() -> Void)?

    init(content: UIViewController) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        dimView.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

        panelView.backgroundColor = .systemBackground
        panelView.layer.cornerRadius = 16
        panelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        panelView.layer.shadowColor = UIColor.black.cgColor
        panelView.layer.shadowOpacity = 0.1
        panelView.layer.shadowRadius = 8

        view.addSubview(dimView)
        view.addSubview(panelView)

        addChild(content)
        panelView.addSubview(content.view)
        content.didMove(toParent: self)

        dimView.translatesAutoresizingMaskIntoConstraints = false
        panelView.translatesAutoresizingMaskIntoConstraints = false
        content.view.translatesAutoresizingMaskIntoConstraints = false

        let width = view.bounds.width * panelWidthRatio
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            panelView.topAnchor.constraint(equalTo: view.topAnchor),
            panelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panelView.widthAnchor.constraint(equalToConstant: width),
            panelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            content.view.topAnchor.constraint(equalTo: panelView.topAnchor),
            content.view.bottomAnchor.constraint(equalTo: panelView.bottomAnchor),
            content.view.leadingAnchor.constraint(equalTo: panelView.leadingAnchor),
            content.view.trailingAnchor.constraint(equalTo: panelView.trailingAnchor),
        ])

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panelView.addGestureRecognizer(pan)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        panelView.transform = CGAffineTransform(translationX: panelView.bounds.width, y: 0)
        UIView.animate(withDuration: 0.25) {
            self.dimView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
            self.panelView.transform = .identity
        }
    }

    @objc private func dismissSelf() {
        UIView.animate(withDuration: 0.22, animations: {
            self.dimView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.panelView.transform = CGAffineTransform(translationX: self.panelView.bounds.width, y: 0)
        }, completion: { _ in
            self.dismiss(animated: false) { self.onDismiss?() }
        })
    }

    func dismissWithSlide() { dismissSelf() }

    @objc private func handlePan(_ g: UIPanGestureRecognizer) {
        let t = g.translation(in: view)
        switch g.state {
        case .changed:
            let dx = max(0, t.x)
            panelView.transform = CGAffineTransform(translationX: dx, y: 0)
            let progress = min(1, dx / panelView.bounds.width)
            dimView.backgroundColor = UIColor.black.withAlphaComponent(0.25 * (1 - progress))
        case .ended, .cancelled:
            let shouldClose = t.x > panelView.bounds.width * 0.25 || g.velocity(in: view).x > 600
            shouldClose ? dismissSelf() : UIView.animate(withDuration: 0.18) {
                self.panelView.transform = .identity
                self.dimView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
            }
        default: break
        }
    }
}

#endif
