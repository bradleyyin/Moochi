//
//  ViewController.swift
//  budget
//
//  Created by Bradley Yin on 10/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import ScrollableGraphView

class ChartViewController: UIViewController {
    var category: Category!
    var expenses: [Expense] = []
    var expensesDictionary: [String: Double] = [:]
    var sortedKey: [String] = []
    var reversedKey: [String] = []
    var graphView: ScrollableGraphView?
    var expensesTableView: UITableView!
    var titleLabel: UILabel!
    var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLabel()
        setupButton()
        setupUI()
        loadExpenses()
        NotificationCenter.default.addObserver(self, selector: #selector(loadExpenses), name: NSNotification.Name("changedEntry"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc private func loadExpenses() {
        guard let expensesSet: Set<Expense> = category?.expenses as? Set<Expense> else { return }
        expenses = Array(expensesSet)
        sortExpenses()
        graphView?.reload()
        expensesTableView.reloadData()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupUI()
    }
    private func sortExpenses() {
        var dictionary: [String: Double] = [:]
        for expense in expenses {
            guard let date = expense.date else { continue }
            let month = Calendar.current.component(.month, from: date)
            let year = Calendar.current.component(.year, from: date)
            let monthYear = "\(year)/\(month)"
            if dictionary[monthYear] == nil {
                dictionary[monthYear] = expense.amount
            } else {
                dictionary[monthYear]! += expense.amount
            }
        }
        expensesDictionary = dictionary
        sortedKey = dictionary.keys.sorted(by: {
            if $0.count < $1.count {
                return true
            } else if $0 < $1 && $0.count == $1.count {
                return true
            } else {
                return false
            }
        })
        reversedKey = sortedKey.reversed()
    }
    private func setupUI() {
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .white
            titleLabel.textColor = .black
            backButton.tintColor = .black
        } else {
            view.backgroundColor = .black
            titleLabel.textColor = .white
            backButton.tintColor = .white
        }
        setupGraph()
        setupConstraint()
    }
    private func setupTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: "expenseChartCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
        self.expensesTableView = tableView
    }
    private func setupLabel() {
        let label = TitleLabel()
        label.text = category.name
        label.textAlignment = .right
        self.view.addSubview(label)
        self.titleLabel = label
    }
    private func setupButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitleColor(superLightGray, for: .highlighted)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(button)
        self.backButton = button
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupGraph() {
        if let graphView = graphView {
            graphView.removeFromSuperview()
            self.graphView = nil
        }
        let graphView = ScrollableGraphView(frame: CGRect(x: 10, y: 10, width: 300, height: 500), dataSource: self)
        //graphView
        let linePlot = LinePlot(identifier: "Line")
        let referenceLines = ReferenceLines()
        referenceLines.shouldShowReferenceLines = false
        
        let dotPlot = DotPlot(identifier: "Dot") // Add dots as well.
        dotPlot.dataPointSize = 5
        if traitCollection.userInterfaceStyle == .light {
            dotPlot.dataPointFillColor = UIColor.black
            linePlot.lineColor = .black
            referenceLines.dataPointLabelColor = .black
        } else {
            dotPlot.dataPointFillColor = UIColor.white
            linePlot.lineColor = .white
            referenceLines.dataPointLabelColor = .white
            
        }
        

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
        
        self.view.addSubview(graphView)
        self.graphView = graphView
    }
    private func setupConstraint() {
        guard let graphView = graphView else { return }
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        graphView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        graphView.bottomAnchor.constraint(equalTo: self.expensesTableView.topAnchor).isActive = true
        graphView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        graphView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        graphView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2).isActive = true
        expensesTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        expensesTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        expensesTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    

}

extension ChartViewController: ScrollableGraphViewDataSource {
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        //if plot.identifier == "Line" {
            let key = sortedKey[pointIndex]
            let amount = expensesDictionary[key]
            return amount ?? 0
        //}
       // return 0
    }

    func label(atIndex pointIndex: Int) -> String {
        return sortedKey[pointIndex]
    }

    func numberOfPoints() -> Int {
        return sortedKey.count
    }
    
}
extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedKey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expenseChartCell",
                                                       for: indexPath) as? ChartTableViewCell else {
            return UITableViewCell()
        }
        
        let key = reversedKey[indexPath.row]
        guard let amount = expensesDictionary[key] else { return cell }
        cell.expenseDataPair = (key, amount)
        return cell
    }
    
    
}
