////
////  MenuTableViewCell.swift
////  budget
////
////  Created by Bradley Yin on 7/3/19.
////  Copyright © 2019 bradleyyin. All rights reserved.
////
//
//import UIKit
//
//class MenuTableViewCell: UITableViewCell {
//
//    var option : MenuOption?
//    var titleLabel : UILabel?
//    var fontSize : CGFloat = 50
//
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//
//
//        self.backgroundColor = .clear
//
//
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width, height: self.frame.height))
//        titleLabel?.backgroundColor = .clear
//        titleLabel?.textColor = .white
//        titleLabel?.font = UIFont(name: fontName, size: fontSize)
//
//        if let option = option {
//            switch option {
//            case .details:
//                titleLabel?.text = "DETAILS"
//            case .expenses:
//                titleLabel?.text = "EXPENSES"
//            case .addAnEntry:
//                titleLabel?.text = "ADD AN ENTRY"
//            case .receiptAlbum:
//                titleLabel?.text = "RECEIPT ALBUM"
//            }
//
//
//        }
//        self.addSubview(titleLabel!)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//

//
//
//}
