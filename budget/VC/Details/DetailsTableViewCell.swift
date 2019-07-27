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
            //updateViews()
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
        print ("start, end", startOfMonth, endOfMonth)
        let calender = Calendar.current
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
        print(expenses)
        var totalExpenses = 0.0
        for expense in expenses{
            totalExpenses += expense.amount
        }
        
        return categoryTotal - totalExpenses
    }
    var fontSize : CGFloat = 30
    
    weak var titleLabel : UILabel!
    weak var totalLabel : UILabel!
    weak var whiteBarView : UIView!
    weak var blackBarView : UIView!
    weak var remainLabel : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpViews()
        updateViews()
    }
    func setUpViews(){
        
//        let label1 = UILabel()
//        label1.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(label1)
//        label1.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        label1.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.backgroundColor = .red
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: self.frame.width / 2, height: self.frame.height / 2 - 10))
        self.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let totalLabel = UILabel(frame: CGRect(x: self.frame.width / 2, y: 10, width: self.frame.width / 2, height: self.frame.height / 2 - 10))
        self.addSubview(totalLabel)
        self.totalLabel = totalLabel
        
        let whiteBarView = UIView(frame: CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height / 2))
        
        
        let blackBarView = UIView(frame: CGRect(x: self.frame.width , y: 0, width: self.frame.width, height: self.frame.height / 2))
        
        
         let remainLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 100, height: blackBarView.frame.height))
        blackBarView.addSubview(remainLabel)
        self.remainLabel = remainLabel
        
        whiteBarView.addSubview(blackBarView)
        self.blackBarView = blackBarView
        
        self.addSubview(whiteBarView)
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
        totalLabel.textColor = .darkGray
        totalLabel.text = NSString(format:"%.2f", categoryTotal) as String
        totalLabel.font = UIFont(name: fontName, size: fontSize)
        
        
        whiteBarView.backgroundColor = .white
        
        print(categoryRemaining)
        
        var blackRatio = CGFloat((categoryTotal - categoryRemaining) / categoryTotal)
        if blackRatio >= 1 {
            blackRatio = 1
        }
        blackBarView.frame.size.width = self.frame.width * blackRatio
        print("width", blackBarView.frame.width, titleLabel.text)
        blackBarView.frame.origin.x = self.frame.width * (1.0 - blackRatio)
        blackBarView.backgroundColor = .darkGray
        
       
        remainLabel.text = blackBarView.frame.width >= 100.0 ? NSString(format:"%.2f", categoryRemaining) as String : ""
        print(remainLabel.text)
        remainLabel.textColor = .white
        remainLabel.font = UIFont(name: fontName, size: fontSize)
        remainLabel.textAlignment = .left
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
