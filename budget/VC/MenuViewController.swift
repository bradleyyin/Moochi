//
//  MenuViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

enum MenuOption {
    case details
    case expenses
    case addAnEntry
    case receiptAlbum
}

protocol MenuDelegate {
    func goFromMenu(to: MenuOption)
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let menuOptions : [MenuOption] = [.details, .expenses, .addAnEntry, .receiptAlbum]
    
    
    var delegate : MenuDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
    func setupUI (){
        
        self.view.backgroundColor = .darkGray
        
        let titleLabel = TitleLabel(frame: CGRect(x: 10, y: statusBarHeight, width: 300, height: 100 * heightRatio))
        
        titleLabel.text = "MENU"
        
        let menuButton = MenuButton(frame: CGRect(x: screenWidth - buttonWidth - 5, y: statusBarHeight + (titleLabel.frame.height / 2 - buttonHeight / 2), width: buttonWidth, height: buttonHeight))
        
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
       
       
        let menuTableView = UITableView(frame: CGRect(x: 40, y: statusBarHeight + (100 * heightRatio), width: screenWidth - 40, height: screenHeight - statusBarHeight - (100 * heightRatio) - buttonHeight - 20))
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.backgroundColor = .clear
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuCell")
        menuTableView.separatorStyle = .none
        menuTableView.isScrollEnabled = false
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(menuTableView)
        self.view.addSubview(menuButton)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        cell.option = menuOptions[indexPath.row]
        cell.fontSize = 50 * heightRatio
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.view.layer.add(CATransition().popFromLeft(), forKey: nil)
        self.navigationController?.popViewController(animated: false)
        delegate?.goFromMenu(to: menuOptions[indexPath.row])
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 * heightRatio
    }
    
    @objc func menuTapped(){
        self.navigationController?.view.layer.add(CATransition().popFromLeft(), forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }


}
