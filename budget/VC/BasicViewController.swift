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

    var titleOfVC: String = ""
    var categories: [Category] = []
    var budgetController: BudgetController!
    //auto layout
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        self.view.backgroundColor = .white
        
        let titleLabel = TitleLabel()
        
        titleLabel.text = titleOfVC.uppercased()
        self.view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100 * heightRatio).isActive = true
    }
    
    func loadCategories(){
        categories = budgetController.readCategories()
    }
    
    @objc func backButtonTapped () {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func homeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
