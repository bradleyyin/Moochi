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
    let testNumber = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let expensesSet: Set<Expense> = category?.expenses as? Set<Expense> else { return }
        
        expenses = Array(expensesSet)
        setupGraph()

        // Do any additional setup after loading the view.
    }
    
    private func setupGraph() {
        let graphView = ScrollableGraphView(frame: CGRect(x: 10, y: 10, width: 300, height: 500), dataSource: self)
        //graphView
        let linePlot = LinePlot(identifier: "Line")
        let referenceLines = ReferenceLines()
        graphView.addPlot(plot: linePlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.shouldAdaptRange = true
        graphView.direction = .leftToRight
        //graphView.topMargin = 100
        //graphView.bottomMargin = 100
        
        graphView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(graphView)
        graphView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        graphView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        graphView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        graphView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    

}

extension ChartViewController: ScrollableGraphViewDataSource {
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "Line":
            return testNumber[pointIndex]
        default:
            return 0
        }
    }

    func label(atIndex pointIndex: Int) -> String {
        return "FEB \(pointIndex)"
    }

    func numberOfPoints() -> Int {
        return testNumber.count
    }
}
