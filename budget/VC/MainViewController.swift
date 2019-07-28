//
//  ViewController.swift
//  budget
//
//  Created by Bradley Yin on 6/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    var income : Income?
    var expenses : [Expense] = []
    var remainFund : Double?{
        guard let income = income else {return nil}
        var remain = income.amount
        for expense in expenses{
            remain -= expense.amount
        }
        return remain
    }
    
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
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
    var amountTypedString = ""
    
    weak var monthLabel : UILabel!
    weak var monthNumberLabel : UILabel!
    weak var moneyLabel : UILabel!
    weak var moneyCircle : UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        monthYear = "\(currentYear)\(currentMonth)"
        loadIncome()
        setUpUI()
        //check for file
        //TODO: remove this later
        let fm = FileManager.default
        let filePath = fm.urls(for: .documentDirectory, in: .userDomainMask)
        print(filePath)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print(income, remainFund)
        loadExpenses()
        updateView()
    }
    func setUpUI(){
        
        self.view.backgroundColor = .darkGray
        
        let monthLabel = UILabel()
        self.view.addSubview(monthLabel)
        monthLabel.mainScreenLabel(fontSize: 100)
        monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.monthLabel = monthLabel
        
        let monthNumberLabel = UILabel()
        self.view.addSubview(monthNumberLabel)
        monthNumberLabel.mainScreenLabel(fontSize: 50)
        monthNumberLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20).isActive = true
        monthNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.monthNumberLabel = monthNumberLabel
        
        
        let dotLabel1 = UILabel()
        dotLabel1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dotLabel1)
        dotLabel1.topAnchor.constraint(equalTo: monthNumberLabel.bottomAnchor, constant: 10).isActive = true
        dotLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
        dotLabel1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        dotLabel1.textColor = .lightGray
        dotLabel1.font = monthNumberLabel.font.withSize(50)
        dotLabel1.text = "•  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •"
        dotLabel1.lineBreakMode = .byClipping
        
        let moneyCircle = UIView()
        moneyCircle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(moneyCircle)
        moneyCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moneyCircle.heightAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        moneyCircle.widthAnchor.constraint(equalTo: moneyCircle.heightAnchor).isActive = true
        moneyCircle.topAnchor.constraint(equalTo: dotLabel1.bottomAnchor, constant: 10).isActive = true
        
        moneyCircle.backgroundColor = .lightGray
        moneyCircle.layer.masksToBounds = true
        moneyCircle.layer.cornerRadius = 150 * heightRatio
        moneyCircle.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(moneyCircleTapped))
        moneyCircle.addGestureRecognizer(tap)
        self.moneyCircle = moneyCircle
        
        let moneyLabel = UILabel()
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        moneyCircle.addSubview(moneyLabel)
        moneyLabel.centerXAnchor.constraint(equalTo: moneyCircle.centerXAnchor).isActive = true
        moneyLabel.centerYAnchor.constraint(equalTo: moneyCircle.centerYAnchor).isActive = true
        moneyLabel.widthAnchor.constraint(equalTo: moneyCircle.widthAnchor, multiplier: 0.8).isActive = true
        
        moneyLabel.backgroundColor = .clear
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = .black
        moneyLabel.font = moneyLabel.font.withSize(80 * heightRatio)
        moneyLabel.adjustsFontSizeToFitWidth = true
        moneyLabel.minimumScaleFactor = 0.3
        
        
        self.moneyLabel = moneyLabel
        
        let dotLabel2 = UILabel()
        dotLabel2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dotLabel2)
        dotLabel2.topAnchor.constraint(equalTo: moneyCircle.bottomAnchor, constant: 10).isActive = true
        dotLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
        dotLabel2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        dotLabel2.textColor = .lightGray
        dotLabel2.font = monthNumberLabel.font.withSize(50)
        dotLabel2.text = "•  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •"
        dotLabel2.lineBreakMode = .byClipping
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30 * heightRatio).isActive = true
        button.topAnchor.constraint(equalTo: dotLabel2.bottomAnchor).isActive = true
        
        button.setTitle("+ add an entry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(addEntry), for: .touchUpInside)
    }
    func updateView(){
        monthLabel.text = monthsArr[currentMonth - 1]
        
        monthNumberLabel.text = String(format: "%02d", currentMonth)
        
        if let remain = remainFund{
            moneyLabel.text = "\(String(format: "%.2f", remain))"
        }else{
            moneyLabel.text = "Tap to add income"
        }
        
    }

    
    @objc func addEntry () {
        print("add")
        self.present(AddEntryViewController(), animated: true)
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
    func loadExpenses(){
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}
        let currentDate = Date()
        let startOfMonth = currentDate.getThisMonthStart()
        let endOfMonth = currentDate.getThisMonthEnd()
        //let calender = Calendar.current
        
        let request : NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "(date => %@) AND (date <= %@)", startOfMonth as NSDate, endOfMonth as NSDate)
        
        do{
            expenses = try context.fetch(request)
        }catch{
            print("error loading income")
        }
    }
    
    @objc func moneyCircleTapped(){
        let alertController = UIAlertController(title: "Enter Income", message: "enter your income to track your budget", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "income"
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.tag = 1
            
        }
        let addAction = UIAlertAction(title: "Enter", style: .default) { (action) in
            guard let amountString = alertController.textFields?[0].text, let amount = Double(amountString) else { return }
            self.enterIncome(amount: amount)
            self.updateView()
            
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    
    }
    func enterIncome(amount: Double){
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        if let income = income{
            income.amount = amount
        }else{
            let newIncome = Income(context: context)
            newIncome.amount = amount
            newIncome.monthYear = monthYear
        }
        
        
        
        do{
            try context.save()
        }catch{
            print("error adding income")
        }
    
    }

}
extension MainViewController: UITextFieldDelegate{
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



extension UILabel{
    func mainScreenLabel(fontSize: CGFloat){
        self.textColor = .white
        self.backgroundColor = .clear
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .center
        self.minimumScaleFactor = 0.3
        self.font = self.font.withSize(fontSize * heightRatio)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
