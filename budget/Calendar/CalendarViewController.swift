//
//  CalendarViewController.swift
//  budget
//
//  Created by Bradley Yin on 11/21/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

protocol CalendarViewControllerDelegate: class {
    func didTapAdd()
}

class CalendarViewController: UIViewController {

    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    let dependency: Dependency

    weak var delegate: CalendarViewControllerDelegate?
    private var viewModel: CalendarViewModel
    private var disposeBag = DisposeBag()

    init(dependency: Dependency) {
        self.dependency = dependency
        self.viewModel = CalendarViewModel(dependency: dependency)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(todayButton)
        view.addSubview(searchButton)
        view.addSubview(plusButton)
        view.addSubview(monthCollectionView)
        view.addSubview(weekdayView)
        view.addSubview(calendarView)
        view.addSubview(pullUpContainerView)

        setupConstraints()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        sliderView.setSelectedIndex(0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUIColor()
    }
    private func setupUIColor() {
//        if traitCollection.userInterfaceStyle == .light {
//            self.view.backgroundColor = .white
//            incomeNotBudgetLabel.textColor = .black
//            screenTitleLabel.textColor = .black
//            addCategoryButton.setTitleColor(.black, for: .normal)
//        } else {
//            self.view.backgroundColor = .black
//            incomeNotBudgetLabel.textColor = .white
//            screenTitleLabel.textColor = .white
//            addCategoryButton.setTitleColor(.white, for: .normal)
//        }
    }

    private func setupConstraints() {
        todayButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(top).inset(10)
        }

        searchButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(36)
            make.trailing.equalTo(plusButton.snp.leading).offset(-8)
            make.centerY.equalTo(todayButton)
        }

        plusButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(36)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalTo(todayButton)
        }

        monthCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(plusButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        weekdayView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(monthCollectionView.snp.bottom).offset(16)
        }

        calendarView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(weekdayView.snp.bottom).offset(16)
            make.height.equalTo(300)
        }

        pullUpContainerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(weekdayView.snp.bottom).offset(60)
        }
    }

    private func setupBinding() {
        viewModel.currentDate.asObservable().subscribe(onNext: { [weak self] date in
            guard let self = self else { return }
            self.monthCollectionView.reloadData()
            if self.viewModel.currentMonth != self.viewModel.prevMonth {
                self.calendarView.didChangeMonth(monthIndex: self.viewModel.currentMonth, year: self.viewModel.currentYear)
                self.viewModel.prevMonth = self.viewModel.currentMonth
            }
            
            self.viewModel.getExpenses(of: date)
        }).disposed(by: disposeBag)

        viewModel.dailyExpense.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    @objc private func plusButtonTapped() {
        delegate?.didTapAdd()
    }

    @objc private func searchButtonTapped() {
        let vc = SearchExpensesViewController()
        self.present(vc, animated: true, completion: nil)
    }

    @objc private func todayButtonTapped() {

    }

    @objc private func pullUpContainerPulled(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.pullUpContainerView)
        let totalDistance: CGFloat = 20
        switch sender.state {
        case .changed:
//            if tableView.contentOffset.y > totalDistance + itemFeedTopOffset && translation.y > 0 {
//                return
//            } else {
               // if !viewModel.isSearch {
                    //studio moving up
//                    let maxY = max(lastFeedContainerY + translation.y, (headerView.frame.maxY - (studioTabHeight + paddingBetweenStudioAndDepartment)))
//                    let minY = min(headerView.frame.maxY, maxY)
//                    let studioY = initialStudioLabelFrame.origin.y - (initialFeedContainerFrame.origin.y - minY)
//                    let distanceTravel = studioLabelThreshold - studioY
            pullUpContainerView.snp.remakeConstraints { (make) in
                make.bottom.leading.trailing.equalToSuperview()
                make.top.equalTo(calendarView.snp.bottom)
            }

                    UIView.animate(withDuration: 0.5) {
//                        self.feedContainerView.frame.origin.y = minY
//                        self.studioLabel.frame.origin.y = studioY
//                        self.studioLabel.alpha = distanceTravel / totalDistance
                        self.view.layoutIfNeeded()
                    }
//                    lastFeedContainerY = feedContainerView.frame.minY
//                    sender.setTranslation(CGPoint(x: 0, y: 0), in: self.feedContainerView)
              //  }
           // }
        case .ended, .failed, .cancelled:
//            if !viewModel.isSearch {
//                if sender.velocity(in: self.feedContainerView).y > translation.y {
//                    UIView.animate(withDuration: 0.5) {
//                        self.feedContainerView.frame = self.initialFeedContainerFrame
//                        self.studioLabel.frame = self.initialStudioLabelFrame
//                        self.studioLabel.alpha = 0
//                    }
//                }
//
//                lastFeedContainerY = feedContainerView.frame.minY
//            }
            pullUpContainerView.snp.remakeConstraints { (make) in
                make.bottom.leading.trailing.equalToSuperview()
                make.top.equalTo(calendarView.snp.bottom)
            }

            UIView.animate(withDuration: 0.5) {
//                        self.feedContainerView.frame.origin.y = minY
//                        self.studioLabel.frame.origin.y = studioY
//                        self.studioLabel.alpha = distanceTravel / totalDistance
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }

    @objc private func monthViewSwipped(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            guard let nextMonthToday = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.currentDate.value) else { return }
            viewModel.currentDate.accept(nextMonthToday)
        } else if gesture.direction == .right {
            guard let lastMonthToday = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.currentDate.value) else { return }
            viewModel.currentDate.accept(lastMonthToday)
        }
    }

    //MARK: UI
    private let weekdayView = WeekdaysView()

//    private lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Monthly Details"
//        return label
//    }()

    private lazy var calendarView: CalendarView = {
        let view = CalendarView()
        view.delegate = self
        return view
    }()

    private lazy var todayButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(FontPalette.attrString(text: "Today", characterSpacing: -0.41, lineHeight: 22, fontSize: 17, fontType: .regular, textColor: .black), for: .normal)
        button.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "search"), for: .normal)
        return button
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "calendar_add"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return button
    }()

    private lazy var pullUpContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        let pullUpIndicator = UIView()
        pullUpIndicator.backgroundColor = ColorPalette.indicatorGray
        view.addSubview(pullUpIndicator)
        pullUpIndicator.snp.makeConstraints { (make) in
            make.height.equalTo(3)
            make.width.equalTo(43)
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }

        view.addSubview(sliderView)
        sliderView.snp.makeConstraints { (make) in
            make.top.equalTo(pullUpIndicator.snp.bottom).offset(32)
            make.height.equalTo(29)
            make.centerX.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(sliderView.snp.bottom).offset(32)
        }

        let pull = UIPanGestureRecognizer(target: self, action: #selector(pullUpContainerPulled))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(pull)
        return view
    }()

    private lazy var sliderView: SliderView = {
        let view = SliderView()
        view.titles = [NSAttributedString(string: "Category"), NSAttributedString(string: "Goal")]
        view.layer.cornerRadius = 15
        return view
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = self
        view.delegate = self
        view.register(CalendarExpenseCell.self, forCellReuseIdentifier: "expenseCell")
        return view
    }()

    private lazy var monthCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 48
        layout.minimumLineSpacing = 48
        layout.sectionInset = UIEdgeInsets(top: 0, left: view.frame.width / 2 - 26, bottom: 0, right: view.frame.width / 2 - 26)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.alwaysBounceVertical = false
        view.dataSource = self
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "monthCell")
        return view
    }()

    private var isInitialLaunch = true
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyExpense.value.count
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let context = CoreDataStack.shared.mainContext
//
//        context.delete(fetchedResultsController.object(at: indexPath))
//
//        //TODO: run delete in controller
//
//        tableView.reloadData()
//
//    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .destructive, title: "") { _, _, _ in
//
//            self.viewModel.deleteCategory(at: indexPath)
//        }
//
//        delete.image = UIImage(named: "deleteIcon")?.withTintColor(.white)
//        delete.backgroundColor = ColorPalette.red
//        let edit = UIContextualAction(style: .normal, title: "edit") { _, _, _ in
//            let category = self.viewModel.categories.value[indexPath.row]
//            //self.delegate?.editCategoryTapped(category: category)
//        }
//
//        edit.image = UIImage(named: "edit")
//        edit.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.1)
//        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
//
//        return swipeActions
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as? CalendarExpenseCell else {
            fatalError("cant make CalendarExpenseCell")
        }
        let cellViewModel = viewModel.configureExpenseCellViewModel(at: indexPath)
        cell.setupWith(viewModel: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let category = viewModel.categories.value[indexPath.row]
        //delegate?.categoryTapped(category: category)
//        let category = fetchedResultsController.fetchedObjects?[indexPath.row]
//        let chartVC = ChartViewController()
//        chartVC.category = category
//        self.navigationController?.pushViewController(chartVC, animated: true)
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.monthArrayToDisplay.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        let label = UILabel()
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        if indexPath.item == viewModel.currentMonthDisplayIndex {
            label.attributedText = FontPalette.attrString(text: viewModel.monthArrayToDisplay[indexPath.item], characterSpacing: -1, lineHeight: 24, fontSize: 30, fontType: .medium, textColor: .black)
        } else {
            label.attributedText = FontPalette.attrString(text: viewModel.monthArrayToDisplay[indexPath.item], characterSpacing: -1, lineHeight: 24, fontSize: 30, fontType: .medium, textColor: ColorPalette.separatorGray.withAlphaComponent(0.3))
        }

        if isInitialLaunch {
            isInitialLaunch.toggle()
            collectionView.scrollToItem(at: IndexPath(item: 6, section: 0), at: .centeredHorizontally, animated: false)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == monthCollectionView {
            let index = indexPath.item
                monthCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
                guard let targetMonthToday = Calendar.current.date(byAdding: .month, value: index - viewModel.currentMonthIndex, to: viewModel.currentDate.value) else { return }
            viewModel.currentMonthIndex = index
                viewModel.currentDate.accept(targetMonthToday)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = viewModel.monthArrayToDisplay[indexPath.item]
        let estimatedSize = text.size(withAttributes:[NSAttributedString.Key.font : UIFont(name: FontPalette.FontType.medium.rawValue, size: 30)])
        return CGSize(width: 52, height: 44)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == monthCollectionView {
//            if scrollView.contentOffset.x > 20 {
//                guard let nextMonthToday = Calendar.current.date(byAdding: .month, value: 1, to: Date()) else { return }
//                viewModel.currentMonth = Calendar.current.component(.month, from: nextMonthToday)
//                monthCollectionView.reloadData()
//            } else if scrollView.contentOffset.x < 5 {
//                guard let lastMonthToday = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else { return }
//                viewModel.currentMonth = Calendar.current.component(.month, from: lastMonthToday)
//                monthCollectionView.reloadData()
//            }
//        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && scrollView == monthCollectionView {
            let sidePadding = view.frame.width / 2 - 26
            if scrollView.contentOffset.x < (50) {
                monthCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            } else if scrollView.contentOffset.x >= 50 && scrollView.contentOffset.x <= 1160 {
                let index = Int((scrollView.contentOffset.x - 50) / 100 + 1)
                guard let targetMonthToday = Calendar.current.date(byAdding: .month, value: index - viewModel.currentMonthIndex, to: viewModel.currentDate.value) else { return }
                viewModel.currentMonthIndex = index
                viewModel.currentDate.accept(targetMonthToday)
                monthCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }

    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == monthCollectionView {
            if scrollView.contentOffset.x < (50) {
                monthCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            } else if scrollView.contentOffset.x >= 50 && scrollView.contentOffset.x <= 1160 {
                let index = Int((scrollView.contentOffset.x - 50) / 100 + 1)
                monthCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
                guard let targetMonthToday = Calendar.current.date(byAdding: .month, value: index - viewModel.currentMonthIndex, to: viewModel.currentDate.value) else { return }
                viewModel.currentMonthIndex = index
                viewModel.currentDate.accept(targetMonthToday)

    //            guard let lastMonthToday = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.currentDate.value) else { return }
    //            viewModel.currentDate.accept(lastMonthToday)
            }
        }

    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 48
//    }
}

extension CalendarViewController: CalendarDelegate {
    func goToSingleDay(date: Date) {
        viewModel.currentDate.accept(date)
    }
}
