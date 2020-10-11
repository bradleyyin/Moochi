//
//  AddCategoriesViewController.swift
//  budget
//
//  Created by Bradley Yin on 10/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import UIKit
import RxSwift

protocol AddCategoriesViewControllerDelegate: class {
    func didTapClose()
}

final class AddCategoriesViewController: UIViewController {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    private let dependency: Dependency
    private let disposeBag = DisposeBag()

    private var viewModel: AddCategoriesViewModel
    weak var delegate: AddCategoriesViewControllerDelegate?

    init(category: Category?, dependency: Dependency) {
        self.dependency = dependency
        self.viewModel = AddCategoriesViewModel(category: category, dependency: dependency)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //self.categoryPicker = UIPickerView()
        //categoryPicker.delegate = self
        //categoryPicker.dataSource = self
        //showCategoryPicker()

        view.addSubview(closeButton)
        view.addSubview(checkButton)
        view.addSubview(titleLabel)
        view.addSubview(categoryNameLabel)
        view.addSubview(categoryNameTextField)
        view.addSubview(categoryNameSeparator)
        view.addSubview(categoryAmountLabel)
        view.addSubview(categoryAmountTextField)
        view.addSubview(categoryAmountSeparator)

        view.addSubview(pickCategoryLabel)
        view.addSubview(categoryCollectionView)

        // Do any additional setup after loading the view.

        setupConstraint()
        setupBinding()
        setupTapToDismissKeyBoard()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        //self.imagePicker = UIImagePickerController()
        //self.imagePicker.delegate = self
        //self.imagePicker.allowsEditing = false
    }

    private func setupBinding() {
        //expense
        viewModel.name.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.categoryNameTextField.text = self.viewModel.expenseNameText
        }).disposed(by: disposeBag)

        viewModel.amount.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.categoryAmountTextField.text = self.viewModel.expenseAmountText
        }).disposed(by: disposeBag)

        viewModel.currentSelectedIconNumber.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.categoryCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }

    private func setupConstraint() {
        closeButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(36)
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(top).inset(8)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton)
        }

        checkButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalTo(closeButton)
            make.height.width.equalTo(36)
        }

        categoryNameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.width.equalTo(118)
        }

        categoryNameTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(categoryNameLabel.snp.trailing).offset(67)
            make.centerY.equalTo(categoryNameLabel)
            make.trailing.equalToSuperview().inset(8)
        }

        categoryNameSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(categoryNameLabel.snp.bottom).offset(16)
        }

        categoryAmountLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(categoryNameSeparator.snp.bottom).offset(16)
        }

        categoryAmountTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(categoryNameTextField)
            make.centerY.equalTo(categoryAmountLabel)
            make.trailing.equalToSuperview().inset(8)
        }

        categoryAmountSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(categoryAmountLabel.snp.bottom).offset(16)
        }

        pickCategoryLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(categoryAmountSeparator.snp.bottom).offset(16)
        }

        categoryCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(pickCategoryLabel).offset(-4)
            make.trailing.equalToSuperview()
            make.top.equalTo(pickCategoryLabel.snp.bottom)
            make.height.equalTo(300)
        }
//
//        deleteIconImageView.snp.makeConstraints { (make) in
//            make.width.height.equalTo(24)
//            make.centerX.equalToSuperview()
//            make.top.equalTo(recieptImageView.snp.bottom).offset(24)
//            make.bottom.equalToSuperview().inset(16)
//        }
    }

    private func setupTapToDismissKeyBoard() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewTappedToDismissKeyboard))
        pan.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(pan)
    }

    //MARK: Action
    @objc func viewTappedToDismissKeyboard() {
        view.endEditing(true)
    }

    @objc func closeButtonTapped() {
        delegate?.didTapClose()
    }

    @objc func checkButtonTapped() {
        viewModel.confirmCategory()
        delegate?.didTapClose()
    }

    @objc func deleteButtonTapped() {
        //viewModel.deleteExpense()
        delegate?.didTapClose()
    }

    //MARK: UI
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "close"), for: .normal)
        return button
    }()

    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "check"), for: .normal)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.screenTitleText
        return label
    }()

    private lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Category Name"
        label.font = FontPalette.font(size: 17, fontType: .light)
        return label
    }()

    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.font = FontPalette.font(size: 17, fontType: .light)
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()

    private lazy var categoryNameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()

    private lazy var categoryAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Budget Amount"
        label.font = FontPalette.font(size: 17, fontType: .light)
        return label
    }()

    private lazy var categoryAmountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.00"
        textField.font = FontPalette.font(size: 17, fontType: .light)
        textField.delegate = self
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var categoryAmountSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()

    private lazy var pickCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick an Icon"
        label.font = FontPalette.font(size: 17, fontType: .light)
        return label
    }()

    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CategoryIconCell.self, forCellWithReuseIdentifier: "categoryIconCell")
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var deleteIconImageView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "AddEntry_deleteIcon"), for: .normal)
        return button
    }()
}

extension AddCategoriesViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == categoryAmountTextField {
            viewModel.updateAmount(string: string)
            return false
        }

        if textField == categoryNameTextField {
            viewModel.updateName(string: string)
            return false
        }

        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.amountTypedString = ""
        return true
    }
}

extension AddCategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryIconCell", for: indexPath) as! CategoryIconCell
        let cellViewModel = viewModel.viewModelForCell(at: indexPath)
        cell.setupWith(viewModel: cellViewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 64)
    }
}

extension AddCategoriesViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == self.view && otherGestureRecognizer.view == self.categoryCollectionView {
            return true
        }

        return false
    }
}
