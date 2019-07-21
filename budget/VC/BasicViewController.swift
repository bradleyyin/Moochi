//
//  BasicViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    
    var titleOfVC : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
    func setupUI(){
        
        
        self.view.backgroundColor = .darkGray
        
        let titleLabel = TitleLabel(frame: CGRect(x: 10, y: statusBarHeight, width: 300, height: 100 * heightRatio))
        
        titleLabel.text = titleOfVC.uppercased()
        
        
        let menuButton = MenuButton(frame: CGRect(x: screenWidth - 40 - 5, y: statusBarHeight, width: 40 * heightRatio, height: buttonHeight * heightRatio))
        
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)

        
        let backButton = UIButton(frame: CGRect(x: 10, y: screenHeight - 10 - buttonHeight, width: 40, height: buttonHeight * heightRatio))
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let homeButton = UIButton(frame: CGRect(x: screenWidth - 40 - 5, y: screenHeight - 10 - buttonHeight, width: 40, height: buttonHeight * heightRatio))
        homeButton.setImage(UIImage(named: "home"), for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(titleLabel)
        if titleOfVC.uppercased() != "MENU"{
            self.view.addSubview(menuButton)
        }
        
        self.view.addSubview(backButton)
        self.view.addSubview(homeButton)
    }
    
    @objc func backButtonTapped (){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func homeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func menuTapped(){
        print("menu")
        let menuVC = MenuViewController()
        self.navigationController?.pushViewController(menuVC, animated: true)
        
    }

}
