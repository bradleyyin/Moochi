//
//  RecieptViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class RecieptViewController: UIViewController {
    
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

        // Do any additional setup after loading the view.
    }
    func setUpView(){
        
        self.view.backgroundColor = .lightGray
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth * heightRatio).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight * heightRatio).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + 20 * heightRatio - buttonHeight / 2).isActive = true
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    @objc func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }

}
