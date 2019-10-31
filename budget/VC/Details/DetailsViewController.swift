//
//  DetailsViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData


class DetailsViewController: BasicViewController {
   
    var currentMonth: Int {
        let date = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: date)
        return currentMonth
    }
    
    var currentYear: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    var monthYear = ""
    var income: Income?

    weak var tableView: UITableView!
    weak var incomeNotBudgetLabel: UILabel!
    weak var addCategoryButton: UIButton!
    
    var amountTypedString = ""
    var incomeNotBuget: Double?
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
       let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
       fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
       
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
        titleOfVC = "DETAILS"
        configureButton()
        configureLabel()
        configureTableView()
        super.viewDidLoad()
        monthYear = "\(currentYear)\(currentMonth)"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadIncome()
        calcRemainingBudget()
        updateViews()
        tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUIColor()
    }
    private func setupUIColor() {
        if traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = .white
            incomeNotBudgetLabel.textColor = .black
            screenTitleLabel.textColor = .black
            addCategoryButton.setTitleColor(.black, for: .normal)
        } else {
            self.view.backgroundColor = .black
            incomeNotBudgetLabel.textColor = .white
            screenTitleLabel.textColor = .white
            addCategoryButton.setTitleColor(.white, for: .normal)
        }
    }
    
    private func configureButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont(name: fontName, size: 40)
        button.setTitleColor(superLightGray, for: .highlighted)
        button.addTarget(self, action: #selector(showVC), for: .touchUpInside)
        self.addCategoryButton = button
    }
    private func configureTableView() {
        let detailsTableView = UITableView()
        detailsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(detailsTableView)
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.backgroundColor = .clear
        detailsTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "DetailsCell")
        detailsTableView.separatorStyle = .none
        detailsTableView.allowsSelection = true
        
        self.tableView = detailsTableView
    }
    private func configureLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: fontName, size: 20)
        view.addSubview(label)
        self.incomeNotBudgetLabel = label
    }
    override func setupUI() {
        super.setupUI()
        
        NSLayoutConstraint.activate([incomeNotBudgetLabel.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor, constant: 10 * heightRatio),
                                     incomeNotBudgetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     incomeNotBudgetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                     ])
        
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: incomeNotBudgetLabel.bottomAnchor, constant: 20),
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)])
        
        addCategoryButton.widthAnchor.constraint(equalToConstant: buttonWidth * heightRatio).isActive = true
        addCategoryButton.heightAnchor.constraint(equalTo: addCategoryButton.widthAnchor).isActive = true
        addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addCategoryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
    }
    func updateViews() {
       
        
        if let incomeNotBudget = incomeNotBuget {
            incomeNotBudgetLabel.text = "Income not budgeted: \(String(format: "%.2f", incomeNotBudget))"
            print("income not budget: \(incomeNotBudget)")
        } else {
            incomeNotBudgetLabel.text = "No income information."
        }
    }
    
    func loadIncome() {
        
        let context = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        let predicate = NSPredicate(format: "monthYear == %@", monthYear)
        request.predicate = predicate
        
        do {
            income = try context.fetch(request).first
        } catch {
            print("error loading income")
        }
        
    }
    
    func calcRemainingBudget() {
        var totalBudget = 0.0
        for category in fetchedResultsController.fetchedObjects ?? [] {
            totalBudget += category.totalAmount
        }
        print("budget: \(totalBudget)")
        if let income = income {
            incomeNotBuget = income.amount - totalBudget
        } else {
            incomeNotBuget = nil
        }
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = CoreDataStack.shared.mainContext
        
        context.delete(fetchedResultsController.object(at: indexPath))
        
        //TODO: run delete in controller
        
        tableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       return .delete
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 * heightRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as? DetailsTableViewCell else {
            fatalError("cant make DetailTableViewCell")
        }
        let category = fetchedResultsController.object(at: indexPath)
        cell.fontSize = 25 * heightRatio
        cell.category = category
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = fetchedResultsController.fetchedObjects?[indexPath.row]
        let chartVC = ChartViewController()
        chartVC.category = category
        self.navigationController?.pushViewController(chartVC, animated: true)
    }
}

extension DetailsViewController {
    //add category
    
   @objc func showVC() {
        showAddCategory()
        
    }
    func showAddCategory() {
        let alertController = UIAlertController(title: "Add a Category", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "category name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "budget"
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.tag = 1
            
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let categoryName = alertController.textFields?[0].text,
                !categoryName.isEmpty,
                !(self.fetchedResultsController.fetchedObjects ?? []).contains(where: { $0.name == categoryName }) ,
                let amountString = alertController.textFields?[1].text,
                let amount = Double(amountString) else { return }
            
            
            self.createCategory(name: categoryName, amount: amount)
            alertController.textFields?[1].text = ""
            self.amountTypedString = ""
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
    func createCategory(name: String, amount: Double) {
        budgetController.createCategory(name: name, totalAmount: amount)
        calcRemainingBudget()
        updateViews()
        tableView.reloadData()
    }
    
    
}

extension DetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 1 {
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            
            if !string.isEmpty {
                amountTypedString += string
                let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
                //let numbString = NSString(format:"%.2f", decNumber) as String
                let newString = formatter.string(from: decNumber)!
                //let newString = "$" + numbString
                textField.text = newString
            } else {
                amountTypedString = String(amountTypedString.dropLast())
                if !amountTypedString.isEmpty {
                    
                    let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
                    
                    let newString = formatter.string(from: decNumber)!
                    textField.text = newString
                } else {
                    textField.text = "0.00"
                }
                
            }
        }

        return false
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        amountTypedString = ""
        return true
    }
    
}

extension DetailsViewController: NSFetchedResultsControllerDelegate {
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
