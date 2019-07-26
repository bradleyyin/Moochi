//
//  AddEntryTableViewCell.swift
//  budget
//
//  Created by Bradley Yin on 7/25/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

protocol AddTableViewCellDelegate{
    func showVC(vc: UIViewController)
}

class AddEntryTableViewCell: UITableViewCell {

    
    var fontSize : CGFloat = 25 * heightRatio
    
    weak var addButton : UIButton!
    
    var delegate : AddTableViewCellDelegate?{
        didSet{
            updateViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        self.backgroundColor = .clear
        
        
    }
    func updateViews() {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+ add an entry", for: .normal)
        
        button.setTitleColor(.white, for: .normal)
        
        button.titleLabel?.font = UIFont(name: fontName, size: fontSize)
        
        button.addTarget(self, action: #selector(addEntryTapped), for: .touchUpInside)
        
        
        self.addSubview(button)
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        
       
        
        
        
        
    }
    @objc func addEntryTapped(){
        delegate?.showVC(vc: AddEntryViewController())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
