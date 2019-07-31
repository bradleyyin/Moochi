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
   
    

    
    
    weak var tableView : UITableView!
    
    var amountTypedString = ""
    
    
    override func viewDidLoad() {
        titleOfVC = "DETAILS"
        super.viewDidLoad()
        loadCategories()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
        tableView.reloadData()
        
    }
    override func setupUI(){
        super.setupUI()
        
        self.view.backgroundColor = .white
        
        
//        let menuButton = UIButton(frame: CGRect(x: screenWidth - 40 - 5, y: statusBarHeight, width: 40 * heightRatio, height: buttonHeight * heightRatio))
//        
//        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        
        let detailsTableView = UITableView(frame: CGRect(x: 10, y: statusBarHeight + (100 * heightRatio), width: screenWidth - 20, height: screenHeight - statusBarHeight - (100 * heightRatio) - buttonHeight - 20))
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.backgroundColor = .clear
        detailsTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "detailsCell")
        detailsTableView.register(AddEntryTableViewCell.self, forCellReuseIdentifier: "AddEntryCell")
        detailsTableView.separatorStyle = .none
        detailsTableView.allowsSelection = false
        
       
        self.view.addSubview(detailsTableView)
        self.tableView = detailsTableView
        
    }
    

    


}

extension DetailsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return 1
        }else{
           return categories.count
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        if indexPath.section == 0{
            context.delete(categories[indexPath.row])
            categories.remove(at: indexPath.row)
            
            saveExpense()
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .delete
        }
        return .none
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 * heightRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddEntryCell", for: indexPath) as? AddEntryTableViewCell else {return UITableViewCell()}
            cell.delegate = self
            cell.selectionStyle = .none
            cell.cellType = .addCategory
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
        let category = categories[indexPath.row]
        cell.fontSize = 25 * heightRatio
        cell.category = category
        
        
        return cell
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension DetailsViewController : AddTableViewCellDelegate{
    func showVC(vc: UIViewController?) {
        if vc == nil{
            print("here")
            showAddCategory()
        }
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

