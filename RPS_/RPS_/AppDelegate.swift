//
//  AppDelegate.swift
//  RockPaperScicors
//
//  Created by bakebrlk on 28.05.2023.
//

import UIKit
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.makeKeyAndVisible()
        
        
        window?.rootViewController = UINavigationController(rootViewController: StartView())
        
        return true
    }




}

