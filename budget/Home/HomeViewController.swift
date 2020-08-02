//
//  HomeViewController.swift
//  budget
//
//  Created by Bradley Yin on 6/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

protocol HomeViewControllerDelegate: class {
}

class HomeViewController: UIViewController {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    
    let dependency: Dependency
    
    weak var delegate: HomeViewControllerDelegate?
    private var viewModel: HomeViewModel
    private var disposeBag = DisposeBag()
    
    var amountTypedString = ""
    
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
        view.backgroundColor = .white
        view.addSubview(dateLabel)
        view.addSubview(remainingBalanceLabel)
        view.addSubview(remainingBalanceNumberLabel)
        view.addSubview(sliderView)
        view.addSubview(tableView)
        setupConstraints()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //setupUIColor()
    }
    
//    private func setupUIColor() {
//        if traitCollection.userInterfaceStyle == .light {
//            monthLabel.textColor = .black
//            dateNumberLabel.textColor = .black
//            dotLabel1.textColor = .black
//            dotLabel2.textColor = .black
//            moneyLabel.textColor = .black
//            addEntryButton.setTitleColor(.black, for: .normal)
//            view.backgroundColor = .white
//        } else {
//            monthLabel.textColor = .white
//            dateNumberLabel.textColor = .white
//            moneyLabel.textColor = .white
//            dotLabel1.textColor = .white
//            dotLabel2.textColor = .white
//            addEntryButton.setTitleColor(.white, for: .normal)
//            view.backgroundColor = .black
//        }
//    }


    private func setupConstraints() {
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(top).inset(SharedUI.verticalPadding * 3)
            make.centerX.equalToSuperview()
        }
        
        remainingBalanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(SharedUI.verticalPadding * 5)
            make.centerX.equalToSuperview()
        }
        
        remainingBalanceNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(remainingBalanceLabel.snp.bottom).offset(SharedUI.verticalPadding * 2)
            make.leading.trailing.equalToSuperview().inset(SharedUI.horizontalPadding * 12)
        }
        
        sliderView.snp.makeConstraints { (make) in
            make.top.equalTo(remainingBalanceLabel.snp.bottom).offset(SharedUI.verticalPadding * 8)
            make.leading.trailing.equalToSuperview().inset(SharedUI.horizontalPadding * 14)
            make.height.equalTo(29)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        sliderView.setSelectedIndex(0)
    }
    
    private func setupBinding() {
        viewModel.currentDate.asObservable().subscribe(onNext: { [weak self] currentDate in
            guard let self = self else { return }
            self.dateLabel.text = currentDate
        }).disposed(by: disposeBag)
        
        viewModel.remainFund.asObservable().subscribe(onNext: { [weak self] remainFund in
            guard let self = self else { return }
            if let remainFund = remainFund {
                self.remainingBalanceLabel.text = "Remaining Balance"
                self.remainingBalanceNumberLabel.text = "$\(remainFund)"
            } else {
                self.remainingBalanceLabel.text = "Tap to add income"
                self.remainingBalanceNumberLabel.text = "$0.00"
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK: Action
//    @objc func addEntry () {
//        let addEntryVC = AddEntryViewController()
//        addEntryVC.modalPresentationStyle = .fullScreen
//        addEntryVC.budgetController = budgetController
//        self.present(addEntryVC, animated: true)
//    }
    
//    @objc func moneyCircleTapped() {
//        let backGroundView = UIView()
//        self.view.addSubview(backGroundView)
//        backGroundView.translatesAutoresizingMaskIntoConstraints = false
//        backGroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        backGroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        backGroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
//        self.backgroundView = backGroundView
//
//        let editIncomeView = EditIncomeView()
//        backGroundView.addSubview(editIncomeView)
//        editIncomeView.delegate = self
//        editIncomeView.translatesAutoresizingMaskIntoConstraints = false
//        editIncomeView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        editIncomeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
//        editIncomeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
//        editIncomeView.heightAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
//        if let income = income {
//            editIncomeView.lblName.text = "Current Income: \(String(format: "%.2f", income.amount))"
//            editIncomeView.hasIncome = true
//        } else {
//            editIncomeView.lblName.text = "Add your income for this month"
//            editIncomeView.hasIncome = false
//
//        }
//        backGroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchToDismiss)))
//        backGroundView.gestureRecognizers?[0].delegate = self
//    }
    
    //MARK: UI
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 30, fontType: .regular)
        return label
    }()
    
    private lazy var remainingBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 14, fontType: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        label.text = "Remaining Balance"
        return label
    }()
    
    private lazy var remainingBalanceNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontPalette.font(size: 40, fontType: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sliderView: SliderView = {
        let view = SliderView()
        view.titles = [NSAttributedString(string: "Category"), NSAttributedString(string: "Goal")]
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
}
//extension HomeViewController: EditIncomeDelegate {
//    func enterIncome(amount: Double) {
//        if let income = income {
//            let newamount = income.amount + amount
//            budgetController.updateIncome(income: income, amount: newamount)
//        } else {
//            let monthYear = monthCalculator.monthYear
//            budgetController.createIncome(amount: amount, monthYear: monthYear)
//            income = budgetController.readIncome(monthYear: monthYear)
//        }
//
//        dismissView()
//        getRemainingFunds()
//        updateView()
//    }
//    func dismissView() {
//        let totalViewsNumber = self.view.subviews.count
//        self.view.subviews[totalViewsNumber - 1].removeFromSuperview()
//    }
//    @objc func touchToDismiss() {
//        dismissView()
//    }
//}
//
//extension HomeViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if touch.view != backgroundView {
//            return false
//        }
//        return true
//    }
//}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
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
