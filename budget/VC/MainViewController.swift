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
    var income: Income?
    var remainFund: Double?
    
    let monthCalculator = MonthCalculator()
    var budgetController: BudgetController!
    var budgetCalculator:  BudgetCalculator!
    
    var amountTypedString = ""
    
    weak var monthLabel: UILabel!
    weak var dotLabel1: UILabel!
    weak var dotLabel2: UILabel!
    weak var dateNumberLabel: UILabel!
    weak var moneyLabel: UILabel!
    weak var moneyCircle: UIView!
    weak var addEntryButton: UIButton!
    weak var backgroundView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        income = budgetController.readIncome(monthYear: monthCalculator.monthYear)
        configureLabels()
        configureMoneyCircle()
        configureButton()
        setupConstraints()
        
        //check for file
        //TODO: remove this later
        let fm = FileManager.default
        let filePath = fm.urls(for: .documentDirectory, in: .userDomainMask)
        print(filePath)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRemainingFunds()
        updateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUIColor()
    }
    
    private func setupUIColor() {
        if traitCollection.userInterfaceStyle == .light {
            monthLabel.textColor = .black
            dateNumberLabel.textColor = .black
            dotLabel1.textColor = .black
            dotLabel2.textColor = .black
            moneyLabel.textColor = .black
            addEntryButton.setTitleColor(.black, for: .normal)
            view.backgroundColor = .white
        } else {
            monthLabel.textColor = .white
            dateNumberLabel.textColor = .white
            moneyLabel.textColor = .white
            dotLabel1.textColor = .white
            dotLabel2.textColor = .white
            addEntryButton.setTitleColor(.white, for: .normal)
            view.backgroundColor = .black
        }
    }
    private func configureLabels() {
        let monthLabel = UILabel()
        self.view.addSubview(monthLabel)
        monthLabel.mainScreenLabel(fontSize: 100)
        self.monthLabel = monthLabel
        
        let dateNumberLabel = UILabel()
        self.view.addSubview(dateNumberLabel)
        dateNumberLabel.mainScreenLabel(fontSize: 50)
        self.dateNumberLabel = dateNumberLabel
        
        let dotLabel1 = UILabel()
        dotLabel1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dotLabel1)
        dotLabel1.font = dateNumberLabel.font.withSize(50)
        dotLabel1.text = "•  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •"
        dotLabel1.lineBreakMode = .byClipping
        self.dotLabel1 = dotLabel1
        
        let dotLabel2 = UILabel()
        dotLabel2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dotLabel2)
        dotLabel2.font = dateNumberLabel.font.withSize(50)
        dotLabel2.text = "•  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •  •"
        dotLabel2.lineBreakMode = .byClipping
        self.dotLabel2 = dotLabel2
    }
    private func configureMoneyCircle() {
        let moneyCircle = UIView()
        moneyCircle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(moneyCircle)
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
        moneyLabel.baselineAdjustment = .alignCenters
        self.moneyLabel = moneyLabel
    }
    
    private func configureButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.setTitle("+ add an entry", for: .normal)
        button.titleLabel?.font = UIFont(name: fontName, size: 30)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(superLightGray, for: .highlighted)
        button.addTarget(self, action: #selector(addEntry), for: .touchUpInside)
        self.addEntryButton = button
    }
    func setupConstraints() {
        monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        dateNumberLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20).isActive = true
        dateNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dotLabel1.topAnchor.constraint(equalTo: dateNumberLabel.bottomAnchor, constant: 10).isActive = true
        dotLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        dotLabel1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        moneyCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moneyCircle.heightAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        moneyCircle.widthAnchor.constraint(equalTo: moneyCircle.heightAnchor).isActive = true
        moneyCircle.topAnchor.constraint(equalTo: dotLabel1.bottomAnchor, constant: 10).isActive = true
        
        dotLabel2.topAnchor.constraint(equalTo: moneyCircle.bottomAnchor, constant: 10).isActive = true
        dotLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        dotLabel2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        addEntryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addEntryButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        addEntryButton.heightAnchor.constraint(equalToConstant: 30 * heightRatio).isActive = true
        addEntryButton.topAnchor.constraint(equalTo: dotLabel2.bottomAnchor).isActive = true
    }
    func updateView() {
        monthLabel.text = monthCalculator.currentMonthString
        
        dateNumberLabel.text = String(format: "%02d", monthCalculator.currentDate)
        
        print(remainFund)
        
        if let remain = remainFund {
            moneyLabel.text = "\(String(format: "%.2f", remain))"
        } else {
            moneyLabel.text = "Tap to add income"
        }
        
    }
    func getRemainingFunds() {
        guard let income = income else { return }
        let expenses = budgetController.readMonthlyExpense()
        remainFund = budgetCalculator.calculateRemainingFunds(income: income, expenses: expenses)
    }

    
    @objc func addEntry () {
        let addEntryVC = AddEntryViewController()
        addEntryVC.modalPresentationStyle = .fullScreen
        addEntryVC.budgetController = budgetController
        self.present(addEntryVC, animated: true)
    }
    
    @objc func moneyCircleTapped() {
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
        if let income = income {
            editIncomeView.lblName.text = "Current Income: \(String(format: "%.2f", income.amount))"
            editIncomeView.hasIncome = true
        } else {
            editIncomeView.lblName.text = "Add your income for this month"
            editIncomeView.hasIncome = false
            
        }
        backGroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchToDismiss)))
        backGroundView.gestureRecognizers?[0].delegate = self
    
    }
}
extension MainViewController: EditIncomeDelegate {
    func enterIncome(amount: Double) {
        if let income = income {
            let newamount = income.amount + amount
            budgetController.updateIncome(income: income, amount: newamount)
        } else {
            let monthYear = monthCalculator.monthYear
            budgetController.createIncome(amount: amount, monthYear: monthYear)
            income = budgetController.readIncome(monthYear: monthYear)
        }
        
        dismissView()
        getRemainingFunds()
        updateView()
    }
    func dismissView() {
        let totalViewsNumber = self.view.subviews.count
        self.view.subviews[totalViewsNumber - 1].removeFromSuperview()
    }
    @objc func touchToDismiss() {
        dismissView()
    }
}
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != backgroundView {
            return false
        }
        return true
    }
}


extension UILabel {
    func mainScreenLabel(fontSize: CGFloat) {
        self.backgroundColor = .clear
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .center
        self.minimumScaleFactor = 0.3
        self.font = self.font.withSize(fontSize * heightRatio)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
