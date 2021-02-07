//
//  SearchResultCell.swift
//  budget
//
//  Created by Bradley Yin on 2/1/21.
//  Copyright © 2021 bradleyyin. All rights reserved.
//

import UIKit
class SearchResultCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(separatorView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    func setupWith(viewModel: CalendarExpenseCellViewModel) {
        titleLabel.text = viewModel.name
        numberLabel.text = viewModel.amountText
        categoryLabel.text = viewModel.category
        dateLabel.text = viewModel.dateText
    }

    private func setupConstraints() {
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(numberLabel.snp.leading).offset(-8)
        }

        numberLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }

        dateLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }

        categoryLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing).offset(32)
        }

        separatorView.snp.remakeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 17, fontType: .light)
        label.textColor = ColorPalette.separatorGray
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 13, fontType: .light)
        label.textColor = ColorPalette.separatorGray.withAlphaComponent(0.6)
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 13, fontType: .light)
        label.textColor = ColorPalette.separatorGray.withAlphaComponent(0.6)
        return label
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 17, fontType: .light)
        label.textColor = ColorPalette.separatorGray
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()
}