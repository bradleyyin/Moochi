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
    var parenController : MainViewController?
    var hasIncome = false{
        didSet{
            setupViews()
        }
    }
    var amountTypedString = ""
    
    let lblName: UILabel = {
        let lbl=UILabel()
        lbl.text="current income"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font=UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let cancelButton: UIButton = {
        let btn=UIButton()
        btn.setImage(UIImage(named: "cancel"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(dissmissView), for: .touchUpInside)
        return btn
    }()
    
    let updateButton: UIButton = {
        let btn=UIButton()
        btn.setTitle("Update", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(updateIncome), for: .touchUpInside)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        btn.layer.cornerRadius = 30
        return btn
    }()
    
    let addTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.tag = 1
        textField.text = "0.00"
        textField.textAlignment = .center
        return textField
    }()
    let subtractTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.tag = 2
        textField.text = "0.00"
        textField.textAlignment = .center
        return textField
    }()
    let incomeTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.tag = 0
        textField.text = "0.00"
        textField.textAlignment = .center
        return textField
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.red
        
        //setupViews()
    }

    
    func setupViews() {
        self.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lblName.trailingAnchor.constraint(equalTo: trailingAnchor).isActive=true
        lblName.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        addTextField.delegate = self
        subtractTextField.delegate = self
        incomeTextField.delegate = self
        
        var textFields = UIStackView(arrangedSubviews: [addTextField,subtractTextField])
        if !hasIncome{
            textFields = UIStackView(arrangedSubviews: [incomeTextField])
        }
        self.addSubview(textFields)
        textFields.axis = .vertical
        textFields.distribution = .fillEqually
        textFields.alignment = .fill
        textFields.translatesAutoresizingMaskIntoConstraints = false
        textFields.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textFields.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textFields.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: 10).isActive = true
        
        self.addSubview(updateButton)
        updateButton.topAnchor.constraint(equalTo: textFields.bottomAnchor, constant: 20).isActive = true
        updateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        updateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        updateButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 70 * heightRatio).isActive = true

        
        
        
//        let buttons = UIStackView(arrangedSubviews: [cancelButton, updateButton])
//        self.addSubview(buttons)
//        buttons.axis = .horizontal
//        buttons.distribution = .fillEqually
//        buttons.alignment = .fill
//        buttons.spacing = 0
//        buttons.translatesAutoresizingMaskIntoConstraints = false
//        buttons.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        buttons.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        buttons.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
    }
    
    @objc func dissmissView(){
        delegate?.dismissView()
    }
    
    @objc func updateIncome(){
        print("update income")
        if hasIncome{
            guard let addString = addTextField.text, let addAmount = Double(addString), let subtractString = subtractTextField.text, let subtractAmount = Double(subtractString) else {return}
            
        }else{
            guard let amountString = incomeTextField.text, let amount = Double(amountString) else {return}
            delegate?.enterIncome(amount: amount)
        }
    }
  

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension EditIncomeView: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        //if textField.tag == 0 {
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            
            if string.count > 0 {
                print ("here")
                amountTypedString += string
                let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
                //let numbString = NSString(format:"%.2f", decNumber) as String
                let newString = formatter.string(from: decNumber)!
                //let newString = "$" + numbString
                textField.text = newString
            } else {
                amountTypedString = String(amountTypedString.dropLast())
                if amountTypedString.count > 0 {
                    
                    let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
                    
                    let newString = formatter.string(from: decNumber)!
                    textField.text = newString
                } else {
                    textField.text = "0.00"
                }
                
            }
   //     }
        
        
        return false
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        amountTypedString = ""
        return true
    }
    
}
