//
//  ViewController.swift
//  budget
//
//  Created by Bradley Yin on 6/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        // Do any additional setup after loading the view.
    }
    func setUpUI(){
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let heightRatio = screenHeight / 896
        let buttonWidth : CGFloat = 40
        let buttonHeight : CGFloat = 40
        self.view.backgroundColor = .darkGray
        
        let menuButton = UIButton(frame: CGRect(x: screenWidth - buttonWidth - 5, y: statusBarHeight, width: buttonWidth * heightRatio, height: buttonHeight * heightRatio))
        menuButton.setImage(UIImage(named: "menuButton"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        
        let monthLabel = UILabel(frame: CGRect(x: screenWidth / 2 - 150, y: 50, width: 300, height: 100 * heightRatio))
        monthLabel.textColor = .white
        monthLabel.backgroundColor = .clear
        monthLabel.adjustsFontSizeToFitWidth = true
        monthLabel.font = monthLabel.font.withSize(100 * heightRatio)
        monthLabel.minimumScaleFactor = 0.3
        monthLabel.text = "JUNE"
        monthLabel.textAlignment = .center
        
        let monthNumberLabel = UILabel(frame: CGRect(x: screenWidth / 2 - 25, y: monthLabel.frame.origin.y + monthLabel.frame.height + 20, width: 50, height: 50 * heightRatio))
        monthNumberLabel.textColor = .white
        monthNumberLabel.backgroundColor = .clear
        monthNumberLabel.adjustsFontSizeToFitWidth = true
        monthNumberLabel.font = monthNumberLabel.font.withSize(50 * heightRatio)
        monthNumberLabel.minimumScaleFactor = 0.3
        monthNumberLabel.text = "06"
        monthNumberLabel.textAlignment = .center
        
        let dotLabel1 = UILabel(frame: CGRect(x: 10, y: monthNumberLabel.frame.origin.y + monthNumberLabel.frame.height, width: screenWidth - 20, height: 40 * heightRatio))
        dotLabel1.textColor = .lightGray
        dotLabel1.font = monthNumberLabel.font.withSize(50 * heightRatio)
        dotLabel1.text = ". . . . . . . . . . . . . . . . . . . . . . . . . ."
        dotLabel1.lineBreakMode = .byClipping
        
        let moneyCircle = UIView(frame: CGRect(x: screenWidth / 2 - (150 * heightRatio), y: dotLabel1.frame.origin.y + dotLabel1.frame.height + 20, width: 300 * heightRatio, height: 300 * heightRatio))
        moneyCircle.backgroundColor = .lightGray
        moneyCircle.layer.masksToBounds = true
        moneyCircle.layer.cornerRadius = 150 * heightRatio
        
        let moneyLabel = UILabel(frame: CGRect(x: 20, y: moneyCircle.frame.height / 2 - 30, width: moneyCircle.frame.width - 40, height: 60 * heightRatio))
        moneyLabel.backgroundColor = .clear
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = .black
        moneyLabel.font = moneyLabel.font.withSize(80 * heightRatio)
        moneyLabel.adjustsFontSizeToFitWidth = true
        moneyLabel.minimumScaleFactor = 0.3
        moneyLabel.text = "2960.00"
        
        let dotLabel2 = UILabel(frame: CGRect(x: 10, y: moneyCircle.frame.origin.y + moneyCircle.frame.height, width: screenWidth - 20, height: 40 * heightRatio))
        dotLabel2.textColor = .lightGray
        dotLabel2.font = monthNumberLabel.font.withSize(50 * heightRatio)
        dotLabel2.text = ". . . . . . . . . . . . . . . . . . . . . . . . . ."
        dotLabel2.lineBreakMode = .byClipping
        
        let button = UIButton(frame: CGRect(x: screenWidth / 2 - 100, y: dotLabel2.frame.origin.y + dotLabel2.frame.height + 20, width: 200, height: 25 * heightRatio))
//        let icon = UIImage(named: "plusButton")!
//        button.setImage(icon, for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        button.backgroundColor = .clear
        button.setTitle("+ add an entry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(addEntry), for: .touchUpInside)
        
        
        
        
        
        self.view.addSubview(monthLabel)
        self.view.addSubview(monthNumberLabel)
        self.view.addSubview(dotLabel1)
        moneyCircle.addSubview(moneyLabel)
        self.view.addSubview(moneyCircle)
        self.view.addSubview(dotLabel2)
        self.view.addSubview(button)
        self.view.addSubview(menuButton)
    }
    
    @objc func addEntry () {
        print("add")
    }
    @objc func menuTapped(){
        print("menu")
        let menuVC = MenuViewController()
        self.navigationController?.pushViewController(menuVC, animated: true)
        
    }


}

