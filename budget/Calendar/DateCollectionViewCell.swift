//
//  DateCollectionViewCell.swift
//  budget
//
//  Created by Bradley Yin on 10/11/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    var isToday = false
    var cellIsSelected = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 6
        layer.masksToBounds = true
        contentView.addSubview(containerView)
        containerView.addSubview(lbl)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
//        if traitCollection.userInterfaceStyle == .light {
//            lbl.textColor = .black
//        } else {
//            lbl.textColor = .white
//        }
//        if isToday {
//            lbl.textColor = .lightGray
//        }

        if cellIsSelected {
            //containerView.backgroundColor = .black
            containerView.applyShadow(offset: 4, radius: 6, color: UIColor.black.withAlphaComponent(0.1).cgColor)
            //lbl.textColor = .white
        } else {
            //containerView.backgroundColor = .clear
            containerView.removeShadow()
            //lbl.textColor = .black
        }


    }
    
    func setupViews() {
        containerView.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(4)
            make.height.equalTo(containerView.snp.width)
            make.centerY.equalToSuperview()
            //make.leading.top.equalToSuperview()
            //make.trailing.bottom.equalToSuperview().inset(4)
        }
        
        lbl.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func setupWith(text: String, isSelected: Bool) {
        lbl.text = text
        cellIsSelected = isSelected
        if isSelected {
            containerView.backgroundColor = .black
            lbl.textColor = .white
        } else {
            containerView.backgroundColor = .clear
            lbl.textColor = .black
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isToday = false
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = FontPalette.font(size: 20, fontType: .light)
        return label
    }()
//    override var isSelected: Bool {
//        didSet {
//            setupViews()
//
//        }
//    }

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
