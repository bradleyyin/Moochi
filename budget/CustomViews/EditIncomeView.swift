//
//  EditIncomeView.swift
//  budget
//
//  Created by Bradley Yin on 8/1/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
protocol EditIncomeDelegate {
    func enterIncome(amount: Double)
    func dismissView()
}

class EditIncomeView: UIView {
    var delegate: EditIncomeDelegate?
    var parenController: MainViewController?
    var hasIncome = false {
        didSet{
            setupViews()
        }
    }
    var amountTypeString = ""
    var amountAddTypedString = ""
    var amountSubtractTypedString = ""
    
    let lblName: UILabel = {
        let lbl = UILabel()
        lbl.text="current income"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont(name: fontName, size: 30)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.3
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let cancelButton: UIButton = {
        let btn=UIButton()
        btn.setImage(UIImage(named: "cancel"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(dissmissView), for: .touchUpInside)
        return btn
    }()
    
    let updateButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Update", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(updateIncome), for: .touchUpInside)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        btn.layer.cornerRadius = 30
        return btn
    }()
    
    let addLabel: UILabel = {
        let label = UILabel()
        label.text = "add"
        label.textColor = .black
        label.font = UIFont(name: fontName, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.tag = 1
        textField.text = "0.00"
        textField.font = UIFont(name: fontName, size: 25)
        textField.textAlignment = .center
        return textField
    }()
    
    let subtractLabel: UILabel = {
        let label = UILabel()
        label.text = "subtract"
        label.textColor = .black
        label.font = UIFont(name: fontName, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtractTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.tag = 2
        textField.text = "0.00"
        textField.textAlignment = .center
        textField.font = UIFont(name: fontName, size: 25)
        return textField
    }()
    let incomeTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.tag = 0
        textField.placeholder = "enter income here"
        textField.font = UIFont(name: fontName, size: 25)
        textField.textAlignment = .center
        return textField
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        //setupViews()
    }

    
    func setupViews() {
        self.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        self.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lblName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        lblName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        addTextField.delegate = self
        subtractTextField.delegate = self
        incomeTextField.delegate = self
        
        addTextField.addSubview(addLabel)
        addLabel.topAnchor.constraint(equalTo: addTextField.topAnchor).isActive = true
        addLabel.bottomAnchor.constraint(equalTo: addTextField.bottomAnchor).isActive = true
        addLabel.leadingAnchor.constraint(equalTo: addTextField.leadingAnchor).isActive = true
        
        subtractTextField.addSubview(subtractLabel)
        subtractLabel.topAnchor.constraint(equalTo: subtractTextField.topAnchor).isActive = true
        subtractLabel.bottomAnchor.constraint(equalTo: subtractTextField.bottomAnchor).isActive = true
        subtractLabel.leadingAnchor.constraint(equalTo: subtractTextField.leadingAnchor).isActive = true
        
        var textFields = UIStackView(arrangedSubviews: [addTextField, subtractTextField])
        if !hasIncome {
            textFields = UIStackView(arrangedSubviews: [incomeTextField])
        }
        self.addSubview(textFields)
        textFields.axis = .vertical
        textFields.distribution = .fillEqually
        textFields.alignment = .fill
        textFields.translatesAutoresizingMaskIntoConstraints = false
        textFields.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        textFields.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
        textFields.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: 10).isActive = true
        
        self.addSubview(updateButton)
        updateButton.topAnchor.constraint(equalTo: textFields.bottomAnchor, constant: 20).isActive = true
        updateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        updateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
        updateButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 70 * heightRatio).isActive = true
        
    }
    
    @objc func dissmissView() {
        delegate?.dismissView()
    }
    
    @objc func updateIncome() {
        print("update income")
        if hasIncome {
            guard let addString = addTextField.text,
                let addAmount = Double(addString),
                let subtractString = subtractTextField.text,
                let subtractAmount = Double(subtractString) else { return }
            
            let total = addAmount - subtractAmount
            delegate?.enterIncome(amount: total)
            
        } else {
            guard let amountString = incomeTextField.text, let amount = Double(amountString) else { return }
            delegate?.enterIncome(amount: amount)
        }
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension EditIncomeView: UITextFieldDelegate {
    
    func autoDecimal(string: String, textField: UITextField, stringToStore: inout String) {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        if !string.isEmpty {
            stringToStore += string
            let decNumber = NSDecimalNumber(string: stringToStore).multiplying(by: 0.01)
            //let numbString = NSString(format:"%.2f", decNumber) as String
            let newString = formatter.string(from: decNumber)!
            //let newString = "$" + numbString
            textField.text = newString
        } else {
            stringToStore = String(stringToStore.dropLast())
            if !stringToStore.isEmpty {
                
                let decNumber = NSDecimalNumber(string: stringToStore).multiplying(by: 0.01)
                
                let newString = formatter.string(from: decNumber)!
                textField.text = newString
            } else {
                textField.text = "0.00"
            }
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1 {
            autoDecimal(string: string, textField: textField, stringToStore: &amountAddTypedString)
        } else if textField.tag == 2 {
            autoDecimal(string: string, textField: textField, stringToStore: &amountSubtractTypedString)
        } else {
            autoDecimal(string: string, textField: textField, stringToStore: &amountTypeString)
        }
        return false
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            amountAddTypedString = ""
        } else if textField.tag == 2 {
            amountSubtractTypedString = ""
        } else {
            amountTypeString = ""
        }
        return true
    }
    
}
