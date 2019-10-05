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
   
    var currentMonth  : Int {
        let date = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: date)
        return currentMonth
    }
    
    var currentYear : Int{
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    var monthYear = ""
    var income : Income?

    
    
    weak var tableView : UITableView!
    weak var incomeNotBudgetLabel : UILabel!
    
    var amountTypedString = ""
    var incomeNotBuget : Double?
    
    
    override func viewDidLoad() {
        titleOfVC = "DETAILS"
        super.viewDidLoad()
        monthYear = "\(currentYear)\(currentMonth)"
        
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
        loadIncome()
        calcRemainingBudget()
        updateViews()
        tableView.reloadData()
        
    }
    override func setupUI(){
        super.setupUI()
        
        self.view.backgroundColor = .white
        
        let unbudgetIncomeLabel = UILabel()
        unbudgetIncomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(unbudgetIncomeLabel)
        unbudgetIncomeLabel.font = UIFont(name: fontName, size: 20)
        NSLayoutConstraint.activate([unbudgetIncomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + 100*heightRatio),
                                     unbudgetIncomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     unbudgetIncomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                     ])
        
        self.incomeNotBudgetLabel = unbudgetIncomeLabel
        
        
        let detailsTableView = UITableView()
        detailsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(detailsTableView)
        NSLayoutConstraint.activate([detailsTableView.topAnchor.constraint(equalTo: unbudgetIncomeLabel.bottomAnchor, constant: 20),
                                     detailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     detailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
            
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.backgroundColor = .clear
        detailsTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "detailsCell")
        detailsTableView.separatorStyle = .none
        detailsTableView.allowsSelection = false
        
       
        
        self.tableView = detailsTableView
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button2)
        button2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        button2.topAnchor.constraint(equalTo: detailsTableView.bottomAnchor , constant: 40).isActive = true
        button2.setTitle("+ add a category", for: .normal)
        button2.titleLabel?.font = UIFont(name: fontName, size: 30)
        button2.setTitleColor(.black, for: .normal)
        button2.addTarget(self, action: #selector(showVC), for: .touchUpInside)
        
        
    }
    func updateViews(){
        if let incomeNotBudget = incomeNotBuget{
            incomeNotBudgetLabel.text = "Income not budgeted: \(String(format: "%.2f", incomeNotBudget))"
        }else{
            incomeNotBudgetLabel.text = "No income information."
        }
    }
    
    func loadIncome(){
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}
        let request : NSFetchRequest<Income> = Income.fetchRequest()
        let predicate = NSPredicate(format: "monthYear == %@", monthYear)
        request.predicate = predicate
        
        do{
            income = try context.fetch(request).first
        }catch{
            print("error loading income")
        }
        
    }
    
    func calcRemainingBudget(){
        var totalBudget = 0.0
        for category in categories{
            totalBudget += category.totalAmount
        }
        if let income = income{
            incomeNotBuget = income.amount - totalBudget
        }else{
            incomeNotBuget = nil
        }
    }
}

extension DetailsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categories.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        
        context.delete(categories[indexPath.row])
        categories.remove(at: indexPath.row)
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
        let category = categories[indexPath.row]
        cell.fontSize = 25 * heightRatio
        cell.category = category
        
        
        return cell
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension DetailsViewController {
    //add category
    
   @objc func showVC() {
    
        print("here")
        showAddCategory()
        
    }
    func showAddCategory(){
        let alertController = UIAlertController(title: "Add a Category", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "category name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "budget"
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.tag = 1
            
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let categoryName = alertController.textFields?[0].text, !categoryName.isEmpty, !self.categories.contains(where: {$0.name == categoryName}), let amountString = alertController.textFields?[1].text, let amount = Double(amountString) else { return }
            
            
            self.createCategory(name: categoryName, amount: amount)
            alertController.textFields?[1].text = ""
            self.amountTypedString = ""
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
    func createCategory(name: String, amount: Double){
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let newCategory = Category(context: context)
        newCategory.name = name.uppercased()
        newCategory.totalAmount = amount
        
        categories.append(newCategory)
        calcRemainingBudget()
        updateViews()
        tableView.reloadData()
        
        do {
            try context.save()
        } catch  {
            print("error creating category: \(error)")
        }
    }
    
    
}

extension DetailsViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 1 {
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            
            if string.count > 0 {
                print ("here")
                amountTypedString += string
                let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
                //let numbString = NSString(format:"%.2f", decNumber) as String
                let newString = formatter.string(from: decNumber)!
                //let newString = "$" + numbString
                textField.text = newString
            } else {
                amountTypedString = String(amountTypedString.dropLast())
                if amountTypedString.count > 0 {
                    
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

