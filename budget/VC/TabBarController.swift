//
//  TabBarController.swift
//  budget
//
//  Created by Bradley Yin on 10/12/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//
import UIKit
import SnapKit
import RxSwift

enum TabItem: Int, CustomStringConvertible, CaseIterable {
    case home
    case details
    case add
    case calendar
    case goal
    
    var description: String {
        switch self {
        case .home: return "home"
        case .details: return "details"
        case .add: return "add"
        case .calendar: return "calendar"
        case .goal: return "goal"
        }
    }
}

protocol TabBarActionDelegate: class {
    func didTapTab(item: TabItem, isCurrentTab: Bool)
}

class TabBarController: UITabBarController {
    weak var actionDelegate: TabBarActionDelegate?

    var disposeBag = DisposeBag()

    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
        self.viewControllers = viewControllers
        self.tabBar.isTranslucent = true
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        switchTo(.home)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.addSubview(tabBarSeperator)
        tabBarSeperator.snp.makeConstraints { (make) in
            make.height.equalTo(SharedUI.borderWidth)
            make.leading.trailing.equalToSuperview().inset(SharedUI.horizontalPadding)
            make.top.equalToSuperview()
        }

        tabBar.addSubview(homeButton)
        homeButton.snp.makeConstraints { (make) in
            make.width.equalTo(tabButtonWidth)
            make.leading.equalTo(SharedUI.horizontalPadding * 3)
            make.top.bottom.equalToSuperview()
        }

        homeButton.addSubview(homeImageView)
        homeImageView.snp.makeConstraints { (make) in
            make.height.equalTo(tabButtonImageSize)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-tabButtonBottomInset/2)
        }

        tabBar.addSubview(detailsButton)
        detailsButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(tabButtonWidth)
            make.leading.equalTo(homeButton.snp.trailing)
        }

        detailsButton.addSubview(detailsImageView)
        detailsImageView.snp.makeConstraints { (make) in
            make.height.equalTo(tabButtonImageSize)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-tabButtonBottomInset/2)
        }

        tabBar.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(tabButtonWidth)
            make.leading.equalTo(detailsButton.snp.trailing)
        }

        addButton.addSubview(addImageView)
        addImageView.snp.makeConstraints { (make) in
            make.height.equalTo(tabButtonImageSize)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-tabButtonBottomInset/2)
        }
        
        tabBar.addSubview(calendarButton)
        calendarButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(tabButtonWidth)
            make.leading.equalTo(addButton.snp.trailing)
        }

        calendarButton.addSubview(calendarImageView)
        calendarImageView.snp.makeConstraints { (make) in
            make.height.equalTo(tabButtonImageSize)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-tabButtonBottomInset/2)
        }
        
        tabBar.addSubview(goalButton)
        goalButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(tabButtonWidth)
            make.leading.equalTo(calendarButton.snp.trailing)
        }

        goalButton.addSubview(goalImageView)
        goalImageView.snp.makeConstraints { (make) in
            make.height.equalTo(tabButtonImageSize)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-tabButtonBottomInset/2)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addGradient()
    }

    func switchTo(_ tab: TabItem) {
        selectedIndex = tab.rawValue
        didSelect(index: tab.rawValue, isCurrentTab: false)
    }

    //MARK: Actions
    @objc func tabButtonTapped(sender: UIButton) {
        didSelect(index: sender.tag, isCurrentTab: self.selectedIndex == sender.tag)
        self.selectedIndex = sender.tag
    }

    private func didSelect(index: Int, isCurrentTab: Bool) {
        if let tab = TabItem(rawValue: index) {
            //reset
            homeImageView.image = homeImage
            detailsImageView.image = detailsImage
            addImageView.image = addImage
            calendarImageView.image = calendarImage
            goalImageView.image = goalImage
            
            switch tab {
            case .home:
                homeImageView.image = homeImage
            case .details:
                detailsImageView.image = detailsImage
            case .add:
                addImageView.image = addImage
            case .calendar:
                calendarImageView.image = calendarImage
            case .goal:
                goalImageView.image = goalImage
            }

            actionDelegate?.didTapTab(item: tab, isCurrentTab: isCurrentTab)
        }
    }

    private func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.9).cgColor
        ]
        gradient.locations = [0.0 , 0.76]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: tabBar.frame.size.width, height: tabBar.frame.height)
        tabBar.layer.insertSublayer(gradient, at: 0)
    }

    // MARK: UI
    private let tabButtonWidth: CGFloat = (UIScreen.main.bounds.width - SharedUI.horizontalPadding * 6) / CGFloat(TabItem.allCases.count)
    private let tabButtonImageSize: CGFloat = 42.5
    private let tabButtonProfileSize: CGFloat = 20
    var tabButtonBottomInset: CGFloat {
        return view.safeAreaInsets.bottom
    }

    private lazy var tabBarSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    private lazy var homeButton: UIButton = {
        let button = UIButton()
        button.tag = TabItem.home.rawValue
        button.addTarget(self, action: #selector(tabButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var homeImage: UIImage =
        UIImage(named: "eos_tab_home")!

    private lazy var homeImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = homeImage
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var detailsButton: UIButton = {
        let button = UIButton()
        button.tag = TabItem.details.rawValue
        button.addTarget(self, action: #selector(tabButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var detailsImage: UIImage =
        UIImage(named: "eos_tab_your_studio")!

    private lazy var detailsImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = detailsImage
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.tag = TabItem.add.rawValue
        button.addTarget(self, action: #selector(tabButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var addImage: UIImage =
        UIImage(named: "eos_tab_your_studio")!

    private lazy var addImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = addImage
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.tag = TabItem.calendar.rawValue
        button.addTarget(self, action: #selector(tabButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var calendarImage: UIImage =
        UIImage(named: "eos_tab_your_studio")!

    private lazy var calendarImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = calendarImage
        view.contentMode = .scaleAspectFit
        return view
    }()


    private lazy var goalButton: UIButton = {
        let button = UIButton()
        button.tag = TabItem.goal.rawValue
        button.addTarget(self, action: #selector(tabButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var goalImage: UIImage =
        UIImage(named: "eos_tab_settings")!

    private lazy var goalImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = goalImage
        view.contentMode = .scaleAspectFit
        return view
    }()
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController), let tab = TabItem(rawValue: index) {
            didSelect(index: index, isCurrentTab: self.selectedIndex == index)
        }
        return true
    }
}
