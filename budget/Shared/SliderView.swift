//
//  SliderView.swift
//  budget
//
//  Created by Bradley Yin on 8/1/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

protocol SliderViewDelegate: class {
    func didSelectPage(index: Int, title: String)
}

class SliderView: UIView {
    var titleContainerHeight: CGFloat = 29
    var highlightSize: CGFloat = 8.0
    var selectedPageIndex: Int = -1
    var isDarkTheme = true
    var isNarrow = false
    var selectedBarColor: UIColor = .black
    var isInitial = true

    weak var delegate: SliderViewDelegate?
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
        
        backgroundColor = UIColor.black.withAlphaComponent(0.1)

        addSubview(movingView)
        
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
//            if let oldView = titleViewAtIndex(selectedPageIndex) {
//                //oldView.isSelected = false
//            }
            selectedPageIndex = index
        }
        if let newView = titleViewAtIndex(selectedPageIndex) {
            print(newView.frame)
            //newView.isSelected = true
            //Temp: use while there are only 2 selection, change if more in future
            if index == 0 {
                // move moving view to left
                movingView.snp.remakeConstraints { (make) in
                    make.height.equalToSuperview()
                    make.width.equalTo(newView.frame.width)
                    make.leading.equalToSuperview()
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            } else if index == 1 {
                // move moving view to right
                movingView.snp.remakeConstraints { (make) in
                    make.height.equalToSuperview()
                    make.width.equalTo(newView.frame.width)
                    make.trailing.equalToSuperview()
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            }
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
        view.backgroundColor = .clear
        view.axis = .horizontal
        //view.alignment = .fill
        view.distribution = .fillProportionally
        return view
    }()
    
    private lazy var movingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
}
