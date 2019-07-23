//
//  AppDelegate.swift
//  budget
//
//  Created by Bradley Yin on 6/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let tabBarController = UITabBarController()
        let mainVC = MainViewController()
        let detailsVC = DetailsViewController()
        let expensesVC = ExpenseViewController()
        let expensesNav = UINavigationController(rootViewController: expensesVC)
        expensesNav.isNavigationBarHidden = true
        
        mainVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home"), tag: 0)
        detailsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "details"), tag: 1)
        expensesVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "calender"), tag: 2)
        
        let controllers = [mainVC, detailsVC, expensesNav]
        tabBarController.viewControllers = controllers
        tabBarController.tabBar.barTintColor = .red
        //tabBarController.tabBar.shadowImage = UIImage()
        //tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .white
        
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        #if DEBUG
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        
        #endif
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

