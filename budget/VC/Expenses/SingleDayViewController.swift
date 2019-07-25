//
//  SingleDayViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

class SingleDayViewController: BasicViewController {
    
    var date : Date?
    
    var dateString : String = ""
    
    var expenses : [Expense] = []
    
    weak var titleLabel: TitleLabel!
    
    weak var table: UITableView!

    


    override func viewDidLoad() {
        titleOfVC = "here"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        if let date = date{
            dateString = dateFormatter.string(from: date)
        }
        
        super.viewDidLoad()
        
        loadItem()

        // Do any additional setup after loading the view.
    }
    override func setupUI() {
        super.setupUI()
        
        let label = TitleLabel(frame: .zero)
        self.view.addSubview(label)


        //label.heightAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        //label.widthAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusBarHeight + 70 * heightRatio).isActive = true
        //label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)


        self.titleLabel = label
        
        self.titleLabel.text = dateString
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .red
        titleLabel.font = UIFont(name: fontName, size: 80 * heightRatio)
        
        if let title = self.view.subviews[0] as? TitleLabel{
            title.removeFromSuperview()
        }
        
        let expensesTableView = UITableView()
        expensesTableView.translatesAutoresizingMaskIntoConstraints = false
        expensesTableView.dataSource = self
        expensesTableView.delegate = self
        expensesTableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        expensesTableView.backgroundColor = .red
        expensesTableView.separatorStyle = .none
        
        self.view.addSubview(expensesTableView)
        expensesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        expensesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        expensesTableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        expensesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        self.table = expensesTableView
        
        
    }
    func loadItem(){
        guard let date = date, let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else{return}
        let request : NSFetchRequest<Expense> = Expense.fetchRequest()
        
        
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        

        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        do{
            expenses = try context.fetch(request)
        }catch{
            print("error loading entries: \(error)")
        }
        
        print(expenses[0].name)
    }
    
    

}

extension SingleDayViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as? ExpenseTableViewCell else {return UITableViewCell()}
        cell.expense = expenses[indexPath.row]
        
        return cell
    }
    
    
}