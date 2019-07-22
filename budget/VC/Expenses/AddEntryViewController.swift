//
//  AddEntryViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class AddEntryViewController: BasicViewController {

    override func viewDidLoad() {
        titleOfVC = "add an entry"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupUI() {
        super.setupUI()
        if let button = self.view.subviews[1] as? MenuButton{
            button.setImage(UIImage(named: "checkMark"), for: .normal)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
