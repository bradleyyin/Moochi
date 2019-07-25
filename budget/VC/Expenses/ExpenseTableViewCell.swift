//
//  ExpenseTableViewCell.swift
//  budget
//
//  Created by Bradley Yin on 7/24/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    var expense : Expense? {
        didSet{
            updateViews()
        }
    }
    
    var fontSize : CGFloat = 25 * heightRatio
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        self.backgroundColor = .clear
        
        
    }
    func updateViews() {
        guard let expense = expense else{return}
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = expense.name
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: fontName, size: fontSize)
        titleLabel.textAlignment = .left
        
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        
        let amountLabel = UILabel()
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.textAlignment = .right
        amountLabel.textColor = .black
        amountLabel.text = NSString(format:"%.2f", expense.amount) as String
        amountLabel.font = UIFont(name: fontName, size: fontSize)
        
        self.addSubview(amountLabel)
        amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        amountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
