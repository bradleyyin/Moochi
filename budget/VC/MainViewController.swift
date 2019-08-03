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
    var remainFund : Double?
    
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
    
    var currentDate : Int{
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
    var monthYear = ""
    var amountTypedString = ""
    
    weak var monthLabel : UILabel!
    weak var dateNumberLabel : UILabel!
    weak var moneyLabel : UILabel!
    weak var moneyCircle : UIView!
    weak var backgroundView : UIView!
    

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
        calcRemainFund()
        updateView()
    }
    func setUpUI(){
        
        self.view.backgroundColor = .white
        
        let monthLabel = UILabel()
        self.view.addSubview(monthLabel)
        monthLabel.mainScreenLabel(fontSize: 100)
        monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.monthLabel = monthLabel
        
        let dateNumberLabel = UILabel()
        self.view.addSubview(dateNumberLabel)
        dateNumberLabel.mainScreenLabel(fontSize: 50)
        dateNumberLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20).isActive = true
        dateNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.dateNumberLabel = dateNumberLabel
        
        
        let dotLabel1 = UILabel()
        dotLabel1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dotLabel1)
        dotLabel1.topAnchor.constraint(equalTo: dateNumberLabel.bottomAnchor, constant: 10).isActive = true
        dotLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
        dotLabel1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        dotLabel1.textColor = .black
        dotLabel1.font = dateNumberLabel.font.withSize(50)
        dotLabel1.text = "•  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •"
        dotLabel1.lineBreakMode = .byClipping
        
        let moneyCircle = UIView()
        moneyCircle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(moneyCircle)
        moneyCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moneyCircle.heightAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        moneyCircle.widthAnchor.constraint(equalTo: moneyCircle.heightAnchor).isActive = true
        moneyCircle.topAnchor.constraint(equalTo: dotLabel1.bottomAnchor, constant: 10).isActive = true
        
        moneyCircle.backgroundColor = superLightGray
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
        dotLabel2.textColor = .black
        dotLabel2.font = dateNumberLabel.font.withSize(50)
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
        button.titleLabel?.font = UIFont(name: fontName, size: 30)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(superLightGray, for: .highlighted)
        button.addTarget(self, action: #selector(addEntry), for: .touchUpInside)
    }
    func updateView(){
        monthLabel.text = monthsArr[currentMonth - 1]
        
        dateNumberLabel.text = String(format: "%02d", currentDate)
        
        print(remainFund)
        
        if let remain = remainFund{
            moneyLabel.text = "\(String(format: "%.2f", remain))"
        }else{
            moneyLabel.text = "Tap to add income"
        }
        
    }
    func calcRemainFund(){
        guard let income = income else {return}
        var remain = income.amount
        for expense in expenses{
            remain -= expense.amount
        }
        remainFund = remain
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
//        let alertController = UIAlertController(title: "Enter Income", message: "enter your income to track your budget", preferredStyle: .alert)
//        alertController.addTextField { (textField) in
//            textField.placeholder = "income"
//            textField.keyboardType = .numberPad
//            textField.delegate = self
//            textField.tag = 1
//
//        }
//        let addAction = UIAlertAction(title: "Enter", style: .default) { (action) in
//            guard let amountString = alertController.textFields?[0].text, let amount = Double(amountString) else { return }
//            self.enterIncome(amount: amount)
//            self.updateView()
//
//        }
//        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
//
//        alertController.addAction(addAction)
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true)
        let backGroundView = UIView()
        self.view.addSubview(backGroundView)
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        backGroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backGroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backGroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        self.backgroundView = backGroundView
        
        let editIncomeView = EditIncomeView()
        backGroundView.addSubview(editIncomeView)
        editIncomeView.delegate = self
        editIncomeView.translatesAutoresizingMaskIntoConstraints = false
        editIncomeView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        editIncomeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        editIncomeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        editIncomeView.heightAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        if let income = income{
            editIncomeView.lblName.text = "Current Income: \(String(format: "%.2f", income.amount))"
            editIncomeView.hasIncome = true
        }else{
            editIncomeView.lblName.text = "Add your income for this month"
            editIncomeView.hasIncome = false
            
        }
        backGroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchToDismiss)))
        backGroundView.gestureRecognizers?[0].delegate = self
    
    }

 

}
//extension MainViewController: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//
//        if textField.tag == 0 {
//
//            let formatter = NumberFormatter()
//            formatter.minimumFractionDigits = 2
//            formatter.maximumFractionDigits = 2
//
//            if string.count > 0 {
//                print ("here")
//                amountTypedString += string
//                let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
//                //let numbString = NSString(format:"%.2f", decNumber) as String
//                let newString = formatter.string(from: decNumber)!
//                //let newString = "$" + numbString
//                textField.text = newString
//            } else {
//                amountTypedString = String(amountTypedString.dropLast())
//                if amountTypedString.count > 0 {
//
//                    let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
//
//                    let newString = formatter.string(from: decNumber)!
//                    textField.text = newString
//                } else {
//                    textField.text = "0.00"
//                }
//
//            }
//        }
//
//
//        return false
//
//    }
//
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        amountTypedString = ""
//        return true
//    }
//
//}
extension MainViewController: EditIncomeDelegate{
    func enterIncome(amount: Double){
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        if let income = income{
            income.amount += amount
        }else{
            let newIncome = Income(context: context)
            newIncome.amount = amount
            newIncome.monthYear = monthYear
            income = newIncome
        }
        
        
        
        do{
            try context.save()
        }catch{
            print("error adding income")
        }
        dismissView()
        calcRemainFund()
        updateView()
    }
    func dismissView(){
        let totalViewsNumber = self.view.subviews.count
        self.view.subviews[totalViewsNumber - 1].removeFromSuperview()
       //self.view.subviews[totalViewsNumber - 1].removeFromSuperview()
    }
    @objc func touchToDismiss(){
        dismissView()
    }
}
extension MainViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != backgroundView {
            return false
        }
        return true
    }
}


extension UILabel{
    func mainScreenLabel(fontSize: CGFloat){
        self.textColor = .black
        self.backgroundColor = .clear
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .center
        self.minimumScaleFactor = 0.3
        self.font = self.font.withSize(fontSize * heightRatio)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
