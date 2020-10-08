//
//  CategorySelectionCell.swift
//  budget
//
//  Created by Bradley Yin on 10/6/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import UIKit

class CategorySelectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(iconImageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    func setupWith(viewModel: CategorySelectionCellViewModel) {
        titleLabel.text = viewModel.title
        iconImageView.image = viewModel.icon
        if viewModel.isSelected {
            containerView.layer.borderWidth = 1
        } else {
            containerView.layer.borderWidth = 0
        }
        containerView.applyShadow()
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
    
    private func setupConstraints() {
        containerView.snp.remakeConstraints { (make) in
            make.height.equalTo(56)
            make.width.equalTo(84)
            make.center.equalToSuperview()
        }
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }

        iconImageView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.height.width.equalTo(24)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        return label
    }()
}
