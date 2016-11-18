//
//  AppDelegate.swift
//  BentoMapExample
//
//  Created by Michael Skiba on 7/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = UINavigationController.init(rootViewController: MainMenuTableViewController())
        window?.makeKeyAndVisible()
        return true
    }

}
