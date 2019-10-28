//
//  ExpenseViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ExpenseViewController: BasicViewController, CalenderDelegate {
    let calenderView: CalenderView = {
        let v = CalenderView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        titleOfVC = "expenses"
        super.viewDidLoad()
       
        configureCalenderView()
        setupConstraints()
    }
    private func configureCalenderView() {
        view.addSubview(calenderView)
        
        calenderView.backgroundColor = .clear
        calenderView.delegate = self
    }
    private func setupUIColor() {
        if traitCollection.userInterfaceStyle == .light {
            screenTitleLabel.textColor = .black
            self.view.backgroundColor = .white
        } else {
            screenTitleLabel.textColor = .white
            self.view.backgroundColor = .black
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUIColor()
    }
    private func setupConstraints() {
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: (statusBarHeight + 100 * heightRatio)).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        calenderView.heightAnchor.constraint(equalToConstant: 600 * heightRatio).isActive = true
    }
    func goToSingleDay(date: Date) {
        let singleDayVC = SingleDayViewController()
        singleDayVC.date = date
        singleDayVC.budgetController = budgetController
        self.navigationController?.pushViewController(singleDayVC, animated: true)
    }
}
