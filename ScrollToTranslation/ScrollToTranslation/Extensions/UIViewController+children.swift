//
//  UIViewController+children.swift
//  UDP
//
//  Created by Gaétan Zanella on 01/07/2018.
//  Copyright © 2018 Gaétan Zanella. All rights reserved.
//

import UIKit

extension UIViewController {
    func gz_addChild(_ child: UIViewController, in containerView: UIView) {
        guard containerView.isDescendant(of: view) else { return }
        addChildViewController(child)
        containerView.addSubview(child.view)
        child.view.gz_pinToSuperview()
        child.didMove(toParentViewController: self)
    }
}
