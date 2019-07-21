//
//  DetailsTableViewCell.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    var categoryTitle : String = ""
    var categoryTotal : Double = 0.0
    var categoryRemaining: Double = 0.0
    var fontSize : CGFloat = 30
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        self.backgroundColor = .clear
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: self.frame.width / 2, height: self.frame.height / 2 - 10))
        titleLabel.text = categoryTitle.uppercased()
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: fontName, size: fontSize)
        titleLabel.textAlignment = .left
        
        let totalLabel = UILabel(frame: CGRect(x: self.frame.width / 2, y: 10, width: self.frame.width / 2, height: self.frame.height / 2 - 10))
        totalLabel.textAlignment = .right
        totalLabel.textColor = .darkGray
        totalLabel.text = NSString(format:"%.2f", categoryTotal) as String
        totalLabel.font = UIFont(name: fontName, size: fontSize)
        
        let whiteBarView = UIView(frame: CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height / 2))
        whiteBarView.backgroundColor = .white
        
        let blackRatio = CGFloat((categoryTotal - categoryRemaining) / categoryTotal)
        
        let blackBarView = UIView(frame: CGRect(x: self.frame.width * (1.0 - blackRatio) , y: 0, width: self.frame.width * blackRatio, height: self.frame.height / 2))
        blackBarView.backgroundColor = .darkGray
        
        let remainLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 100, height: blackBarView.frame.height))
        remainLabel.text = blackBarView.frame.width >= 100.0 ? NSString(format:"%.2f", categoryRemaining) as String : ""
        remainLabel.textColor = .white
        remainLabel.font = UIFont(name: fontName, size: fontSize)
        remainLabel.textAlignment = .left
        
        
        self.addSubview(titleLabel)
        self.addSubview(totalLabel)
        blackBarView.addSubview(remainLabel)
        whiteBarView.addSubview(blackBarView)
        self.addSubview(whiteBarView)
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
