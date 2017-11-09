//
//  AppDelegate.swift
//  NotHotDog
//
//  Created by Nikita Pokidyshev on 09/11/2017.
//  Copyright © 2017 Nikita Pokidyshev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = ViewController()
        return true
    }
}
