//
//  OverlayContainerViewController.swift
//  ScrollToTranslation
//
//  Created by Gaétan Zanella on 08/08/2018.
//  Copyright © 2018 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let minimumHeight: CGFloat = 200
    static let maximumHeight: CGFloat = 500
}

enum OverlayPosition {
    case maximum, minimum
}

class OverlayContainerViewController: UIViewController, UIGestureRecognizerDelegate, GripableTableViewDelegate {

    private let overlayViewController: OverlayViewController

    private lazy var translatedView = UIView()
    private lazy var translatedViewHeightContraint = self.makeTranslatedViewHeightConstraint()
    private lazy var translationPanGestureRecognizer = self.makePanGestureRecognizer()

    private var overlayPosition: OverlayPosition = .minimum

    private var translatedViewTargetHeight: CGFloat {
        switch overlayPosition {
        case .maximum:
            return Constant.maximumHeight
        case .minimum:
            return Constant.minimumHeight
        }
    }

    // MARK: - Life Cycle

    init(overlayViewController: OverlayViewController) {
        self.overlayViewController = overlayViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func loadView() {
        view = PassThroughView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
    }

    // MARK: - GripableTableViewDelegate

    func gripableTableView(_ tableView: UITableView,
                           shouldResetContentOffsetDuringLayout newValue: CGPoint) -> Bool {
        let height = translatedView.frame.height
        return Constant.maximumHeight > height && height > Constant.minimumHeight
    }

    // MARK: - Public

    func moveOverlay(to position: OverlayPosition) {
        overlayPosition = position
        translatedViewHeightContraint.constant = translatedViewTargetHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    // MARK: - Actions

    @objc private func translationGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            translateView(following: sender)
        case .changed:
            translateView(following: sender)
        case .failed, .ended:
            animateTranslationEnd()
        default:
            break
        }
    }

    // MARK: - Private

    private func setUpController() {
        view.addSubview(translatedView)
        overlayViewController.tableView.gripableDelegate = self
        translatedView.gz_pinToSuperview(edges: [.left, .right, .bottom])
        translatedViewHeightContraint.isActive = true
        gz_addChild(overlayViewController, in: translatedView)
        translatedView.addGestureRecognizer(translationPanGestureRecognizer)
        translatedView.backgroundColor = .red
        overlayViewController.tableView.backgroundColor = .red
    }

    private func translateView(following panGesture: UIPanGestureRecognizer) {
        let translation = translatedViewTargetHeight - panGesture.translation(in: view).y
        translatedViewHeightContraint.constant = max(
            Constant.minimumHeight,
            min(translation, Constant.maximumHeight)
        )
    }

    private func animateTranslationEnd() {
        let middle = (Constant.maximumHeight + Constant.minimumHeight) / 2
        let position: OverlayPosition = translatedViewHeightContraint.constant > middle ? .maximum : .minimum
        moveOverlay(to: position)
    }

    private func makeTranslatedViewHeightConstraint() -> NSLayoutConstraint {
        return translatedView.heightAnchor.constraint(equalToConstant: Constant.minimumHeight)
    }

    private func makePanGestureRecognizer() -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(translationGestureRecognizerAction(_:))
        )
        gesture.delegate = self
        return gesture
    }
}
