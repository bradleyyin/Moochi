//
//  CategoryCell.swift
//  budget
//
//  Created by Bradley Yin on 8/1/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    weak var titleLabel: UILabel!
    weak var amountLabel: UILabel!

    var expense: Expense? {
        didSet {
            //updateViews()
        }
    }
    
    var fontSize: CGFloat = 25 * heightRatio
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setUpViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setupWith(title: String?, icon: UIImage?, remainingPercent: Double?) {
        
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
    
    private func setupConstraints() {
        
    }
    
//    func updateViews() {
//        guard let expense = expense else { return }
//        titleLabel.text = expense.name
//        amountLabel.text = NSString(format: "%.2f", expense.amount) as String
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconImageView: UIImageView = {}()


}
