//
//  ViewController.swift
//  MapsLike
//

import UIKit

class StackViewController: UIViewController {

    private var viewControllers: [UIViewController]

    // MARK: - Life Cycle

    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }

    // MARK: - Private

    private func setUpViewController() {
        viewControllers.forEach { gz_addChild($0, in: view) }
    }
}
