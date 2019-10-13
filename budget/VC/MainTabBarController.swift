//
//  MainTabBarController.swift
//  budget
//
//  Created by Bradley Yin on 10/12/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupAppearance()
    }
    
    private func setupViewControllers() {
        let mainVC = MainViewController()
        let detailsVC = DetailsViewController()
        let expensesVC = ExpenseViewController()
        let expensesNav = UINavigationController(rootViewController: expensesVC)
        let recieptAlbumVC = ReceiptAlbumViewController()
        let recieptNav = UINavigationController(rootViewController: recieptAlbumVC)
        
        expensesNav.isNavigationBarHidden = true
        recieptNav.isNavigationBarHidden = true
               
        mainVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home"), tag: 0)
        detailsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "details"), tag: 1)
        expensesVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "calender"), tag: 2)
        recieptAlbumVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "album"), tag: 3)
               
               let controllers = [mainVC, detailsVC, expensesNav, recieptNav]
        self.viewControllers = controllers
    }
    
    private func setupAppearance() {
        self.tabBar.barTintColor = .clear
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = superLightGray
    }
    
}
