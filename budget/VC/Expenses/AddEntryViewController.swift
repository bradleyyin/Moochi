//
//  AddEntryViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

//swiftlint:disable function_body_length

import UIKit
import CoreData

class AddEntryViewController: BasicViewController {
    
    weak var imageView: UIImageView!
    weak var nameTextField: UITextField!
    weak var amountTextFeild: UITextField!
    weak var dateTextField: UITextField!
    
    weak var categoryTextFeild: UITextField!
    
    var imagePicker: UIImagePickerController!
    var datePicker: UIDatePicker!
    var categoryPicker: UIPickerView!
    let formatter = DateFormatter()
    
    var categorypickerData: [String] {
        var nameArray: [String] = ["uncategorized"]
        for category in categories {
            nameArray.append(category.name!)
        }
        return nameArray
    }
    var selectedCategory: String = "uncategorized"
    
    var date: Date?
    var amountTypedString = ""
    

    override func viewDidLoad() {
       
        formatter.dateFormat = "MM/dd/yyyy"
        titleOfVC = "add an entry"
        super.viewDidLoad()
        
        loadCategories()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        
        self.datePicker = UIDatePicker()
        self.categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        showCategoryPicker()
        showDatePicker()
    }
    override func setupUI() {
        super.setupUI()
        
        self.view.backgroundColor = .white
        
        if let label = self.view.subviews[0] as? TitleLabel {
            label.widthAnchor.constraint(equalToConstant: screenWidth * 3 / 4).isActive = true
        }
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        button.setImage(UIImage(named: "checkMark"), for: .normal)
        button.addTarget(self, action: #selector(checkMarkTapped), for: .touchUpInside)
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button2)
        button2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        button2.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button2.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button2.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + 50 * heightRatio - buttonHeight / 2).isActive = true
        button2.setImage(UIImage(named: "cancel"), for: .normal)
        button2.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        let nameLabel = UILabel()
        nameLabel.text = "NAME"
        nameLabel.textColor = .black
        nameLabel.font = UIFont(name: fontName, size: 20)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.3
        nameLabel.backgroundColor = .clear
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let nameTextField = UITextField()
        nameTextField.textColor = .black
        nameTextField.setBottomBorder()
        nameTextField.autocorrectionType = .no
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.nameTextField = nameTextField
        
        let amountLabel = UILabel()
        amountLabel.text = "AMOUNT"
        amountLabel.textColor = .black
        amountLabel.font = UIFont(name: fontName, size: 20)
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.minimumScaleFactor = 0.3
        
        let amountTextField = UITextField()
        amountTextField.textColor =  .black
        amountTextField.text = "0.00"
        amountTextField.delegate = self
        amountTextField.setBottomBorder()
        amountTextField.keyboardType = .numberPad
        
        self.amountTextFeild = amountTextField
        addToolBarNameAndAmount()
        
        let dateLabel = UILabel()
        dateLabel.text = "DATE"
        dateLabel.textColor = .black
        dateLabel.font = UIFont(name: fontName, size: 20)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.3
        
        let dateTextField = UITextField()
        dateTextField.textColor =  .black
        if let date = date {
            dateTextField.text = formatter.string(from: date)
        } else {
            dateTextField.text = formatter.string(from: Date())
        }
        dateTextField.setBottomBorder()
        self.dateTextField = dateTextField
        
        let categoryLabel = UILabel()
        categoryLabel.text = "CATEGORY"
        categoryLabel.font = UIFont(name: fontName, size: 20)
        categoryLabel.textColor = .black
        //categoryLabel.adjustsFontSizeToFitWidth = true
        //categoryLabel.minimumScaleFactor = 0.3
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.widthAnchor.constraint(equalToConstant: screenWidth * 3 / 10).isActive = true
        
        let categoryTextField = UITextField()
        categoryTextField.textColor =  .black
        categoryTextField.text = "UNCATEGORIZED"
        categoryTextField.setBottomBorder()
        self.categoryTextFeild = categoryTextField
        
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        nameStackView.axis = .horizontal
        nameStackView.distribution = .fill
        nameStackView.alignment = .fill
        nameStackView.spacing = 16
        
        let amountStackView = UIStackView(arrangedSubviews: [amountLabel, amountTextField])
        amountStackView.axis = .horizontal
        amountStackView.distribution = .fill
        amountStackView.alignment = .fill
        amountStackView.spacing = 16.0
        
        let dateStackView = UIStackView(arrangedSubviews: [dateLabel, dateTextField])
        dateStackView.axis = .horizontal
        dateStackView.distribution = .fill
        dateStackView.alignment = .fill
        dateStackView.spacing = 16.0
        
        let categoryStackView = UIStackView(arrangedSubviews: [categoryLabel, categoryTextField])
        categoryStackView.axis = .horizontal
        categoryStackView.distribution = .fill
        categoryStackView.alignment = .fill
        categoryStackView.spacing = 16.0
        
        let totalStackView = UIStackView(arrangedSubviews: [nameStackView, amountStackView, dateStackView, categoryStackView])
        totalStackView.axis = .vertical
        totalStackView.distribution = .fillEqually
        totalStackView.alignment = .fill
        totalStackView.spacing = 40 * heightRatio
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        amountTextField.leadingAnchor.constraint(equalTo: categoryTextField.leadingAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: categoryTextField.leadingAnchor).isActive = true
        dateTextField.leadingAnchor.constraint(equalTo: categoryTextField.leadingAnchor).isActive = true
        
        self.view.addSubview(totalStackView)
        
        totalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        totalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        totalStackView.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20 * heightRatio).isActive = true
        
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: totalStackView.bottomAnchor, constant: 30 * heightRatio).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100 * heightRatio).isActive = true
        
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "addImage")
        imageView.contentMode = .center
        imageView.backgroundColor = superLightGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        self.imageView = imageView
        
       
    }
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
    @objc func checkMarkTapped() {
        
        guard let name = nameTextField.text, !name.isEmpty,
            let amountString = amountTextFeild.text, let amount = Double(amountString),
            let dateString = dateTextField.text,
            let date = formatter.date(from: dateString) else { return }
       
        print(name)
        print(amount)
        print(date)
        var image: UIImage? = imageView.image
        if imageView.image == UIImage(named: "addImage") {
            image = nil
        }
        print(categoryPicker.selectedRow(inComponent: 0))
        print(categories)
        var category: Category?
        if categoryPicker.selectedRow(inComponent: 0) == 0 {
            category = nil
        } else {
            category = categories[categoryPicker.selectedRow(inComponent: 0) - 1]
        }
        budgetController.createNewExpense(name: name, amount: amount, date: date, category: category, image: image)
        NotificationCenter.default.post(name: Notification.Name("addedEntry"), object: nil)
        dismiss(animated: true, completion: nil)
        
        
    }
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func showDatePicker() {
        //format date
        if let date = date {
            datePicker.date = date
        }
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date(timeIntervalSinceReferenceDate: 0)
    
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    func showCategoryPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneCategoryPicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        categoryTextFeild.inputAccessoryView = toolbar
        categoryTextFeild.inputView = categoryPicker
        
        
    }
    
    func addToolBarNameAndAmount() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        amountTextFeild.inputAccessoryView = toolbar
        nameTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func doneDatePicker() {
        
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @objc func doneCategoryPicker() {
        categoryTextFeild.text = selectedCategory.uppercased()
        self.view.endEditing(true)
    }
}

extension AddEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}

extension UITextField {
    
    //To add bottom border only
    func setBottomBorder(withColor color: UIColor = .black) {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 1.0
        
        let borderLine = UIView()
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(borderLine)
        borderLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        borderLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        borderLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        borderLine.heightAnchor.constraint(equalToConstant: width).isActive = true
        borderLine.backgroundColor = color
        
    }
}
extension AddEntryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == amountTextFeild {
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            
            if !string.isEmpty {
                amountTypedString += string
                let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
                //let numbString = NSString(format:"%.2f", decNumber) as String
                let newString = formatter.string(from: decNumber)!
                //let newString = "$" + numbString
                textField.text = newString
            } else {
                amountTypedString = String(amountTypedString.dropLast())
                if !amountTypedString.isEmpty {
                    
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


extension AddEntryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorypickerData.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorypickerData[row].uppercased()
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categorypickerData[row]
    }
    
}
