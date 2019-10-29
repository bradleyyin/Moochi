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
    var graphView: ScrollableGraphView?
    var expensesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    private func setupUI() {
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .white
        } else {
            view.backgroundColor = .black
        }
        setupGraph()
        setupTableView()
        setupConstraint()
    }
    private func setupTableView() {
//        let tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource
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
        dotPlot.dataPointSize = 8
        if traitCollection.userInterfaceStyle == .light {
            dotPlot.dataPointFillColor = UIColor.black
            linePlot.lineColor = .black
            referenceLines.referenceLineColor = .black
        } else {
            dotPlot.dataPointFillColor = UIColor.white
            linePlot.lineColor = .white
            referenceLines.referenceLineColor = .white
        }
        

        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.direction = .rightToLeft
        graphView.dataPointSpacing = 100
        graphView.topMargin = 50
        graphView.bottomMargin = 50
        graphView.backgroundFillColor = .clear
        
        graphView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(graphView)
        self.graphView = graphView
    }
    private func setupConstraint() {
        guard let graphView = graphView else { return }
        graphView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        graphView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        graphView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        graphView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
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
