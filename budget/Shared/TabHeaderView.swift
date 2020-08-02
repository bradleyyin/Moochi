//
//  TabHeaderView.swift
//  budget
//
//  Created by Bradley Yin on 6/13/20.
//  Copyright © 2020 bradleyyin. All rights reserved.

import Foundation
import UIKit

enum TabPageTitleAlignment {
    case center
    case left
}

protocol TabHeaderViewDelegate: class {
    func didSelectPage(index: Int, title: String)
}

class TabHeaderView: UIView {
    var titleContainerHeight: CGFloat = 45
    var highlightSize: CGFloat = 8.0
    var selectedPageIndex: Int = 0
    var isDarkTheme = true
    var isNarrow = false
    var selectedBarColor: UIColor = .black

    weak var delegate: TabHeaderViewDelegate?
    var titleAlignment: TabPageTitleAlignment = .center {
        didSet {
            setupTitleViews()
        }
    }
    var titles: [NSAttributedString] = [] {
        didSet {
            setupTitleViews()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titlesStackView)
        titlesStackView.snp.makeConstraints { (make) -> Void in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(titleContainerHeight)

        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Public

    func titleViewAtIndex(_ index: Int) -> TabPageTitleView? {
        return titlesStackView.arrangedSubviews[index] as? TabPageTitleView
    }

    func setSelectedIndex(_ index: Int) {
        if selectedPageIndex != index {
            if let oldView = titleViewAtIndex(selectedPageIndex) {
                oldView.isSelected = false
            }
            selectedPageIndex = index
        }
        if let newView = titleViewAtIndex(selectedPageIndex) {
            newView.isSelected = true
        }
    }

    //MARK: Private
    @objc private func pageTitleDidTap(sender: UIGestureRecognizer) {
        if let view = sender.view as? TabPageTitleView {
            let index = view.tag
            setSelectedIndex(index)
            delegate?.didSelectPage(index: index, title: titles[index].string)
        }
    }

    private func setupTitleViews() {
        for title in titlesStackView.arrangedSubviews {
            titlesStackView.removeArrangedSubview(title)
            title.removeFromSuperview()
        }
        for (index, title) in titles.enumerated() {
            let view = TabPageTitleView()
            view.title = title
            view.alignment = titleAlignment
            view.highlightSize = highlightSize
            view.tag = index
            view.isDarkTheme = self.isDarkTheme
            view.selectedBarColor = self.selectedBarColor
            let tap = UITapGestureRecognizer(target: self, action: #selector(pageTitleDidTap(sender:)))
            view.addGestureRecognizer(tap)
            view.isUserInteractionEnabled = true
            titlesStackView.addArrangedSubview(view)
        }
    }

    //MARK: UI

    private let titlesStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .white
        view.axis = .horizontal
        view.alignment = .bottom
        view.distribution = .fillProportionally
        return view
    }()
}

class TabPageTitleView: UIView {
    var isDarkTheme = true
    var selectedBarColor: UIColor = .black {
        didSet {
            selectedView.backgroundColor = selectedBarColor
        }
    }

    var alignment: TabPageTitleAlignment = .center {
        didSet {
            switch alignment {
            case .center:
                titleLabel.textAlignment = .center
                titleLabel.snp.remakeConstraints { (make) -> Void in
                    make.edges.equalToSuperview()
                }
            case .left:
                titleLabel.textAlignment = .left
                titleLabel.snp.remakeConstraints { (make) -> Void in
                    make.top.equalToSuperview()
                    make.leading.equalTo(SharedUI.horizontalPadding)
                }
            }
        }
    }

    var highlightSize: CGFloat = 8.0

    var isSelected: Bool = false {
        didSet {
            selectedView.isHidden = !isSelected
            if isSelected {
                if isDarkTheme {
                    titleLabel.textColor = .white
                } else {
                    titleLabel.textColor = .black
                }
            } else {
                titleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            }
        }
    }

    var title: NSAttributedString? {
        didSet {
            titleLabel.attributedText = title
            setNeedsLayout()
        }
    }

    var titleWidth: CGFloat {
        return titleLabel.frame.width + 32
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()

    private lazy var selectedView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.isHidden = !isSelected
        return view
    }()

    init() {
        super.init(frame: .zero)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            //make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

//        addSubview(selectedView)
//        selectedView.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(titleLabel.snp.bottom).offset(SharedUI.verticalPadding * 2)
//            make.centerX.equalTo(titleLabel.snp.centerX)
//            make.width.equalTo(70)
//            make.height.equalTo(SharedUI.borderWidth)
//            make.bottom.equalToSuperview()
//        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
