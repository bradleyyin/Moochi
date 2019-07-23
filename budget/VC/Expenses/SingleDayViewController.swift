//
//  SingleDayViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class SingleDayViewController: BasicViewController {
    
    var date : Date?
    
    var dateString : String = ""
    
    weak var titleLabel: TitleLabel!
    


    override func viewDidLoad() {
        titleOfVC = "here"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        if let date = date{
            dateString = dateFormatter.string(from: date)
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupUI() {
        super.setupUI()
        
        let label = TitleLabel(frame: .zero)
        self.view.addSubview(label)


        //label.heightAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        //label.widthAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusBarHeight + 70 * heightRatio).isActive = true
        //label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)


        self.titleLabel = label
        
        self.titleLabel.text = dateString
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .black
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
