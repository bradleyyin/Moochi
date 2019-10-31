//
//  ExpenseViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

class ExpenseViewController: BasicViewController, CalendarDelegate {
    let calendarView: CalendarView = {
        let v = CalendarView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var singleDayTableView: UITableView!
    var addEntryButton: UIButton!
    var todayButton: UIButton!
    var expenses: [Expense] = []
    var date: Date?
    
    override func viewDidLoad() {
        titleOfVC = "expenses"
        super.viewDidLoad()
        configureTableView()
        configureCalendarView()
        configureButtons()
        setupConstraints()
        goToToday()
    }
    private func configureCalendarView() {
        view.addSubview(calendarView)
        
        calendarView.backgroundColor = .clear
        calendarView.delegate = self
    }
    private func configureTableView() {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .red
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        self.view.addSubview(tableView)
        self.singleDayTableView = tableView
    }
    private func configureButtons() {
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setTitle("Today", for: .normal)
        button1.setTitleColor(superLightGray, for: .highlighted)
        button1.addTarget(self, action: #selector(goToToday), for: .touchUpInside)
        self.view.addSubview(button1)
        todayButton = button1
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setTitle("+", for: .normal)
        button2.setTitleColor(superLightGray, for: .highlighted)
        button2.titleLabel?.font = UIFont(name: fontName, size: 40)
        button2.addTarget(self, action: #selector(showVC), for: .touchUpInside)
        self.view.addSubview(button2)
        addEntryButton = button2
    }
    private func setupUIColor() {
        if traitCollection.userInterfaceStyle == .light {
            screenTitleLabel.textColor = .black
            self.view.backgroundColor = .white
            addEntryButton.setTitleColor(.black, for: .normal)
            todayButton.setTitleColor(.black, for: .normal)
        } else {
            screenTitleLabel.textColor = .white
            self.view.backgroundColor = .black
            addEntryButton.setTitleColor(.white, for: .normal)
            todayButton.setTitleColor(.white, for: .normal)
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUIColor()
    }
    private func setupConstraints() {
        addEntryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        addEntryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        addEntryButton.widthAnchor.constraint(equalToConstant: buttonWidth * heightRatio).isActive = true
        addEntryButton.heightAnchor.constraint(equalToConstant: buttonHeight * heightRatio).isActive = true
        
        
        todayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        todayButton.topAnchor.constraint(equalTo: screenTitleLabel.topAnchor).isActive = true
        todayButton.widthAnchor.constraint(equalToConstant: buttonWidth * heightRatio).isActive = true
        todayButton.heightAnchor.constraint(equalToConstant: buttonHeight * heightRatio).isActive = true
        
        calendarView.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor, constant: 10 * heightRatio).isActive = true
        calendarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        calendarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        calendarView.heightAnchor.constraint(equalToConstant: (view.frame.height - 160 * heightRatio) / 2 ).isActive = true
        singleDayTableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor).isActive = true
        singleDayTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        singleDayTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        singleDayTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    private func updateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        if date != nil {
           singleDayTableView.reloadData()
        }
        
    }
    @objc func goToToday() {
        goToSingleDay(date: Date())
        calendarView.goToToday()
        
    }
    func goToSingleDay(date: Date) {
        //let singleDayVC = SingleDayViewController()
        //singleDayVC.date = date
        //singleDayVC.budgetController = budgetController
        //self.navigationController?.pushViewController(singleDayVC, animated: true)
        self.date = date
        self.loadItem(for: date)
        self.singleDayTableView.reloadData()
    }
    func loadItem(for date: Date?) {
        let context = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        guard let date = date as NSDate? else { fatalError("cannot convert date for fetching") }
        let predicate = NSPredicate(format: "date == %@", date)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        

        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        do {
            expenses = try context.fetch(request)
            print(expenses.count)
            updateViews()
        } catch {
            fatalError("error loading entries: \(error)")
        }
    }
    @objc func showVC() {
        let addEntryVC = AddEntryViewController()
        addEntryVC.date = date
        addEntryVC.budgetController = budgetController
        addEntryVC.modalPresentationStyle = .fullScreen
        present(addEntryVC, animated: true)
    }
}

extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as? ExpenseTableViewCell else {
            fatalError("cant make ExpenseTableViewCell")
        }
        cell.expense = expenses[indexPath.row]
        
        return cell
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let singleDayDetailVC = SingleExpenseDetailViewController()
            singleDayDetailVC.expense = expenses[indexPath.row]
            singleDayDetailVC.budgetController = budgetController
            navigationController?.pushViewController(singleDayDetailVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let expense = expenses[indexPath.row]
            budgetController.deleteExpense(expense: expense)
            expenses.remove(at: indexPath.row)
            tableView.reloadData()
            NotificationCenter.default.post(name: Notification.Name("changedEntry"), object: nil)
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .delete
        }
        return .none
    }
}
