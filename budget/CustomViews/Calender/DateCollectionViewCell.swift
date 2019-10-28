//
//  DateCollectionViewCell.swift
//  budget
//
//  Created by Bradley Yin on 10/11/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.cornerRadius = 5
        layer.masksToBounds = true
        setupViews()
    }
    
    override func layoutSubviews() {
        if traitCollection.userInterfaceStyle == .light {
            lbl.textColor = .black
        } else {
            lbl.textColor = .white
        }
    }
    
    func setupViews() {
        addSubview(lbl)
        if isToday {
            let circleView = CircleView(frame: CGRect(x: 1,
                                                      y: self.frame.height / 2 - (self.frame.width / 2),
                                                      width: self.frame.width - 2,
                                                      height: self.frame.width - 2))
            circleView.backgroundColor = .clear
            circleView.tag = 1
            self.addSubview(circleView)
        }
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        if let circleView = self.viewWithTag(1) {
            circleView.removeFromSuperview()
        }
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isToday = false {
        didSet {
            setupViews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
