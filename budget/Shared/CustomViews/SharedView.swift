//
//  SharedView.swift
//  budget
//
//  Created by Bradley Yin on 7/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class TitleLabel : UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.3
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.font = UIFont(name: fontName, size: 50 * heightRatio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(named: "menuButton"), for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
