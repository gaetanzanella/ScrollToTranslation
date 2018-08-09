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

class OverlayContainerViewController: UIViewController, OverlayViewControllerDelegate {

    private let overlayViewController: OverlayViewController

    private lazy var translatedView = UIView()
    private lazy var translatedViewHeightContraint = self.makeTranslatedViewHeightConstraint()

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

    // MARK: - OverlayViewControllerDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isTracking, shouldTranslateView(following: scrollView) else { return }
        translateView(following: scrollView)
    }

    func scrollViewDidStopScrolling(_ scrollView: UIScrollView) {
        animateTranslationEnd()
    }

    // MARK: - Public

    func moveOverlay(to position: OverlayPosition) {
        overlayPosition = position
        translatedViewHeightContraint.constant = translatedViewTargetHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Private

    private func setUpController() {
        view.addSubview(translatedView)
        translatedView.gz_pinToSuperview(edges: [.left, .right, .bottom])
        translatedViewHeightContraint.isActive = true
        gz_addChild(overlayViewController, in: translatedView, edges: [.right, .left, .top])
        overlayViewController.view.heightAnchor.constraint(equalToConstant: Constant.maximumHeight).isActive = true
        translatedView.backgroundColor = .red
        overlayViewController.tableView.backgroundColor = .red
        overlayViewController.delegate = self
    }

    private func shouldTranslateView(following scrollView: UIScrollView) -> Bool {
        let height = translatedViewHeightContraint.constant
        let offset = scrollView.contentOffset.y
        if height == Constant.maximumHeight {
            return offset < 0
        } else if height == Constant.minimumHeight {
            return offset > 0
        } else {
            return Constant.maximumHeight > height && height > Constant.minimumHeight
        }
    }

    private func translateView(following scrollView: UIScrollView) {
        scrollView.contentOffset = .zero
        let translation = translatedViewTargetHeight - scrollView.panGestureRecognizer.translation(in: view).y
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
}
