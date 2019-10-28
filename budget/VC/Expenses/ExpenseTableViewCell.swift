//
//  ExpenseTableViewCell.swift
//  budget
//
//  Created by Bradley Yin on 7/24/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    weak var titleLabel: UILabel!
    weak var amountLabel: UILabel!

    var expense: Expense? {
        didSet {
            updateViews()
        }
    }
    
    var fontSize: CGFloat = 25 * heightRatio
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIColor()
    }
    
    private func setupUIColor() {
        if traitCollection.userInterfaceStyle == .light {
            titleLabel.textColor = .black
            amountLabel.textColor = .black
        } else {
            titleLabel.textColor = .white
            amountLabel.textColor = .white
        }
    }
    
    func setUpViews() {
        self.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: fontName, size: fontSize)
        titleLabel.textAlignment = .left
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.titleLabel = titleLabel
        
        
        let amountLabel = UILabel()
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.textAlignment = .right
        amountLabel.font = UIFont(name: fontName, size: fontSize)
        self.addSubview(amountLabel)
        amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        amountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.amountLabel = amountLabel
        
    }
    func updateViews() {
        guard let expense = expense else { return }
        titleLabel.text = expense.name
        amountLabel.text = NSString(format: "%.2f", expense.amount) as String
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
