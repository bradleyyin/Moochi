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

protocol AddEntryViewControllerDelegate: class {
    func didTapClose()
}

final class AddEntryViewController: UIViewController {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    private let dependency: Dependency
    private let disposeBag = DisposeBag()

    private var viewModel: AddExpenseViewModel
    weak var delegate: AddEntryViewControllerDelegate?

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
        view.addSubview(recieptInstructionLabel)
        view.addSubview(recieptIconImageView)
        view.addSubview(recieptImageView)
        view.addSubview(deleteIconImageView)
        // Do any additional setup after loading the view.

        setupConstraint()
        setupBinding()
        setupDatePicker()
        setupPanToDismissKeyBoard()
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

        viewModel.category.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.categoryCollectionView.reloadData()
            self.selectedCategoryLabel.text = self.viewModel.expenseCategoryText
        }).disposed(by: disposeBag)

        viewModel.note.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.noteTextView.snp.remakeConstraints { (make) in
                make.leading.equalTo(self.entryNameTextField)
                make.top.equalTo(self.noteLabel)
                make.height.equalTo(self.viewModel.noteHeight) //dynamic later
                make.trailing.equalToSuperview().inset(8)
            }
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
            make.trailing.equalToSuperview().inset(8)
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
            make.leading.equalTo(entryCategoryLabel).offset(-4)
            make.trailing.equalToSuperview()
            make.top.equalTo(entryCategoryLabel.snp.bottom)
            make.height.equalTo(88)
        }

        entryCategorySeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(categoryCollectionView.snp.bottom)
        }

        noteLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(entryCategorySeparator.snp.bottom).offset(16)
        }

        noteTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(entryNameTextField)
            make.top.equalTo(noteLabel)
            make.height.equalTo(74) //dynamic later
            make.trailing.equalToSuperview().inset(8)
        }

        noteSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(noteTextView.snp.bottom).offset(16)
        }

        recieptLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(noteSeparator.snp.bottom).offset(16)
        }

        recieptImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(recieptLabel.snp.trailing).offset(16)
            make.top.equalTo(recieptLabel)
            make.trailing.equalToSuperview().inset(8)
        }

        recieptInstructionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(entryNameTextField)
            make.top.equalTo(recieptLabel)
        }

        recieptIconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(recieptLabel)
            make.height.width.equalTo(22)
            make.trailing.equalToSuperview().inset(16)
        }

        deleteIconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(recieptImageView.snp.bottom).offset(24)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    private func setupPanToDismissKeyBoard() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewTappedToDismissKeyboard))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(pan)
    }

    private func loadCategories() {
        //categories = budgetController.readCategories()
    }

    //MARK: Action
    @objc func imageTapped() {
        let alertController = UIAlertController(title: "select source", message: nil, preferredStyle: .actionSheet)

        let choseCam = UIAlertAction(title: "Camera", style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }

        let choseLibrary = UIAlertAction(title: "Photo", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { _ in
            //cancel
        }
        alertController.addAction(choseCam)
        alertController.addAction(choseLibrary)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }

    @objc func viewTappedToDismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupDatePicker() {
        //format date
        if let date = viewModel.date.value {
            datePicker.date = date
        }
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        entryDateTextField.inputAccessoryView = toolbar
        entryDateTextField.inputView = datePicker
    }
    
    func addToolBarNameAndAmount() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        entryAmountTextField.inputAccessoryView = toolbar
        entryNameTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneDatePicker() {
        viewModel.updateDate(datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }

    @objc func closeButtonTapped() {
        delegate?.didTapClose()
    }

    @objc func checkButtonTapped() {
        viewModel.confirmExpense()
        delegate?.didTapClose()
    }

    @objc func deleteButtonTapped() {
        viewModel.deleteExpense()
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

    private lazy var entryNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Entry Name"
        return label
    }()

    private lazy var entryNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.delegate = self
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
        label.text = "Entry Category"
        return label
    }()

    private lazy var selectedCategoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CategorySelectionCell.self, forCellWithReuseIdentifier: "categoryCell")
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var entryCategorySeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()

    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        return label
    }()

    private lazy var noteTextView: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.text = "Notes"
        view.textColor = .gray
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.font = FontPalette.font(size: 17, fontType: .light)
        return view
    }()

    private lazy var noteSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()

    private lazy var recieptLabel: UILabel = {
        let label = UILabel()
        label.text = "Receipt"
        return label
    }()

    private lazy var recieptInstructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to add a photo"
        label.textColor = .gray
        return label
    }()

    private lazy var recieptIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "AddEntry_addPhotoIcon")
        return view
    }()

    private lazy var deleteIconImageView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "deleteIcon"), for: .normal)
        return button
    }()

    private lazy var recieptImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapImageViewGesture)
        return view
    }()

    private lazy var tapImageViewGesture: UIGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        return tap
    }()

    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date(timeIntervalSinceReferenceDate: 0)
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return picker
    }()
}

extension AddEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            recieptImageView.image = userPickedImage
            recieptImageView.contentMode = .scaleAspectFill
            recieptImageView.clipsToBounds = true
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddEntryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == entryAmountTextField {
            viewModel.updateAmount(string: string)
        }

        if textField == entryNameTextField {
            viewModel.updateName(string: string)
        }
        
        return false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.amountTypedString = ""
        return true
    }

}

extension AddEntryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategorySelectionCell
        let cellViewModel = viewModel.viewModelForCell(at: indexPath)
        cell.setupWith(viewModel: cellViewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 92, height: 88)
    }
}

extension AddEntryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateNote(textView.text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notes" {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = .gray
        }
    }
}

extension AddEntryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        6
    }
}

extension AddEntryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == self.view {
            return true
        }

        return false
    }
}
