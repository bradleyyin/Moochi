//
//  DetailsViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class DetailsViewController: BasicViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    var categories :[Category] = []
    
    
    override func viewDidLoad() {
        titleOfVC = "DETAILS"
        super.viewDidLoad()
        loadSampleCategories()

        // Do any additional setup after loading the view.
    }
    override func setupUI(){
        super.setupUI()
        
        self.view.backgroundColor = .lightGray
        
        
//        let menuButton = UIButton(frame: CGRect(x: screenWidth - 40 - 5, y: statusBarHeight, width: 40 * heightRatio, height: buttonHeight * heightRatio))
//        
//        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        
        let detailsTableView = UITableView(frame: CGRect(x: 10, y: statusBarHeight + (100 * heightRatio), width: screenWidth - 20, height: screenHeight - statusBarHeight - (100 * heightRatio) - buttonHeight - 20))
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.backgroundColor = .clear
        detailsTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "detailsCell")
        detailsTableView.separatorStyle = .none
        detailsTableView.allowsSelection = false
        
       
        self.view.addSubview(detailsTableView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 * heightRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
        let category = categories[indexPath.row]
        cell.categoryRemaining = category.remainingBudget ?? 0
        cell.categoryTotal = category.totalBudget ?? 0
        cell.categoryTitle = category.categoryName ?? ""
        cell.fontSize = 25 * heightRatio
        
        return cell
    }
    

    
    func loadSampleCategories(){
        let cat1 = Category(categoryName: "income", totalBudget: 2000, remainingBudget: 360)
        let cat2 = Category(categoryName: "food", totalBudget: 400, remainingBudget: 200)
        let cat3 = Category(categoryName: "HOusing", totalBudget: 800, remainingBudget: 0)
        categories = [cat1, cat2, cat3]
    }

}
