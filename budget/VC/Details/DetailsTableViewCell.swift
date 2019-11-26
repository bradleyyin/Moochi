//
//  DetailsTableViewCell.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

class DetailsTableViewCell: UITableViewCell {
    
    var category: Category? {
        didSet {
            updateViews()
        }
    }
    var categoryTotal: Double {
        guard let category = category else { return 0.0 }
        return category.totalAmount
    }
    var categoryRemaining: Double {
        let context = CoreDataStack.shared.mainContext
        let currentDate = Date()
        let startOfMonth = currentDate.getThisMonthStart()
        let endOfMonth = currentDate.getThisMonthEnd()
        //print ("start, end", startOfMonth, endOfMonth)
        var expenses: [Expense] = []
        
        func loadItem() {
            print("expenses", category?.expenses as? Set<Expense>)
            let predicate = NSPredicate(format: "parentCategory == %@", (category)!)
            let predicate2 = NSPredicate(format: "(date => %@) AND (date <= %@)", startOfMonth as NSDate, endOfMonth as NSDate)
            
            let request: NSFetchRequest<Expense> = Expense.fetchRequest()
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
            do {
                expenses = try context.fetch(request)
            } catch {
                print("error loading expenses: \(error)")
            }
        }
        loadItem()
        //print(expenses)
        var totalExpenses = 0.0
        for expense in expenses {
            totalExpenses += expense.amount
        }
        
        return categoryTotal - totalExpenses
    }
    var fontSize: CGFloat = 0
    
    weak var titleLabel: UILabel!
    weak var totalLabel: UILabel!
    weak var whiteBarView: UIView!
    weak var blackBarView: UIView!
    weak var remainLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIColor()
    }
    private func setupUIColor() {
        if traitCollection.userInterfaceStyle == .light {
            titleLabel.textColor = .black
            totalLabel.textColor = .black
            remainLabel.textColor = .black
        } else {
            titleLabel.textColor = .white
            totalLabel.textColor = .white
            remainLabel.textColor = .white
        }
    }
    
    func setUpViews() {
        
        let label1 = UILabel()
        label1.textAlignment = .left
        let label2 = UILabel()
        label2.textAlignment = .right
        
        let topStackView = UIStackView(arrangedSubviews: [label1, label2])
        topStackView.axis = .horizontal
        topStackView.distribution = .fillEqually
        topStackView.alignment = .fill
        
        let whiteBarView = UIView()
        let blackBarView = UIView()
        blackBarView.translatesAutoresizingMaskIntoConstraints = false
        whiteBarView.addSubview(blackBarView)
        blackBarView.topAnchor.constraint(equalTo: whiteBarView.topAnchor).isActive = true
        blackBarView.bottomAnchor.constraint(equalTo: whiteBarView.bottomAnchor).isActive = true
        blackBarView.trailingAnchor.constraint(equalTo: whiteBarView.trailingAnchor).isActive = true
        blackBarView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let remainLabel = UILabel()
        blackBarView.addSubview(remainLabel)
        remainLabel.translatesAutoresizingMaskIntoConstraints = false
        remainLabel.topAnchor.constraint(equalTo: blackBarView.topAnchor).isActive = true
        remainLabel.bottomAnchor.constraint(equalTo: blackBarView.bottomAnchor).isActive = true
        remainLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        let totalStackView = UIStackView(arrangedSubviews: [topStackView, whiteBarView])
        totalStackView.axis = .vertical
        totalStackView.alignment = .fill
        totalStackView.distribution = .fillEqually
        
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(totalStackView)
        totalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        totalStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        totalStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        totalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        
        self.backgroundColor = .clear
        
        self.titleLabel = label1
        self.totalLabel = label2
        self.remainLabel = remainLabel
        self.blackBarView = blackBarView
        self.whiteBarView = whiteBarView
        
        
    }
    func updateViews() {
        
        guard let category = category else { return }
        print(categoryTotal, categoryRemaining)
        
        titleLabel.text = category.name?.uppercased()
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.font = UIFont(name: fontName, size: fontSize)
        titleLabel.textAlignment = .left
        
        
        totalLabel.textAlignment = .right
        totalLabel.textColor = .black
        totalLabel.text = NSString(format: "%.2f", categoryTotal) as String
        totalLabel.font = UIFont(name: fontName, size: fontSize)
        
        
        whiteBarView.backgroundColor = UIColor.gray
        
        print(categoryRemaining)
        
        var blackRatio = CGFloat((categoryTotal - categoryRemaining) / categoryTotal)
        if blackRatio >= 1 {
            blackRatio = 1
        }
        //print (titleLabel.text, blackRatio)
        guard let blackWidthAnchor = blackBarView.constraints.first(where: { $0.firstAttribute == .width }) else { return }
        blackWidthAnchor.constant = self.frame.width * blackRatio
        
        blackBarView.layoutIfNeeded()
        //print("width", blackBarView.frame.width, titleLabel.text)
        //blackBarView.frame.origin.x = self.frame.width * (1.0 - blackRatio)
        print("black bar width", blackWidthAnchor.constant)
        blackBarView.backgroundColor = .lightText
        if blackWidthAnchor.constant >= 100 {
            remainLabel.textColor = .black
            remainLabel.leadingAnchor.constraint(equalTo: blackBarView.leadingAnchor, constant: 5).isActive = true
            remainLabel.textAlignment = .left
        } else {
            remainLabel.textColor = .black
            remainLabel.trailingAnchor.constraint(equalTo: blackBarView.leadingAnchor, constant: -5).isActive = true
            remainLabel.textAlignment = .right
        }
        
        remainLabel.text = NSString(format: "%.2f", categoryRemaining) as String
        //print(remainLabel.text)
        remainLabel.font = UIFont(name: fontName, size: fontSize)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
