////
////  EmptyView.swift
////  budget
////
////  Created by Bradley Yin on 2/6/21.
////  Copyright © 2021 bradleyyin. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//enum EmptyStateTheme {
//    case dark
//    case light
//}
//
//class EmptyStateView: UIView {
//
//    //MARK: Configurable
//    var theme: EmptyStateTheme = .light {
//        didSet {
//            switch theme {
//            case .light:
//                textColor = .black
//                backgroundColor = .white
//            case .dark:
//                textColor = .white
//                backgroundColor = .black
//            }
//        }
//    }
//
//    var text: String? {
//        didSet {
//            textLabel.attributedText = EosFontPalette.attrString(text: text, characterSpacing: -0.3, lineHeight: 29, font: EosFontPalette.XXLargeSemiBold, textColor: textColor)
//            textLabel.textAlignment = .center
//            textLabel.numberOfLines = 0
//            textLabel.lineBreakMode = .byWordWrapping
//            setNeedsLayout()
//        }
//    }
//
//    var prompt: String? {
//        didSet {
//            promptLabel.attributedText = EosFontPalette.attrString(text: prompt, characterSpacing: 0, lineHeight: 18, font: EosFontPalette.minimum, textColor: promptColor)
//            promptLabel.textAlignment = .center
//            promptLabel.numberOfLines = 0
//            promptLabel.lineBreakMode = .byWordWrapping
//            setNeedsLayout()
//        }
//    }
//
//    var icon: UIImage? {
//        didSet {
//            iconView.image = icon
//            setNeedsLayout()
//        }
//    }
//
//    var textColor: UIColor = .black {
//        didSet {
//            textLabel.textColor = textColor
//        }
//    }
//
////    var promptColor: UIColor = EosColorPalette.inactiveBlack {
////        didSet {
////            promptLabel.textColor = promptColor
////        }
////    }
//
//    //MARK: UI
//    private let padding: CGFloat = 60.0
//    private let iconSize: CGFloat = 157.0
//    private let promptWidth: CGFloat = 254.0
//
//    private lazy var iconView: UIImageView = {
//        let view = UIImageView(image: icon)
//        view.contentMode = .scaleAspectFit
//        return view
//    }()
//
//    private lazy var textLabel: UILabel = {
//        let label = UILabel()
//        return label
//    }()
//
//    private lazy var promptLabel: UILabel = {
//        let label = UILabel()
//        return label
//    }()
//
//    init(text: String? = nil, icon: UIImage? = nil) {
//        self.text = text
//        self.icon = icon
//        super.init(frame: .zero)
//        contentMode = .scaleAspectFill
//
//        addSubview(iconView)
//        addSubview(textLabel)
//        addSubview(promptLabel)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let hasIcon = icon != nil
//        let hasPrompt = promptLabel.text != nil && promptLabel.text!.isNotEmpty
//
//        if hasIcon {
//            iconView.snp.remakeConstraints { (make) in
//                make.centerX.equalToSuperview()
//                make.top.equalTo(padding.heightCorrection())
//                make.height.width.equalTo(iconSize.heightCorrection())
//            }
//        }
//
//        textLabel.snp.remakeConstraints { (make) in
//            make.leading.trailing.equalToSuperview()
//            if hasIcon {
//                make.top.equalTo(iconView.snp.bottom).offset(EosSharedUI.verticalPadding * 2)
//            } else {
//                make.top.equalTo(padding.heightCorrection())
//            }
//            if !hasPrompt {
//                make.bottom.equalTo(-padding.heightCorrection())
//            }
//        }
//
//        if hasPrompt {
//            promptLabel.snp.remakeConstraints { (make) in
//                make.top.equalTo(textLabel.snp.bottom).offset(EosSharedUI.verticalPadding * 2)
//                make.width.equalTo(promptWidth.widthCorrection())
//                make.leading.trailing.equalToSuperview()
//                make.bottom.equalTo(-padding.heightCorrection())
//            }
//        }
//    }
//}
