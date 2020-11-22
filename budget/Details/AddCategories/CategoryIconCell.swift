//
//  CategoryIconCell.swift
//  budget
//
//  Created by Bradley Yin on 10/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import UIKit

class CategoryIconCell: UICollectionViewCell {
    private var viewModel: CategoryIconCellViewModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        if let selected = viewModel?.isSelected, selected {
            containerView.applyShadowWithOffset(4)
        } else {
            containerView.removeShadow()
        }
    }

    func setupWith(viewModel: CategoryIconCellViewModel) {
        self.viewModel = viewModel
        iconImageView.image = viewModel.icon
        containerView.backgroundColor = viewModel.backgroundColor
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
            make.edges.equalToSuperview().inset(10)
        }

        iconImageView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
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
