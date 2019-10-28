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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let expensesSet: Set<Expense> = category?.expenses as? Set<Expense> else { return }
        
        expenses = Array(expensesSet)
        

        // Do any additional setup after loading the view.
    }
    
    private func setupGraph() {
        let graphView = ScrollableGraphView(frame: self.view.frame, dataSource: self)
        let linePlot = LinePlot(identifier: "Line")
        let referenceLines = ReferenceLines()
        graphView.addPlot(plot: linePlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
    }
    

}

extension ChartViewController: ScrollableGraphViewDataSource {
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "Line":
            return expenses[pointIndex].amount
        default:
            return 0
        }
    }

    func label(atIndex pointIndex: Int) -> String {
        return "FEB \(pointIndex)"
    }

    func numberOfPoints() -> Int {
        return expenses.count
    }
}
