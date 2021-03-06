//
//  SingleDayViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//


//currently not in use

import UIKit
import CoreData

class SingleDayViewController: BasicViewController {
    
    var date: Date?
    
    var dateString: String = ""
    
    var expenses: [Expense] = []
    
    weak var titleLabel: TitleLabel!
    weak var table: UITableView!
    weak var backButton: UIButton!
    weak var addEntryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
    }
    
    private func updateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        if let date = date {
            dateString = dateFormatter.string(from: date)
        }
        self.titleLabel.text = dateString
        table.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItem(for: date)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUIColor()
    }
    private func setupUIColor() {
        if traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = .white
            titleLabel.textColor = .black
            addEntryButton.setTitleColor(.black, for: .normal)
            backButton.tintColor = .black
        } else {
            self.view.backgroundColor = .black
            titleLabel.textColor = .white
            addEntryButton.setTitleColor(.white, for: .normal)
            backButton.tintColor = .white
        }
    }
    override func setupUI() {
        super.setupUI()
        
        let label = TitleLabel(frame: .zero)
        self.view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 70 * heightRatio).isActive = true

        self.titleLabel = label
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
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        let originalImage = UIImage(named: "back")
        let tintedImage = originalImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.setTitleColor(superLightGray, for: .highlighted)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.backButton = button
        
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
        expensesTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.table = expensesTableView
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button2)
        button2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        button2.widthAnchor.constraint(equalToConstant: buttonWidth * heightRatio).isActive = true
        button2.heightAnchor.constraint(equalToConstant: buttonHeight * heightRatio).isActive = true
        button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        button2.setTitle("+", for: .normal)
        button2.titleLabel?.font = UIFont(name: fontName, size: 40)
        button2.setTitleColor(superLightGray, for: .highlighted)
        button2.addTarget(self, action: #selector(showVC), for: .touchUpInside)
        self.addEntryButton = button2
        
        
    }
    private func addGestures() {
        let swipeFromLeftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipeFromLeftEdge))
        swipeFromLeftEdgeGesture.edges = .left
        self.view.addGestureRecognizer(swipeFromLeftEdgeGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(loadDayAfter))
        swipeLeftGesture.direction = .left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(loadDayBefore))
        swipeRightGesture.direction = .right
        self.view.addGestureRecognizer(swipeRightGesture)
        //print(self.view.gestureRecognizers)
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
    @objc func swipeFromLeftEdge() {
        backButtonTapped()
    }
    
    @objc func loadDayBefore() {
        self.date = date?.dayBefore
        loadItem(for: self.date)
    }
    
    @objc func loadDayAfter() {
        self.date = date?.dayAfter
        loadItem(for: self.date)
    }
    
    @objc func showVC() {
        let addEntryVC = AddEntryViewController()
        addEntryVC.date = date
        addEntryVC.budgetController = budgetController
        addEntryVC.modalPresentationStyle = .fullScreen
        present(addEntryVC, animated: true)
    }
}

extension SingleDayViewController: UITableViewDelegate, UITableViewDataSource {
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
