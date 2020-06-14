//
//  HomeViewController.swift
//  budget
//
//  Created by Bradley Yin on 6/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import RxSwift

protocol HomeViewControllerDelegate: class {
}

class HomeViewController: UIViewController {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    let dependency: Dependency
    
    weak var delegate: HomeViewControllerDelegate?
    private var viewModel: HomeViewModel
    private var disposeBag = DisposeBag()
    
    var amountTypedString = ""
    
    weak var monthLabel: UILabel!
    weak var dotLabel1: UILabel!
    weak var dotLabel2: UILabel!
    weak var dateNumberLabel: UILabel!
    weak var moneyLabel: UILabel!
    weak var moneyCircle: UIView!
    weak var addEntryButton: UIButton!
    weak var backgroundView: UIView!
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.viewModel = HomeViewModel(dependency: dependency)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
        configureMoneyCircle()
        configureButton()
        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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


    private func setupConstraints() {
    }
    
    private func setupBinding() {
        viewModel.currentDate.asObservable().subscribe(onNext: { [weak self] (currentDate) in
            guard let self = self else { return }
            self.monthLabel.text = currentMonth
        }).disposed(by: disposeBag)
        
        viewModel.currentDateString.asObservable().subscribe(onNext: { [weak self] (currentDate) in
            guard let self = self else { return }
            self.dateNumberLabel.text = currentMonth
        }).disposed(by: disposeBag)
    }
    
    //MARK: Action
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
    
    //MARK: UI
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
extension HomeViewController: EditIncomeDelegate {
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
extension HomeViewController: UIGestureRecognizerDelegate {
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
