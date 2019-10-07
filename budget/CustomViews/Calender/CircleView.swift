//
//  CircleView.swift
//  budget
//
//  Created by Bradley Yin on 10/6/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            let borderWidth: CGFloat = 3
            context.addEllipse(in: rect)
            context.setFillColor(UIColor.clear.cgColor)
            context.fillPath()
            let strokeRect = CGRect(x: rect.origin.x + borderWidth / 2,
                                    y: rect.origin.y + borderWidth / 2,
                                    width: rect.size.width - borderWidth,
                                    height: rect.size.height - borderWidth)
            context.addEllipse(in: strokeRect)
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(borderWidth)
            context.strokePath()
        }
    }

}
