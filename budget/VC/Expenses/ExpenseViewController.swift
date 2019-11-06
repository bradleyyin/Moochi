//
//  ExpenseViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

//TODO: use FRC

class ExpenseViewController: BasicViewController, CalendarDelegate {
    let calendarView: CalendarView = {
        let v = CalendarView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var tableView: UITableView!
    var addEntryButton: UIButton!
    var todayButton: UIButton!
    //var expenses: [Expense] = []
    var date: Date?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Expense>? = {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        guard let date = date as NSDate? else { fatalError("cannot convert date for fetching") }
        let predicate = NSPredicate(format: "date == %@", date)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        

        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
     do {
         try frc.performFetch()
     } catch {
         fatalError("cant fetch expense")
     }
        return frc
    }()
    
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
        tableView.backgroundColor = .clear
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        self.view.addSubview(tableView)
        self.tableView = tableView
    }
    private func configureButtons() {
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setTitle("Today", for: .normal)
        button1.titleLabel?.adjustsFontSizeToFitWidth = true
        button1.titleLabel?.minimumScaleFactor = 0.3
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
        todayButton.widthAnchor.constraint(equalToConstant: 60 * heightRatio).isActive = true
        todayButton.heightAnchor.constraint(equalToConstant: 40 * heightRatio).isActive = true
        
        calendarView.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor, constant: 10 * heightRatio).isActive = true
        calendarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        calendarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    private func updateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        if date != nil {
           tableView.reloadData()
        }
        
    }
    @objc func goToToday() {
        let date = Date()
        let day = Calendar.current.component(.day, from: date)
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        let todayString = String(format: "%02d/%02d/%d", month, day, year)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        print(todayString)
        if let today = formatter.date(from: todayString) {
            calendarView.goToToday()
            goToSingleDay(date: today)
        }
    }
    func goToSingleDay(date: Date) {
        self.date = date
        refreshFRC()
        tableView.reloadData()
    }
    private func refreshFRC() {
        fetchedResultsController = nil
        fetchedResultsController = {
            let request: NSFetchRequest<Expense> = Expense.fetchRequest()
            
            guard let date = date as NSDate? else { fatalError("cannot convert date for fetching") }
            let predicate = NSPredicate(format: "date == %@", date)
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            

            request.predicate = predicate
            request.sortDescriptors = [sortDescriptor]
            
            let moc = CoreDataStack.shared.mainContext
            let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
            
            frc.delegate = self
            
         do {
             try frc.performFetch()
         } catch {
             fatalError("cant fetch expense")
         }
            return frc
        }()
        
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
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as? ExpenseTableViewCell else {
            fatalError("cant make ExpenseTableViewCell")
        }
        cell.expense = fetchedResultsController?.object(at: indexPath)
        
        return cell
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
            let singleDayDetailVC = SingleExpenseDetailViewController()
            singleDayDetailVC.expense = fetchedResultsController?.object(at: indexPath)
            singleDayDetailVC.budgetController = budgetController
            tableView.deselectRow(at: indexPath, animated: false)
            navigationController?.pushViewController(singleDayDetailVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { _, _, _ in
            guard let expense = self.fetchedResultsController?.object(at: indexPath) else { return }
            self.budgetController.deleteExpense(expense: expense)
            NotificationCenter.default.post(name: Notification.Name("changedEntry"), object: nil)
        }
        let edit = UIContextualAction(style: .normal, title: "edit") { _, _, _ in
            guard let expense = self.fetchedResultsController?.object(at: indexPath) else { return }
            let addEntryVC = AddEntryViewController()
            addEntryVC.date = self.date
            addEntryVC.expense = expense
            addEntryVC.budgetController = self.budgetController
            addEntryVC.modalPresentationStyle = .fullScreen
            self.present(addEntryVC, animated: true)
//            NotificationCenter.default.post(name: Notification.Name("changedEntry"), object: nil)
        }
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])

        return swipeActions
    }
    
}
extension ExpenseViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError("new cases for fetch result controller type")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let sectionsIndexSet = IndexSet(integer: sectionIndex)
        
        
        switch type {
        case .insert:
            tableView.insertSections(sectionsIndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(sectionsIndexSet, with: .automatic)
        default:
            break
        }
    }
}
