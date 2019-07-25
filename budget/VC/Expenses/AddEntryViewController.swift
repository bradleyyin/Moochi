//
//  AddEntryViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class AddEntryViewController: BasicViewController {
    
    weak var imageView : UIImageView!
    weak var nameTextField : UITextField!
    weak var amountTextFeild : UITextField!
    weak var dateTextField : UITextField!
    
    weak var categoryTextFeild : UITextField!
    
    var imagePicker : UIImagePickerController!
    var datePicker : UIDatePicker!
    

    override func viewDidLoad() {
       
        
        titleOfVC = "add an entry"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        
        self.datePicker = UIDatePicker()
        //TODO: - set up condition for date if coming from single day
        showDatePicker()
    }
    override func setupUI() {
        super.setupUI()
        
        self.view.backgroundColor = .lightGray
        
        if let label = self.view.subviews[0] as? TitleLabel{
            label.widthAnchor.constraint(equalToConstant: screenWidth * 3 / 4).isActive = true
        }
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + 50 * heightRatio - buttonHeight / 2).isActive = true
        button.setImage(UIImage(named: "checkMark"), for: .normal)
        button.addTarget(self, action: #selector(checkMarkTapped), for: .touchUpInside)

        
       
        let nameLabel = UILabel()
        nameLabel.text = "NAME"
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: fontName, size: 20)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.3
        nameLabel.backgroundColor = .red
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let nameTextField = UITextField()
        nameTextField.textColor = .white
        nameTextField.setBottomBorder()
        nameTextField.autocorrectionType = .no
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.nameTextField = nameTextField
        
        let amountLabel = UILabel()
        amountLabel.text = "AMOUNT"
        amountLabel.textColor = .white
        amountLabel.font = UIFont(name: fontName, size: 20)
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.minimumScaleFactor = 0.3
        
        let amountTextField = UITextField()
        amountTextField.textColor =  .white
        amountTextField.setBottomBorder()
        amountTextField.keyboardType = .numberPad
        
        self.amountTextFeild = amountTextField
        showNumpad()
        
        let dateLabel = UILabel()
        dateLabel.text = "DATE"
        dateLabel.textColor = .white
        dateLabel.font = UIFont(name: fontName, size: 20)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.3
        
        let dateTextField = UITextField()
        dateTextField.textColor =  .white
        dateTextField.setBottomBorder()
        self.dateTextField = dateTextField
        

        
        let categoryLabel = UILabel()
        categoryLabel.text = "CATEGORY"
        categoryLabel.font = UIFont(name: fontName, size: 20)
        categoryLabel.textColor = .white
        //categoryLabel.adjustsFontSizeToFitWidth = true
        //categoryLabel.minimumScaleFactor = 0.3
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.widthAnchor.constraint(equalToConstant: screenWidth * 3 / 10).isActive = true
        
        let categoryTextField = UITextField()
        categoryTextField.textColor =  .white
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
        
        totalStackView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20 * heightRatio).isActive = true
        
        
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
        imageView.contentMode = .scaleAspectFit
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        self.imageView = imageView
        
       
    }
    @objc func imageTapped(){
        let alertController = UIAlertController(title: "select source", message: nil, preferredStyle: .actionSheet)
        
        let choseCam = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }
        let choseLibrary = UIAlertAction(title: "Photo", style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { (action) in
            //cancel
        }
        alertController.addAction(choseCam)
        alertController.addAction(choseLibrary)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        
    }
    @objc func checkMarkTapped(){
        print(nameTextField.text)
        print(amountTextFeild.text)
        print(dateTextField.text)
        print(categoryTextFeild.text)
    }
    
    func showDatePicker(){
        //format date
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,space,doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    func showNumpad(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,space,doneButton], animated: false)
        amountTextFeild.inputAccessoryView = toolbar
    }
    
    
    
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

}

extension AddEntryViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedImage
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}

extension UITextField
{
    
    //To add bottom border only
    func setBottomBorder(withColor color: UIColor = .white)
    {
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


