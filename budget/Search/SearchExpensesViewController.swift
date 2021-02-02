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
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        configureSearchBar()
        setConstraint()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.searchTextField.layer.cornerRadius = 22
        searchContainerView.addInnerShadow()

        //searchBar.searchTextField.clipsToBounds = true
    }
    
    private func configureSearchBar() {

    }
    
    private func configureTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        self.tableView = tableView
    }
    
    private func setConstraint() {
        view.addSubview(searchContainerView)
        view.addSubview(tableView)
        searchContainerView.addSubview(searchBar)

        searchContainerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        searchBar.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(4)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchContainerView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //setupUIColor()
    }
    
//    private func setupUIColor() {
//        if traitCollection.userInterfaceStyle == .light {
//            self.view.backgroundColor = .white
//        } else {
//            self.view.backgroundColor = .black
//        }
//    }
    
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

    private lazy var searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.placeholder = "Enter name of expense"
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.barTintColor = .white
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
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
