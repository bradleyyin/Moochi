//
//  BasicViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData


class BasicViewController: UIViewController {

    
    
    var titleOfVC : String = ""
    var categories :[Category] = []
    
    //auto layout
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
    func setUpAutoLayout(){
        
    }
    func setupUI(){
        
        
        self.view.backgroundColor = .white
        
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
    
    func loadCategories(){
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        }catch{
            print("error loading categories: \(error)")
        }
    }
    
    func saveImage(image: UIImage) -> String? {
        //dont save absolute url, it changes every time, only save the appending
        let uuid = UUID().uuidString
        let fm = FileManager.default
        let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let filePath = dir?.appendingPathComponent("\(uuid).jpeg") else { return nil}
        
        if let imagedata = image.jpegData(compressionQuality: 1.0){
            do{
                try imagedata.write(to: filePath, options: .atomic)
                return "\(uuid).jpeg"
            }catch{
                print("error saving image : \(error)")
            }
            
        }
        
        return nil
    }
    
    func saveExpense(){
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        
        do{
            try context.save()
        }catch{
            print("error creating entry : \(error)")
        }
    }
    
    @objc func backButtonTapped (){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func homeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
