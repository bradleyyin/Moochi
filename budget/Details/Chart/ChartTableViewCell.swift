//
//  ChartTableViewCell.swift
//  budget
//
//  Created by Bradley Yin on 10/28/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ChartTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(seperatorView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    func setupWith(viewModel: ChartCellViewModel) {
        titleLabel.text = viewModel.title
        amountLabel.text = viewModel.amountString
        dateLabel.text = viewModel.dateString
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().inset(16)
        }

        amountLabel.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview().inset(16)
        }

        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
        }

        seperatorView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 17, fontType: .light)
        label.textAlignment = .left
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 17, fontType: .light)
        label.textAlignment = .left
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 13, fontType: .regular)
        label.textAlignment = .left
        label.textColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return label
    }()

    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()
}
