//
//  HomeCategoryCell.swift
//  budget
//
//  Created by Bradley Yin on 8/1/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import UIKit

class HomeCategoryCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(numberLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setupWith(viewModel: HomeCategoryCellViewModel) {
        titleLabel.text = viewModel.title
        iconImageView.image = viewModel.icon
        numberLabel.text = viewModel.remainingMoneyText
        setupCircle(percent: 0.5)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            print(self.iconContainerView.center)
//        }
    }
    
//    private func setupUIColor() {
//        if traitCollection.userInterfaceStyle == .light {
//            titleLabel.textColor = .black
//            amountLabel.textColor = .black
//        } else {
//            titleLabel.textColor = .white
//            amountLabel.textColor = .white
//        }
//    }
    
    private func setupCircle(percent: Double) {
        let center = CGPoint(x: 25, y: 25)
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        
        let trackCircularPath = UIBezierPath(arcCenter: center, radius: 25, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = trackCircularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 2.5
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        iconContainerView.layer.addSublayer(trackLayer)
        
        
        let shapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 25, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * CGFloat(2 * percent - 0.5), clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2.5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        //shapeLayer.strokeEnd = 0
        
        iconContainerView.layer.addSublayer(shapeLayer)
        
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//
//        basicAnimation.toValue = 1
//
//        basicAnimation.duration = 1
//
//        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
//        basicAnimation.isRemovedOnCompletion = false
//
//        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
        //iconContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func setupConstraints() {
        titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconContainerView.snp.trailing).offset(24)
            make.trailing.lessThanOrEqualTo(numberLabel.snp.leading)
        }
        
        numberLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }
        
        iconContainerView.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            //make.height.width.equalTo(50)
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(24)
        }
        
        iconImageView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
//    func updateViews() {
//        guard let expense = expense else { return }
//        titleLabel.text = expense.name
//        amountLabel.text = NSString(format: "%.2f", expense.amount) as String
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
