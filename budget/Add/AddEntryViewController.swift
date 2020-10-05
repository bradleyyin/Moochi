//
//  AddEntryViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

//swiftlint:disable function_body_length

import UIKit
import RxSwift

final class AddEntryViewController: UIViewController {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    private let dependency: Dependency
    private let disposeBag = DisposeBag()

    private var viewModel: AddExpenseViewModel

    init(expense: Expense?, dependency: Dependency) {
        self.dependency = dependency
        self.viewModel = AddExpenseViewModel(expense: expense, dependency: dependency)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadCategories()
        //self.categoryPicker = UIPickerView()
        //categoryPicker.delegate = self
        //categoryPicker.dataSource = self
        //showCategoryPicker()
        showDatePicker()

        view.addSubview(closeButton)
        view.addSubview(checkButton)
        view.addSubview(titleLabel)
        view.addSubview(entryNameLabel)
        view.addSubview(entryNameTextField)
        view.addSubview(entryNameSeparator)
        view.addSubview(entryAmountLabel)
        view.addSubview(entryAmountTextField)
        view.addSubview(entryAmountSeparator)
        view.addSubview(entryDateLabel)
        view.addSubview(entryDateTextField)
        view.addSubview(entryDateSeparator)
        view.addSubview(entryCategoryLabel)
        view.addSubview(selectedCategoryLabel)
        view.addSubview(categoryCollectionView)
        view.addSubview(entryCategorySeparator)
        view.addSubview(noteLabel)
        view.addSubview(noteTextView)
        view.addSubview(noteSeparator)
        view.addSubview(recieptLabel)
        view.addSubview(recieptImageView)
        // Do any additional setup after loading the view.

        setupConstraint()
        setupBinding()
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
            self.entryNameTextField.text = self.viewModel.expenseNameText
        }).disposed(by: disposeBag)

        viewModel.date.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.entryDateTextField.text = self.viewModel.expenseDateText
        }).disposed(by: disposeBag)

        viewModel.amount.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.entryAmountTextField.text = self.viewModel.expenseAmountText
        }).disposed(by: disposeBag)
        //image of reciept
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
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton)
            make.height.width.equalTo(36)
        }

        entryNameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.width.equalTo(90)
        }

        entryNameTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(entryNameLabel.snp.trailing).offset(67)
            make.centerY.equalTo(entryNameLabel)
            make.trailing.equalToSuperview().inset(8)
        }

        entryNameSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(entryNameLabel.snp.bottom).offset(16)
        }

        entryAmountLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(entryNameSeparator.snp.bottom).offset(16)
        }

        entryAmountTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(entryNameTextField)
            make.centerY.equalTo(entryAmountLabel)
            make.trailing.equalToSuperview().inset(8)
        }

        entryAmountSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(entryAmountLabel.snp.bottom).offset(16)
        }

        entryDateLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(entryAmountSeparator.snp.bottom).offset(16)
        }

        entryDateTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(entryNameTextField)
            make.centerY.equalTo(entryDateLabel)
            make.trailing.equalToSuperview().inset(8)
        }

        entryDateSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(entryDateLabel.snp.bottom).offset(16)
        }

        entryCategoryLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(entryDateSeparator.snp.bottom).offset(16)
        }

        selectedCategoryLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(entryNameTextField)
            make.centerY.equalTo(entryCategoryLabel)
            make.trailing.equalToSuperview().inset(8)
        }

        categoryCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(entryCategoryLabel)
            make.trailing.equalToSuperview()
            make.top.equalTo(entryCategoryLabel.snp.bottom).offset(16)
            make.height.equalTo(56)
        }

        entryCategorySeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(16)
        }

        noteLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(entryCategorySeparator.snp.bottom).offset(16)
        }

        noteTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(entryNameTextField)
            make.top.equalTo(noteLabel)
            make.height.equalTo(100) //dynamic later
            make.trailing.equalToSuperview().inset(8)
        }

        noteSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(noteLabel.snp.bottom).offset(16)
        }

        recieptLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(noteSeparator.snp.bottom).offset(16)
        }

        recieptImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(entryNameTextField)
            make.top.equalTo(recieptLabel)
            make.height.equalTo(100) //dynamic later
            make.trailing.equalToSuperview().inset(8)
        }
    }

    private func loadCategories() {
        //categories = budgetController.readCategories()
    }

    //MARK: Action
    @objc func imageTapped() {
//        let alertController = UIAlertController(title: "select source", message: nil, preferredStyle: .actionSheet)
//
//        let choseCam = UIAlertAction(title: "Camera", style: .default) { _ in
//            self.imagePicker.sourceType = .camera
//            self.present(self.imagePicker, animated: true)
//        }
//        let choseLibrary = UIAlertAction(title: "Photo", style: .default) { _ in
//            self.imagePicker.sourceType = .photoLibrary
//            self.present(self.imagePicker, animated: true)
//        }
//        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { _ in
//            //cancel
//        }
//        alertController.addAction(choseCam)
//        alertController.addAction(choseLibrary)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true)
        
    }
    @objc func checkMarkTapped() {
//
//        guard let name = nameTextField.text, !name.isEmpty,
//            let amountString = amountTextField.text, let amount = Double(amountString),
//            let dateString = dateTextField.text,
//            let date = formatter.date(from: dateString) else { return }
//
//        var image: UIImage? = imageView.image
//        if imageView.image == UIImage(named: "addImage") {
//            image = nil
//        }
//        var category: Category? = expense?.parentCategory
//        if categoryPicker.selectedRow(inComponent: 0) == 0 && category != nil && categoryTextField.text == "UNCATEGORIZED" {
//            category = nil
//        } else if categoryPicker.selectedRow(inComponent: 0) != 0 {
//            //category = categories[categoryPicker.selectedRow(inComponent: 0) - 1]
//        }
//        if let expense = expense {
//            budgetController.updateExpense(expense: expense, name: name, amount: amount, date: date, category: category, image: image)
//        } else {
//            budgetController.createNewExpense(name: name, amount: amount, date: date, category: category, image: image)
//        }
//
//        NotificationCenter.default.post(name: Notification.Name("changedEntry"), object: nil)
//        dismiss(animated: true, completion: nil)
//
//
    }
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func showDatePicker() {
        //format date
//        if let date = viewModel.date {
//            datePicker.date = date
//        }
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        //dateTextField.inputAccessoryView = toolbar
        //dateTextField.inputView = datePicker
    }
    
    func addToolBarNameAndAmount() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        //amountTextField.inputAccessoryView = toolbar
        //nameTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func doneDatePicker() {
//
//        dateTextField.text = formatter.string(from: datePicker.date)
//        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @objc func doneCategoryPicker() {
//        categoryTextField.text = selectedCategory.uppercased()
//        self.view.endEditing(true)
    }

    //MARK: UI
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private lazy var checkButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.screenTitleText
        return label
    }()

    private lazy var entryNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Entry Name"
        return label
    }()

    private lazy var entryNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        return textField
    }()

    private lazy var entryNameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()

    private lazy var entryAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Entry Amount"
        return label
    }()

    private lazy var entryAmountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.00"
        textField.delegate = self
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var entryAmountSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()

    private lazy var entryDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Entry Date"
        return label
    }()

    private lazy var entryDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = viewModel.formatter.string(from: Date())
        return textField
    }()

    private lazy var entryDateSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()

    private lazy var entryCategoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var selectedCategoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()

    private lazy var entryCategorySeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()

    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var noteTextView: UITextView = {
        let view = UITextView()
        return view
    }()

    private lazy var noteSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()

    private lazy var recieptLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var recieptImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date(timeIntervalSinceReferenceDate: 0)
        return picker
    }()
}

//extension AddEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imageView.image = userPickedImage
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            imagePicker.dismiss(animated: true, completion: nil)
//        }
//    }
//}

extension AddEntryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == entryAmountTextField {
            viewModel.updateAmount(string: string)
        }
        
        return false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.amountTypedString = ""
        return true
    }

}


extension AddEntryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        1
    }
    
    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return categorypickerData.count
//    }
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return categorypickerData[row].uppercased()
//    }
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 200
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedCategory = categorypickerData[row]
//    }
    
}
