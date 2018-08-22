//
//  OverlayViewController.swift
//  ScrollToTranslation
//
//  Created by Gaétan Zanella on 08/08/2018.
//  Copyright © 2018 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol OverlayViewControllerDelegate: class {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func scrollView(_ scrollView: UIScrollView,
                    willEndScrollingWithVelocity velocity: CGPoint,
                    targetContentOffset: UnsafeMutablePointer<CGPoint>)
}

class OverlayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: OverlayViewControllerDelegate?

    private(set) lazy var tableView = UITableView()

    override func loadView() {
        view = tableView
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Cell \(indexPath)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.scrollView(scrollView, willEndScrollingWithVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
