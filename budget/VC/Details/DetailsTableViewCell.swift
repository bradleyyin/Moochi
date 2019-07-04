//
//  DetailsTableViewCell.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    var categoryTitle : String?
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        self.backgroundColor = .clear
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
