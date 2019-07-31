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

    var category: Category?{
        didSet{
            updateViews()
        }
    }
    var categoryTotal : Double {
        guard let category = category else {return 0.0}
        return category.totalAmount
    }
    var categoryRemaining: Double {
        guard let category = category, let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return 0.0}
        let currentDate = Date()
        let startOfMonth = currentDate.getThisMonthStart()
        let endOfMonth = currentDate.getThisMonthEnd()
        //print ("start, end", startOfMonth, endOfMonth)
        //let calender = Calendar.current
        var expenses : [Expense] = []
        
        func loadItem(){
            let predicate = NSPredicate(format: "category MATCHES %@", category.name!)
            let predicate2 = NSPredicate(format: "(date => %@) AND (date <= %@)", startOfMonth as NSDate, endOfMonth as NSDate)
            
            let request : NSFetchRequest<Expense> = Expense.fetchRequest()
            request.predicate = predicate
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
            do{
                expenses = try context.fetch(request)
            }catch{
                print("error loading expenses: \(error)")
            }
        }
        loadItem()
        //print(expenses)
        var totalExpenses = 0.0
        for expense in expenses{
            totalExpenses += expense.amount
        }
        
        return categoryTotal - totalExpenses
    }
    var fontSize : CGFloat = 0
    
    weak var titleLabel : UILabel!
    weak var totalLabel : UILabel!
    weak var whiteBarView : UIView!
    weak var blackBarView : UIView!
    weak var remainLabel : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //setUpViews()
        //updateViews()
    }
    func setUpViews(){
        
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
        remainLabel.leadingAnchor.constraint(equalTo: blackBarView.leadingAnchor, constant: 5)
        
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
        //label1.translatesAutoresizingMaskIntoConstraints = false
        //self.addSubview(label1)
        //label1.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        //label1.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        
        self.backgroundColor = .clear
//        let titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: self.frame.width / 2, height: self.frame.height / 2 - 10))
//        self.addSubview(titleLabel)
        self.titleLabel = label1
        
//        let totalLabel = UILabel(frame: CGRect(x: self.frame.width / 2, y: 10, width: self.frame.width / 2, height: self.frame.height / 2 - 10))
//        self.addSubview(totalLabel)
        self.totalLabel = label2
        
        //let whiteBarView = UIView(frame: CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height / 2))
        
        
        //let blackBarView = UIView(frame: CGRect(x: self.frame.width , y: 0, width: self.frame.width, height: self.frame.height / 2))
        
        
        
        
        self.remainLabel = remainLabel
        self.blackBarView = blackBarView
        self.whiteBarView = whiteBarView
        
        
    }
    func updateViews() {
        
        guard let category = category else { return }
        print(categoryTotal, categoryRemaining)
        
        titleLabel.text = category.name?.uppercased()
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: fontName, size: fontSize)
        titleLabel.textAlignment = .left
        
        
        totalLabel.textAlignment = .right
        totalLabel.textColor = .black
        totalLabel.text = NSString(format:"%.2f", categoryTotal) as String
        totalLabel.font = UIFont(name: fontName, size: fontSize)
        
        
        whiteBarView.backgroundColor = UIColor.gray
        
        print(categoryRemaining)
        
        var blackRatio = CGFloat((categoryTotal - categoryRemaining) / categoryTotal)
        if blackRatio >= 1 {
            blackRatio = 1
        }
        //print (titleLabel.text, blackRatio)
        guard let blackWidthAnchor = blackBarView.constraints.first(where: {$0.firstAttribute == .width}) else {return}
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
        }else{
            remainLabel.textColor = .black
            remainLabel.trailingAnchor.constraint(equalTo: blackBarView.leadingAnchor, constant: -5).isActive = true
            remainLabel.textAlignment = .right
        }
        
        remainLabel.text = NSString(format:"%.2f", categoryRemaining) as String
        //print(remainLabel.text)
        remainLabel.font = UIFont(name: fontName, size: fontSize)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension Date{
    // This Month Start
    func getThisMonthStart() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func getThisMonthEnd() -> Date {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
}
