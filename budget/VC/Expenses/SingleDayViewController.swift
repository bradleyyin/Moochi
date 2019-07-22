//
//  SingleDayViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class SingleDayViewController: BasicViewController {

    override func viewDidLoad() {
        titleOfVC = "here"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupUI() {
        super.setupUI()
        
        let titleLabel = TitleLabel(frame: CGRect(x: screenWidth / 4, y: statusBarHeight + (100 / 2 - buttonHeight / 2) + buttonHeight, width: screenWidth / 2 , height: 100 * heightRatio))
        titleLabel.text = "06/01"
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .red
        titleLabel.font = UIFont(name: fontName, size: 80 * heightRatio)
        
        if let title = self.view.subviews[0] as? TitleLabel{
            title.removeFromSuperview()
        }
        
        let entryTableView = UITableView(frame: CGRect(x: 20, y: titleLabel.frame.origin.y + titleLabel.frame.height + 20, width: screenWidth - 40, height: screenHeight - (titleLabel.frame.origin.y + titleLabel.frame.height + 20) - 100))
        entryTableView.dataSource = self
        entryTableView.delegate = self
        self.view.addSubview(titleLabel)
    }
    

}

extension SingleDayViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}
