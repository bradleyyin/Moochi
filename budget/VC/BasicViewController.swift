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
    weak var screenTitleLabel: TitleLabel!
    var categories: [Category] = []
    var budgetController: BudgetController!
    //auto layout
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        let label = TitleLabel()
        
        label.text = titleOfVC.uppercased()
        self.view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        label.heightAnchor.constraint(equalToConstant: 100 * heightRatio).isActive = true
        self.screenTitleLabel = label
    }
    
    func loadCategories() {
        categories = budgetController.readCategories()
    }
    
    @objc func backButtonTapped () {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func homeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
