//
//  SearchEntriesViewController.swift
//  budget
//
//  Created by Bradley Yin on 11/24/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

class SearchExpensesViewController: UIViewController {
    var budgetController: BudgetController!
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
     lazy var fetchedResultsController: NSFetchedResultsController<Expense>? = {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
     do {
         try frc.performFetch()
     } catch {
         fatalError("cant fetch category")
     }
        return frc
    }()

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
    
    private func refreshFRC(keyword: String) {
        fetchedResultsController = nil
        if keyword == "" {
            fetchedResultsController = {
                let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
                   fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                   
                   let moc = CoreDataStack.shared.mainContext
                   let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
                   
                   frc.delegate = self
                   
                do {
                    try frc.performFetch()
                } catch {
                    fatalError("cant fetch category")
                }
                   return frc
            }()
            return
        }
        fetchedResultsController = {
            let request: NSFetchRequest<Expense> = Expense.fetchRequest()

            let predicate = NSPredicate(format: "name CONTAINS[c] %@", keyword)
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)


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

}

extension SearchExpensesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
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
    
    
}

extension SearchExpensesViewController: NSFetchedResultsControllerDelegate {
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
extension SearchExpensesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        refreshFRC(keyword: searchText)
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        refreshFRC(keyword: "")
        tableView.reloadData()
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        searchBar.endEditing(true)
    }
    
}
