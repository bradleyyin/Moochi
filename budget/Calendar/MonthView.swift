////
////  MonthView.swift
////  budget
////
////  Created by Bradley Yin on 7/20/19.
////  Copyright © 2019 bradleyyin. All rights reserved.
////
//
//import UIKit
//
//protocol MonthViewDelegate: AnyObject {
//    func didChangeMonth(monthIndex: Int, year: Int)
//}
//
//class MonthView: UIView {
//    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
//    var currentMonthIndex = 0
//    var currentYear: Int = 0
//    weak var delegate: MonthViewDelegate?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.clear
//        
//        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
//        currentYear = Calendar.current.component(.year, from: Date())
//        
//        setupViews()
//        
//        //btnLeft.isEnabled=false
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupUIColor()
//    }
//    
//    @objc func goToNextMonth(){
//        currentMonthIndex += 1
//        if currentMonthIndex > 11 {
//            currentMonthIndex = 0
//            currentYear += 1
//        }
//        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
//        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
//    }
//    @objc func goToLastMonth() {
//        currentMonthIndex -= 1
//        if currentMonthIndex < 0 {
//            currentMonthIndex = 11
//            currentYear -= 1
//        }
//        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
//        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
//    }
//    func gotoThisMonth() {
//        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
//        currentYear = Calendar.current.component(.year, from: Date())
//        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
//        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
//    }
//    
//    private func setupUIColor() {
//        if traitCollection.userInterfaceStyle == .light {
//            lblName.textColor = .black
//            btnLeft.setTitleColor(.black, for: .normal)
//            btnRight.setTitleColor(.black, for: .normal)
//        } else {
//            lblName.textColor = .white
//            btnLeft.setTitleColor(.white, for: .normal)
//            btnRight.setTitleColor(.white, for: .normal)
//        }
//        
//    }
//    
//    func setupViews() {
//        self.addSubview(lblName)
//        lblName.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        lblName.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
//        
//        self.addSubview(btnRight)
//        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        btnRight.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        btnRight.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        btnRight.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//        
//        self.addSubview(btnLeft)
//        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        btnLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        btnLeft.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        btnLeft.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//    }
//    
//    var lblName: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "Default Month Year text"
//        lbl.textAlignment = .center
//        lbl.font = UIFont.boldSystemFont(ofSize: 16)
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//    
//    var btnRight: UIButton = {
//        let btn = UIButton()
//        btn.setTitle(">", for: .normal)
//        btn.setTitleColor(superLightGray, for: .highlighted)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.addTarget(self, action: #selector(goToNextMonth), for: .touchUpInside)
//        return btn
//    }()
//    
//    var btnLeft: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("<", for: .normal)
//        btn.setTitleColor(superLightGray, for: .highlighted)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.addTarget(self, action: #selector(goToLastMonth), for: .touchUpInside)
//        btn.setTitleColor(UIColor.lightGray, for: .disabled)
//        return btn
//    }()
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
