//
//  DetailsCategoryCell.swift
//  budget
//
//  Created by Bradley Yin on 10/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import UIKit

class DetailsCategoryCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(percentLabel)
        contentView.addSubview(budgetLabel)
        contentView.addSubview(grayLine)
        contentView.addSubview(transactionLabel)
        grayLine.addSubview(blackLine)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    func setupWith(viewModel: DetailsCategoryCellViewModel) {
        titleLabel.text = viewModel.title
        iconImageView.image = viewModel.icon
        numberLabel.text = viewModel.remainingMoneyText
        percentLabel.text = viewModel.percentText
        budgetLabel.text = viewModel.totalMoneyText
        transactionLabel.text = viewModel.numberOfTransactionText
        blackLine.snp.remakeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(viewModel.percent)
        }
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
        iconImageView.snp.remakeConstraints { (make) in
            make.height.width.equalTo(20)
            make.leading.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(24)
            make.trailing.lessThanOrEqualTo(numberLabel.snp.leading)
            make.height.equalTo(20)
        }

        percentLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }

        budgetLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(percentLabel)
            make.leading.equalTo(percentLabel.snp.trailing).offset(24)
        }

        numberLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }

        transactionLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(numberLabel)
            make.top.equalTo(percentLabel)
        }

        grayLine.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            //make.bottom.equalToSuperview().inset(24)
            make.top.equalTo(iconImageView.snp.bottom).offset(15)
            make.top.equalTo(percentLabel.snp.bottom).offset(4)
            make.height.equalTo(8)
        }

        blackLine.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(200)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 17, fontType: .light)
        return label
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 16, fontType: .medium)
        label.textColor = .black
        return label
    }()

    private lazy var transactionLabel: UILabel = {
        let label = UILabel()
        label.text = "1 transaction"
        label.font = FontPalette.font(size: 13, fontType: .light)
        label.textColor = .gray
        return label
    }()

    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 13, fontType: .light)
        label.textColor = .gray
        return label
    }()

    private lazy var budgetLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 13, fontType: .light)
        label.textColor = .gray
        return label
    }()

    private lazy var grayLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 4
        return view
    }()

    private lazy var blackLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 4
        return view
    }()
}
