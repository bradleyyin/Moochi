//
//  MenuViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class MenuViewController: BasicViewController, UITableViewDelegate, UITableViewDataSource {

    let menuOptions = ["DETAILS", "EXPENSES", "ADD AN ENTRY", "RECEIPT ALBUM" ]
    
    
    

    override func viewDidLoad() {
        titleOfVC = "menu"
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    override func setupUI (){
        super.setupUI()
       
        let menuTableView = UITableView(frame: CGRect(x: 40, y: statusBarHeight + (100 * heightRatio), width: screenWidth - 40, height: screenHeight - statusBarHeight - (100 * heightRatio) - buttonHeight - 20))
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.backgroundColor = .clear
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuCell")
        menuTableView.separatorStyle = .none
        menuTableView.isScrollEnabled = false
        
        self.view.addSubview(menuTableView)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        cell.optionTitle = menuOptions[indexPath.row]
        cell.fontSize = 50 * heightRatio
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            detailsSelected()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 * heightRatio
    }
    
    func detailsSelected () {
        let detailVC = DetailsViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }


}
