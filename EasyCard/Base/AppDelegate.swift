//
//  AppDelegate.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LocalizationService.shared.getLanguage()
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        FirebaseApp.configure()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let router = Router()
        let navVC = UINavigationController(rootViewController: isUserLoggedIn ? router.homeVC() : router.welcomeVC() )
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
        return true
    }

}

