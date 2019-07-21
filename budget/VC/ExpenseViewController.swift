//
//  ExpenseViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ExpenseViewController: BasicViewController {
    let calenderView: CalenderView = {
        let v=CalenderView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    override func viewDidLoad() {
        titleOfVC = "expenses"
        super.viewDidLoad()
        
        
       
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: (statusBarHeight + 100 * heightRatio)).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 600).isActive=true
        calenderView.backgroundColor = .red
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
}