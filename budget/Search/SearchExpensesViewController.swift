//
//  SearchEntriesViewController.swift
//  budget
//
//  Created by Bradley Yin on 11/24/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class SearchExpensesViewController: UIViewController {
    var budgetController: BudgetController!
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
        setConstraint()
        // Do any additional setup after loading the view.
    }
    
    private func configureSearchBar() {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBar)
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.placeholder = "Enter name of expense"
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        self.searchBar = searchBar
    }
    
    private func configureTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        self.tableView = tableView
    }
    
    private func setConstraint() {
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUIColor()
    }
    
    private func setupUIColor() {
        if traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = .white
        } else {
            self.view.backgroundColor = .black
        }
    }
    
//    private func setupBinding() {
//        realm.objects(Expense.self)
//        .sort(byKeyPath: "date", ascending: false)
//        .observe { [weak self] changes in
//            switch changes {
//            case .initial(let messages):
//                // initial collection
//                break
//            case .update(_, let deletions, let insertions, let modifications):
//                break
//            case .error(let error):
//                print(error)
//            }
//        }
//    }
}

extension SearchExpensesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as? ExpenseTableViewCell else {
            fatalError("cant make ExpenseTableViewCell")
        }
        //cell.expense = fetchedResultsController?.object(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        if indexPath.section == 0 {
//            let singleDayDetailVC = SingleExpenseDetailViewController()
//            singleDayDetailVC.expense = fetchedResultsController?.object(at: indexPath)
//            singleDayDetailVC.budgetController = budgetController
//            tableView.deselectRow(at: indexPath, animated: false)
//            navigationController?.pushViewController(singleDayDetailVC, animated: true)
//        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let delete = UIContextualAction(style: .destructive, title: "delete") { _, _, _ in
//                guard let expense = self.fetchedResultsController?.object(at: indexPath) else { return }
//                self.budgetController.deleteExpense(expense: expense)
//                NotificationCenter.default.post(name: Notification.Name("changedEntry"), object: nil)
            }
            let edit = UIContextualAction(style: .normal, title: "edit") { _, _, _ in
//                guard let expense = self.fetchedResultsController?.object(at: indexPath) else { return }
//                let addEntryVC = AddEntryViewController()
//                addEntryVC.expense = expense
//                addEntryVC.date = expense.date
//                addEntryVC.budgetController = self.budgetController
//                addEntryVC.modalPresentationStyle = .fullScreen
//                self.present(addEntryVC, animated: true)
            }
            
            
            let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])

            return swipeActions
        }
    
    
}

extension SearchExpensesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        //refreshFRC(keyword: searchText)
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        //refreshFRC(keyword: "")
        tableView.reloadData()
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        searchBar.endEditing(true)
    }
}
