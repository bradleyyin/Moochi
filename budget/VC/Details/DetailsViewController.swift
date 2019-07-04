//
//  DetailsViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var heightRatio : CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightRatio = screenHeight / 896
        setupUI()

        // Do any additional setup after loading the view.
    }
    func setupUI(){
        let buttonHeight : CGFloat = 40
        
        self.view.backgroundColor = .darkGray
        
        let detailsLabel = UILabel(frame: CGRect(x: 10, y: statusBarHeight, width: 300, height: 100 * heightRatio))
        detailsLabel.textColor = .white
        detailsLabel.adjustsFontSizeToFitWidth = true
        detailsLabel.font = UIFont(name: fontName, size: 70 * heightRatio)
        detailsLabel.minimumScaleFactor = 0.3
        detailsLabel.text = "DETAILS"
        detailsLabel.textAlignment = .left
        
        let detailsTableView = UITableView(frame: CGRect(x: 40, y: detailsLabel.frame.origin.y + detailsLabel.frame.height, width: screenWidth - 40, height: screenHeight - statusBarHeight - detailsLabel.frame.height - buttonHeight - 20))
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.backgroundColor = .clear
        detailsTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "detailsCell")
        detailsTableView.separatorStyle = .none
        detailsTableView.isScrollEnabled = false
        
        let backButton = UIButton(frame: CGRect(x: 10, y: screenHeight - 10 - buttonHeight, width: 40, height: buttonHeight * heightRatio))
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let homeButton = UIButton(frame: CGRect(x: screenWidth - 40 - 5, y: screenHeight - 10 - buttonHeight, width: 40, height: buttonHeight * heightRatio))
        homeButton.setImage(UIImage(named: "home"), for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
    }
    

    @objc func backButtonTapped (){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func homeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
