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
    
    //auto layout
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
    func setUpAutoLayout(){
        
    }
    func setupUI(){
        
        
        self.view.backgroundColor = .darkGray
        
        let titleLabel = TitleLabel()
        
        titleLabel.text = titleOfVC.uppercased()
        self.view.addSubview(titleLabel)
        //titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100 * heightRatio).isActive=true
        
//        let menuButton = MenuButton()
//
//        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
//        self.view.addSubview(menuButton)
//        menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
//        menuButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//        menuButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
//        menuButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
//
//        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: menuButton.leftAnchor, constant: 30)

        
//        let backButton = UIButton(frame: CGRect(x: 10, y: screenHeight - 10 - buttonHeight, width: 40, height: buttonHeight * heightRatio))
//        backButton.setImage(UIImage(named: "back"), for: .normal)
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
//        let homeButton = UIButton(frame: CGRect(x: screenWidth/2 - 20, y: screenHeight - 10 - buttonHeight, width: buttonWidth, height: buttonHeight))
//        homeButton.setImage(UIImage(named: "home"), for: .normal)
//        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        
        
        
        
        
        
        //self.view.addSubview(backButton)
        //self.view.addSubview(homeButton)
    }
    
    @objc func backButtonTapped (){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func homeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
//    @objc func menuTapped(){
//        print("menu")
//        let menuVC = MenuViewController()
//        menuVC.delegate = self
//        self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
//        self.navigationController?.pushViewController(menuVC, animated: true)
//
//    }
//    func goFromMenu(to option:MenuOption) {
//        
//        //self.navigationController?.view.layer.add(CATransition().segueFromLeft(), forKey: nil)
//        
//        switch option {
//            
//        case .details:
//            if self.navigationController?.topViewController?.isKind(of: DetailsViewController.self) ?? false{
//                print("already detail")
//                if let viewControllers = self.navigationController?.viewControllers {
//                    for viewController in viewControllers {
//                        if let viewController = viewController as? DetailsViewController {
//                            self.navigationController?.popToViewController(viewController, animated: true)
//                            break
//                        }
//                    }
//                }
//            }else {
//               self.navigationController?.pushViewController(DetailsViewController(), animated: false)
//            }
//            
//        case .expenses:
//            if self.navigationController?.topViewController?.isKind(of: ExpenseViewController.self) ?? false{
//                print("already expense")
//                if let viewControllers = self.navigationController?.viewControllers {
//                    for viewController in viewControllers {
//                        if let viewController = viewController as? ExpenseViewController {
//                            self.navigationController?.popToViewController(viewController, animated: true)
//                            break
//                        }
//                    }
//                }
//            }else {
//                self.navigationController?.pushViewController(ExpenseViewController(), animated: false)
//            }
//            
//        case .addAnEntry:
//            if self.navigationController?.topViewController?.isKind(of: AddEntryViewController.self) ?? false{
//                print("already entry")
//                if let viewControllers = self.navigationController?.viewControllers {
//                    for viewController in viewControllers {
//                        if let viewController = viewController as? AddEntryViewController {
//                            self.navigationController?.popToViewController(viewController, animated: true)
//                            break
//                        }
//                    }
//                }
//            }else {
//                self.navigationController?.pushViewController(AddEntryViewController(), animated: false)
//            }
//        case .receiptAlbum:
//            print("receipt album")
//        }
//       
//        
//        
//    }

}
