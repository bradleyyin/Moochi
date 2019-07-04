//
//  MenuViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let menuOptions = ["DETAILS", "EXPENSES", "ADD AN ENTRY", "RECEIPT ALBUM" ]
    
    var heightRatio : CGFloat = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        heightRatio = screenHeight / 896
        setupUI()

        // Do any additional setup after loading the view.
    }
    func setupUI (){
        
        let buttonHeight : CGFloat = 40
        
        self.view.backgroundColor = .darkGray
        
        let menuLabel = UILabel(frame: CGRect(x: 10, y: statusBarHeight, width: 300, height: 100 * heightRatio))
        menuLabel.textColor = .white
        menuLabel.adjustsFontSizeToFitWidth = true
        menuLabel.font = UIFont(name: fontName, size: 70 * heightRatio)
        menuLabel.minimumScaleFactor = 0.3
        menuLabel.text = "MENU"
        menuLabel.textAlignment = .left
        
        let menuTableView = UITableView(frame: CGRect(x: 40, y: menuLabel.frame.origin.y + menuLabel.frame.height, width: screenWidth - 40, height: screenHeight - statusBarHeight - menuLabel.frame.height - buttonHeight - 20))
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.backgroundColor = .clear
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuCell")
        menuTableView.separatorStyle = .none
        menuTableView.isScrollEnabled = false
        
        let backButton = UIButton(frame: CGRect(x: 10, y: screenHeight - 10 - buttonHeight, width: 40, height: buttonHeight * heightRatio))
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let homeButton = UIButton(frame: CGRect(x: screenWidth - 40 - 5, y: screenHeight - 10 - buttonHeight, width: 40, height: buttonHeight * heightRatio))
        homeButton.setImage(UIImage(named: "home"), for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(menuLabel)
        self.view.addSubview(menuTableView)
        self.view.addSubview(backButton)
        self.view.addSubview(homeButton)
        
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 * heightRatio
    }
    
    @objc func backButtonTapped (){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func homeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func detailsSelected () {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
