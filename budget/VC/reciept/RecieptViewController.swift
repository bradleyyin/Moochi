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
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }
    @objc func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }

}
