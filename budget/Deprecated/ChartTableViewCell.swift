////
////  ChartTableViewCell.swift
////  budget
////
////  Created by Bradley Yin on 10/28/19.
////  Copyright © 2019 bradleyyin. All rights reserved.
////
//
//import UIKit
//
//class ChartTableViewCell: UITableViewCell {
//
//    var monthLabel: UILabel!
//    var amountLabel: UILabel!
//
//    var expenseDataPair: (String, Double)? {
//        didSet {
//            updateViews()
//        }
//    }
//    
//    var fontSize: CGFloat = 25 * heightRatio
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setUpViews()
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupUIColor()
//    }
//    
//    private func setupUIColor() {
//        if traitCollection.userInterfaceStyle == .light {
//            monthLabel.textColor = .black
//            amountLabel.textColor = .black
//        } else {
//            monthLabel.textColor = .white
//            amountLabel.textColor = .white
//        }
//    }
//    
//    func setUpViews() {
//        self.backgroundColor = .clear
//        
//        let titleLabel = UILabel()
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.font = UIFont(name: fontName, size: fontSize)
//        titleLabel.textAlignment = .left
//        self.addSubview(titleLabel)
//        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
//        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        self.monthLabel = titleLabel
//        
//        
//        let amountLabel = UILabel()
//        amountLabel.translatesAutoresizingMaskIntoConstraints = false
//        amountLabel.textAlignment = .right
//        amountLabel.font = UIFont(name: fontName, size: fontSize)
//        self.addSubview(amountLabel)
//        amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
//        amountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        self.amountLabel = amountLabel
//        
//    }
//    func updateViews() {
//        guard let expenseDataPair = expenseDataPair else { return }
//        monthLabel.text = expenseDataPair.0
//        amountLabel.text = NSString(format: "$%.2f", expenseDataPair.1) as String
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
