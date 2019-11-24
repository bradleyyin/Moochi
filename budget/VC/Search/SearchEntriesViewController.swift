//
//  SearchEntriesViewController.swift
//  budget
//
//  Created by Bradley Yin on 11/24/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

class SearchEntriesViewController: UIViewController {
    var budgetController: BudgetController!
    
    var tableView: UITableView!
    
     lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
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

        // Do any additional setup after loading the view.
    }
    
    private func configureTableView() {
        
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

}

extension SearchEntriesViewController: NSFetchedResultsControllerDelegate {
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
