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
        self.tabBar.backgroundColor = .clear
        switchTo(.home)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.addSubview(tabBarContainerView)
        tabBarContainerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(20)
        }

        //tabBar.addSubview(tabBarSeperator)
//        tabBarSeperator.snp.makeConstraints { (make) in
//            make.height.equalTo(SharedUI.borderWidth)
//            make.leading.trailing.equalToSuperview().inset(SharedUI.horizontalPadding)
//            make.top.equalToSuperview()
//        }

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
        //addGradient()
    }

    func switchTo(_ tab: TabItem) {
        selectedIndex = tab.rawValue
        didSelect(index: tab.rawValue, isCurrentTab: false)
    }

    //MARK: Actions
    @objc func tabButtonTapped(sender: UIButton) {
        print(sender.tag)
        didSelect(index: sender.tag, isCurrentTab: self.selectedIndex == sender.tag)
        self.selectedIndex = sender.tag
    }

    private func didSelect(index: Int, isCurrentTab: Bool) {
        print(index)
        if let tab = TabItem(rawValue: index) {
            //reset
            homeImageView.image = unselectedHomeImage
            detailsImageView.image = unselectedDetailsImage
            addImageView.image = unselectedAddImage
            calendarImageView.image = unselectedCalendarImage
            goalImageView.image = unselectedGoalImage
            
            switch tab {
            case .home:
                homeImageView.image = selectedHomeImage
            case .details:
                detailsImageView.image = selectedDetailsImage
            case .add:
                addImageView.image = selectedAddImage
            case .calendar:
                calendarImageView.image = selectedCalendarImage
            case .goal:
                goalImageView.image = selectedGoalImage
            }

            actionDelegate?.didTapTab(item: tab, isCurrentTab: isCurrentTab)
        }
    }
//
//    private func addGradient() {
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [
//            UIColor(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor,
//            UIColor(red: 1, green: 1, blue: 1, alpha: 0.9).cgColor
//        ]
//        gradient.locations = [0.0 , 0.76]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
//        gradient.frame = CGRect(x: 0.0, y: 0.0, width: tabBar.frame.size.width, height: tabBar.frame.height)
//        tabBar.layer.insertSublayer(gradient, at: 0)
//    }

    // MARK: UI
    private let tabButtonWidth: CGFloat = (UIScreen.main.bounds.width - SharedUI.horizontalPadding * 6) / CGFloat(TabItem.allCases.count)
    private let tabButtonImageSize: CGFloat = 42.5
    private let tabButtonProfileSize: CGFloat = 20
    var tabButtonBottomInset: CGFloat {
        return view.safeAreaInsets.bottom
    }
    
    private lazy var tabBarContainerView: UIView  = {
        let view = UIView()
        view.backgroundColor = ColorPalette.tabBarGray
        view.layer.cornerRadius = 20
        return view
    }()

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

    private lazy var unselectedHomeImage: UIImage? =
        UIImage(named: "unselected_home")
    
    private lazy var selectedHomeImage: UIImage? =
    UIImage(named: "selected_home")

    private lazy var homeImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = unselectedHomeImage
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var detailsButton: UIButton = {
        let button = UIButton()
        button.tag = TabItem.details.rawValue
        button.addTarget(self, action: #selector(tabButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var unselectedDetailsImage: UIImage? =
        UIImage(named: "unselected_details")
    
    private lazy var selectedDetailsImage: UIImage? =
    UIImage(named: "selected_details")

    private lazy var detailsImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = unselectedDetailsImage
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.tag = TabItem.add.rawValue
        button.addTarget(self, action: #selector(tabButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var unselectedAddImage: UIImage? =
        UIImage(named: "unselected_add")
    
    private lazy var selectedAddImage: UIImage? =
    UIImage(named: "selected_add")

    private lazy var addImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = unselectedAddImage
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.tag = TabItem.calendar.rawValue
        button.addTarget(self, action: #selector(tabButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var unselectedCalendarImage: UIImage? =
        UIImage(named: "unselected_calendar")
    
    private lazy var selectedCalendarImage: UIImage? =
    UIImage(named: "selected_calendar")

    private lazy var calendarImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = unselectedCalendarImage
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var goalButton: UIButton = {
        let button = UIButton()
        button.tag = TabItem.goal.rawValue
        button.addTarget(self, action: #selector(tabButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var unselectedGoalImage: UIImage? =
        UIImage(named: "unselected_goal")
    
    private lazy var selectedGoalImage: UIImage? =
    UIImage(named: "selected_goal")

    private lazy var goalImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = unselectedGoalImage
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
