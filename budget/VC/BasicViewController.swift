//
//  BasicViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit


class BasicViewController: UIViewController, MenuDelegate {

    
    
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
        
        
        let menuButton = MenuButton(frame: CGRect(x: screenWidth - 40 - 5, y: statusBarHeight, width: buttonWidth, height: buttonHeight))
        
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)

        
//        let backButton = UIButton(frame: CGRect(x: 10, y: screenHeight - 10 - buttonHeight, width: 40, height: buttonHeight * heightRatio))
//        backButton.setImage(UIImage(named: "back"), for: .normal)
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let homeButton = UIButton(frame: CGRect(x: screenWidth/2 - 20, y: screenHeight - 10 - buttonHeight, width: buttonWidth, height: buttonHeight))
        homeButton.setImage(UIImage(named: "home"), for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(titleLabel)
        
        self.view.addSubview(menuButton)
        
        
        //self.view.addSubview(backButton)
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
        menuVC.delegate = self
        self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
        self.navigationController?.pushViewController(menuVC, animated: true)
        
    }
    func goFromMenu(to option:MenuOption) {
        
        //self.navigationController?.view.layer.add(CATransition().segueFromLeft(), forKey: nil)
        
        switch option {
            
        case .details:
            if self.navigationController?.topViewController?.isKind(of: DetailsViewController.self) ?? false{
                print("already detail")
                if let viewControllers = self.navigationController?.viewControllers {
                    for viewController in viewControllers {
                        if let viewController = viewController as? DetailsViewController {
                            self.navigationController?.popToViewController(viewController, animated: true)
                            break
                        }
                    }
                }
            }else {
               self.navigationController?.pushViewController(DetailsViewController(), animated: false)
            }
            
        case .expenses:
            if self.navigationController?.topViewController?.isKind(of: ExpenseViewController.self) ?? false{
                print("already expense")
                if let viewControllers = self.navigationController?.viewControllers {
                    for viewController in viewControllers {
                        if let viewController = viewController as? ExpenseViewController {
                            self.navigationController?.popToViewController(viewController, animated: true)
                            break
                        }
                    }
                }
            }else {
                self.navigationController?.pushViewController(ExpenseViewController(), animated: false)
            }
            
        case .addAnEntry:
            print("add an entry")
        case .receiptAlbum:
            print("receipt album")
        }
       
        
        
    }

}
