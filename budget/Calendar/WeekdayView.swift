//
//  WeekdayView.swift
//  budget
//
//  Created by Bradley Yin on 7/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class WeekdaysView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //setupUIColor()
    }
    
    func setupViews() {
        addSubview(myStackView)
        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let daysArr = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        for i in 0..<7 {
            let lbl = UILabel()
            lbl.text = daysArr[i].uppercased()
            lbl.textAlignment = .center
            lbl.font = FontPalette.font(size: 13, fontType: .light)
            lbl.textColor = ColorPalette.separatorGray.withAlphaComponent(0.5)
            myStackView.addArrangedSubview(lbl)
        }
    }
    
//    private func setupUIColor() {
//        var textColor: UIColor
//        if traitCollection.userInterfaceStyle == .light {
//            textColor = .black
//        } else {
//            textColor = .white
//        }
//        for i in 0..<7 {
//            guard let label = myStackView.subviews[i] as? UILabel else { continue }
//            label.textColor = textColor
//        }
//    }
    
    let myStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
