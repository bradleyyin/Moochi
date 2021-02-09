//
//  ChartCellViewModel.swift
//  budget
//
//  Created by Bradley Yin on 10/18/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation

struct ChartCellViewModel {
    let title: String
    let date: Date
    let amount: Double

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }

    var amountString: String {
        return String(format: "%.2f", amount)
    }
}
