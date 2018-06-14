//
//  AppDelegate.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 25/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        SettingsBundleHelper.checkAndExecuteSettings()
        
        let userId = UserDefaults().integer(forKey: "user_credencial_id")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //self.window = UIWindow(frame: UIScreen.main.bounds)
        if userId != 0 {
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "homeNavigationController")
        } else {
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "loginNavigationController")
            
        }
        //self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        let userId = UserDefaults().integer(forKey: "user_credencial_id")
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        if userId != 0 {
//            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "homeNavigationController")
//        } else {
//            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "loginNavigationController")
//
//        }
//         self.window?.makeKeyAndVisible()

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        SettingsBundleHelper.checkAndExecuteSettings()
//        
//        let userId = UserDefaults().integer(forKey: "user_credencial_id")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        if userId != 0 {
//            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "homeNavigationController")
//        } else {
//            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "loginNavigationController")
//            
//        }
//        self.window?.makeKeyAndVisible()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

