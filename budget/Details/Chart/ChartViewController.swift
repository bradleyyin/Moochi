//
//  ViewController.swift
//  budget
//
//  Created by Bradley Yin on 10/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import ScrollableGraphView
import RxSwift
import RealmSwift

class ChartViewController: UIViewController {

    var expensesTableView: UITableView!

    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    private let dependency: Dependency
    private let disposeBag = DisposeBag()

    private var viewModel: ChartViewModel
    //weak var delegate: AddEntryViewControllerDelegate?

    init(category: Category, dependency: Dependency) {
        self.dependency = dependency
        self.viewModel = ChartViewModel(category: category, dependency: dependency)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(chartView)
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(seperatorView)

        setupConstraints()
        //NotificationCenter.default.addObserver(self, selector: #selector(loadExpenses), name: NSNotification.Name("changedEntry"), object: nil)
        // Do any additional setup after loading the view.
    }

    private func setupBinding() {

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupUI()
    }

    private func setupConstraints() {
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(top)
            make.leading.equalToSuperview()
            make.height.width.equalTo(42)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }

        chartView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(209)
        }

        seperatorView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(chartView.snp.bottom)
            make.height.equalTo(1)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(seperatorView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }

    private func setupUI() {
//        if traitCollection.userInterfaceStyle == .light {
//            view.backgroundColor = .white
//            titleLabel.textColor = .black
//            backButton.tintColor = .black
//        } else {
//            view.backgroundColor = .black
//            titleLabel.textColor = .white
//            backButton.tintColor = .white
//        }
//        setupGraph()
//        setupConstraint()
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = TitleLabel()
        label.text = viewModel.screenTitleText
        label.textAlignment = .right
        return label
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(ChartTableViewCell.self, forCellReuseIdentifier: "expenseChartCell")
        view.separatorStyle = .none
        //view.allowsSelection = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var chartView: ScrollableGraphView = {
        let graphView = ScrollableGraphView(frame: CGRect(x: 10, y: 10, width: 300, height: 500), dataSource: self)
        //graphView
        let linePlot = LinePlot(identifier: "Line")
        let referenceLines = ReferenceLines()
        referenceLines.shouldShowReferenceLines = false

        let dotPlot = DotPlot(identifier: "Dot") // Add dots as well.
        dotPlot.dataPointSize = 5
//        if traitCollection.userInterfaceStyle == .light {
//            dotPlot.dataPointFillColor = UIColor.black
//            linePlot.lineColor = .black
//            referenceLines.dataPointLabelColor = .black
//        } else {
//            dotPlot.dataPointFillColor = UIColor.white
//            linePlot.lineColor = .white
//            referenceLines.dataPointLabelColor = .white
//
//        }

        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        linePlot.adaptAnimationType = .elastic
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.direction = .rightToLeft
        graphView.dataPointSpacing = 70
        graphView.topMargin = 50
        graphView.bottomMargin = 50
        graphView.backgroundFillColor = .clear

        graphView.translatesAutoresizingMaskIntoConstraints = false

        return graphView
    }()

    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()
}

extension ChartViewController: ScrollableGraphViewDataSource {
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        let numberOfMonthPassed = 11 - pointIndex
        return viewModel.totalExpense(numberOfMonthPassed: numberOfMonthPassed)
    }

    func label(atIndex pointIndex: Int) -> String {
        let targetDate = Date().numberOfMonthAgo(numberOfMonth: 11 - pointIndex)
        print("\(pointIndex), \(targetDate.month)")
        return "\(targetDate.month)"
    }

    func numberOfPoints() -> Int {
        return 12
    }

}
extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expenses?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expenseChartCell", for: indexPath) as? ChartTableViewCell, let cellViewModel = viewModel.viewModelForCell(at: indexPath)  else { return UITableViewCell()}
        cell.setupWith(viewModel: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
