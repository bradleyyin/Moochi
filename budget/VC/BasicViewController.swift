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
    let imageSaver = ImageSaver()
    let budgetController = BudgetController()
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
    
    @objc func backButtonTapped (){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func homeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
