//
//  DetailsViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

protocol DetailsViewControllerDelegate: class {
    func addButtonTapped()
    func categoryTapped(category: Category)
}

class DetailsViewController: UIViewController {

    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    let dependency: Dependency

    weak var delegate: DetailsViewControllerDelegate?
    private var viewModel: DetailsViewModel
    private var disposeBag = DisposeBag()

    init(dependency: Dependency) {
        self.dependency = dependency
        self.viewModel = DetailsViewModel(dependency: dependency)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

        view.addSubview(titleLabel)
        view.addSubview(sliderView)
        view.addSubview(menuButton)
        view.addSubview(plusButton)
        view.addSubview(incomeNotBudgetLabel)
        view.addSubview(tableView)

        setupConstraints()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.performWithoutAnimation {
            sliderView.setSelectedIndex(0)
        }

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUIColor()
    }
    private func setupUIColor() {
//        if traitCollection.userInterfaceStyle == .light {
//            self.view.backgroundColor = .white
//            incomeNotBudgetLabel.textColor = .black
//            screenTitleLabel.textColor = .black
//            addCategoryButton.setTitleColor(.black, for: .normal)
//        } else {
//            self.view.backgroundColor = .black
//            incomeNotBudgetLabel.textColor = .white
//            screenTitleLabel.textColor = .white
//            addCategoryButton.setTitleColor(.white, for: .normal)
//        }
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(top).inset(12)
        }

        menuButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(36)
            make.trailing.equalTo(plusButton.snp.leading).offset(-8)
            make.centerY.equalTo(titleLabel)
        }

        plusButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(36)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalTo(titleLabel)

        }

        sliderView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(34)
            make.height.equalTo(29)
        }

        incomeNotBudgetLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sliderView.snp.bottom).offset(16)
        }

        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(incomeNotBudgetLabel.snp.bottom).offset(32)
        }
    }

    private func setupBinding() {
        viewModel.incomeNotBuget.asObservable().subscribe(onNext: { [weak self] incomeNotBudget in
            guard let self = self else { return }
            if let incomeNotBudget = incomeNotBudget {
                self.incomeNotBudgetLabel.text = "Unbudgeted Income: \(String(format: "%.2f", incomeNotBudget))"
            } else {
                self.incomeNotBudgetLabel.text = "No income information."
            }
        }).disposed(by: disposeBag)

        viewModel.categories.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    @objc private func plusButtonTapped() {
        delegate?.addButtonTapped()
    }

    @objc private func menuButtonTapped() {

    }

    //MARK: UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Monthly Details"
        return label
    }()

    private lazy var sliderView: SliderView = {
        let view = SliderView()
        view.titles = [NSAttributedString(string: "Category"), NSAttributedString(string: "Goal")]
        view.layer.cornerRadius = 15
        view.delegate = self
        return view
    }()

    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "menu"), for: .normal)
        return button
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "add"), for: .normal)
        return button
    }()

    private lazy var incomeNotBudgetLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = self
        view.delegate = self
        view.register(DetailsCategoryCell.self, forCellReuseIdentifier: "detailsCell")
        return view
    }()
}

extension DetailsViewController: SliderViewDelegate {
    func didSelectPage(index: Int, title: String) {
        //
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCategory
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let context = CoreDataStack.shared.mainContext
//
//        context.delete(fetchedResultsController.object(at: indexPath))
//
//        //TODO: run delete in controller
//
//        tableView.reloadData()
//
//    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { _, _, _ in

            self.viewModel.deleteCategory(at: indexPath)
        }

        delete.image = UIImage(named: "deleteIcon")?.withTintColor(.white)
        delete.backgroundColor = ColorPalette.red
        let edit = UIContextualAction(style: .normal, title: "edit") { _, _, _ in

        }

        edit.image = UIImage(named: "edit")
        edit.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.1)
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as? DetailsCategoryCell else {
            fatalError("cant make DetailTableViewCell")
        }
        let cellViewModel = viewModel.cellViewModel(at: indexPath)
        cell.setupWith(viewModel: cellViewModel)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.categories.value[indexPath.row]
        delegate?.categoryTapped(category: category)
//        let category = fetchedResultsController.fetchedObjects?[indexPath.row]
//        let chartVC = ChartViewController()
//        chartVC.category = category
//        self.navigationController?.pushViewController(chartVC, animated: true)
    }
}
