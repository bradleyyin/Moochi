//
//  AddEntryTableViewCell.swift
//  budget
//
//  Created by Bradley Yin on 7/25/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

enum CellType {
    case addEntry
    case addCategory
}

protocol AddTableViewCellDelegate{
    func showVC(vc: UIViewController?)
}

class AddEntryTableViewCell: UITableViewCell {

    
    var fontSize : CGFloat = 25 * heightRatio
    
    var cellType : CellType = .addEntry{
        didSet{
            updateViews()
        }
    }
    
    weak var addButton : UIButton!
    
    var delegate : AddTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        self.backgroundColor = .clear
        
        
    }
    func updateViews() {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if cellType == .addEntry{
            button.setTitle("+ add an entry", for: .normal)
        }else {
            button.setTitle("+ add a category", for: .normal)
        }
        
        
        button.setTitleColor(.black, for: .normal)
        
        button.titleLabel?.font = UIFont(name: fontName, size: fontSize)
        
        button.addTarget(self, action: #selector(addEntryTapped), for: .touchUpInside)
        
        
        self.addSubview(button)
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
     
    }
    @objc func addEntryTapped(){
        if cellType == .addEntry{
            delegate?.showVC(vc: AddEntryViewController())
        }else{
            delegate?.showVC(vc: nil)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
