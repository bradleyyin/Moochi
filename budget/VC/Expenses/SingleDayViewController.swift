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
    
    var date: Date?
    
    var dateString: String = ""
    
    var expenses: [Expense] = []
    
    weak var titleLabel: TitleLabel!
    
    weak var table: UITableView!
    
    var budgetController: BudgetController!

    


    override func viewDidLoad() {
        titleOfVC = "here"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        if let date = date {
            dateString = dateFormatter.string(from: date)
        }
        
        super.viewDidLoad()
        
        //loadItem()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItem()
        table.reloadData()
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
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont(name: fontName, size: 80 * heightRatio)
        
        if let title = self.view.subviews[0] as? TitleLabel {
            title.removeFromSuperview()
        }
        
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth * heightRatio).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight * heightRatio).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + 50 * heightRatio - buttonHeight / 2).isActive = true
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let expensesTableView = UITableView()
        expensesTableView.translatesAutoresizingMaskIntoConstraints = false
        expensesTableView.dataSource = self
        expensesTableView.delegate = self
        expensesTableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        expensesTableView.backgroundColor = .clear
        expensesTableView.separatorStyle = .none
        
        self.view.addSubview(expensesTableView)
        expensesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        expensesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        expensesTableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
//        expensesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        self.table = expensesTableView
        
        let swipeFromLeftGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipeFromLeft))
        swipeFromLeftGesture.edges = .left
        self.view.addGestureRecognizer(swipeFromLeftGesture)
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button2)
        button2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        button2.topAnchor.constraint(equalTo: expensesTableView.bottomAnchor, constant: 40).isActive = true
        button2.setTitle("+ add an entry", for: .normal)
        button2.titleLabel?.font = UIFont(name: fontName, size: 30)
        button2.setTitleColor(.black, for: .normal)
        button2.addTarget(self, action: #selector(showVC), for: .touchUpInside)
        
        
    }
    func loadItem() {
        guard let date = date, let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        

        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        do {
            expenses = try context.fetch(request)
        } catch {
            print("error loading entries: \(error)")
        }
        
        //print(expenses[0].name)
    }
    @objc func swipeFromLeft() {
        backButtonTapped()
    }
    @objc func showVC() {
        let addEntryVC = AddEntryViewController()
        addEntryVC.date = date
        present(addEntryVC, animated: true)
    }
    
    

}

extension SingleDayViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
        return expenses.count
//        }else{
//            return 1
//        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 1{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddEntryCell", for: indexPath) as? AddEntryTableViewCell else {return UITableViewCell()}
//            cell.delegate = self
//            cell.selectionStyle = .none
//            cell.cellType = .addEntry
//            return cell
//        }else{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as? ExpenseTableViewCell else { fatalError("cant make ExpenseTableViewCell") }
        cell.expense = expenses[indexPath.row]
        
        return cell
       // }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let singleDayDetailVC = SingleDayDetailViewController()
            singleDayDetailVC.expense = expenses[indexPath.row]
            navigationController?.pushViewController(singleDayDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        if indexPath.section == 0 {
            //budgetController.deleteExpense
            context.delete(expenses[indexPath.row])
            expenses.remove(at: indexPath.row)
            //TODO: run this in controller
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .delete
        }
        return .none
    }
    
    
}

