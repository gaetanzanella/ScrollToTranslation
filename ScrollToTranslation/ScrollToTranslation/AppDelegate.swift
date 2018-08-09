//
//  AppDelegate.swift
//  ScrollToTranslation
//
//  Created by Gaétan Zanella on 08/08/2018.
//  Copyright © 2018 Gaétan Zanella. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let overlay = OverlayViewController()
        let containerViewController = OverlayContainerViewController(overlayViewController: overlay)
        let backgroundViewController = BackgroundViewController()
        window?.rootViewController = StackViewController(viewControllers: [backgroundViewController, containerViewController])
        window?.makeKeyAndVisible()
        return true
    }
}

