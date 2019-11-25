//
//  SingleDayDetailViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

class SingleExpenseDetailViewController: BasicViewController {
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var nameContentLabel: UILabel!
    var amountLabel: UILabel!
    var amountContentLabel: UILabel!
    var dateLabel: UILabel!
    var dateContentLabel: UILabel!
    var categoryLabel: UILabel!
    var categoryContentLabel: UILabel!
    var backButton: UIButton!
    var editButton: UIButton!
    
    var image: UIImage?
    
    var expense: Expense?
    lazy var imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        configureLabels()
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUIColor()
    }
    private func setupUIColor() {
        if traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = .white
            nameLabel.textColor = .black
            nameContentLabel.textColor = .black
            dateLabel.textColor = .black
            dateContentLabel.textColor = .black
            categoryLabel.textColor = .black
            categoryContentLabel.textColor = .black
            amountLabel.textColor = .black
            amountContentLabel.textColor = .black
            backButton.tintColor = .black
            editButton.setTitleColor(.black, for: .normal)
        } else {
            self.view.backgroundColor = .black
            nameLabel.textColor = .white
            nameContentLabel.textColor = .white
            dateLabel.textColor = .white
            dateContentLabel.textColor = .white
            categoryLabel.textColor = .white
            categoryContentLabel.textColor = .white
            amountLabel.textColor = .white
            amountContentLabel.textColor = .white
            backButton.tintColor = .white
            editButton.setTitleColor(.white, for: .normal)
        }
    }
    private func updateViews() {
        guard let expense = expense else { return }
        nameContentLabel.text = expense.name
        amountContentLabel.text = NSString(format: "%.2f", expense.amount) as String
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateContentLabel.text = formatter.string(from: expense.date ?? Date())
        let categoryText = expense.parentCategory?.name ?? "UNCATEGORIZED"
        categoryContentLabel.text = categoryText.uppercased()
        loadImage()
        imageView.image = image
        if imageView.image == UIImage(named: "addImage") {
            imageView.contentMode = .center
        } else {
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
        
    }
    private func configureLabels() {
        let nameLabel = UILabel()
        nameLabel.text = "NAME"
        nameLabel.setUpLabelForSingleDayDetailVC()
        nameLabel.backgroundColor = .clear
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel = nameLabel
        
        let amountLabel = UILabel()
        amountLabel.text = "AMOUNT"
        amountLabel.setUpLabelForSingleDayDetailVC()
        self.amountLabel = amountLabel
        
        let dateLabel = UILabel()
        dateLabel.text = "DATE"
        dateLabel.setUpLabelForSingleDayDetailVC()
        self.dateLabel = dateLabel
        
        let categoryLabel = UILabel()
        categoryLabel.text = "CATEGORY"
        categoryLabel.setUpLabelForSingleDayDetailVC()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.categoryLabel = categoryLabel
        
        let nameContentLabel = UILabel()
        nameContentLabel.setUpLabelForSingleDayDetailVC()
        nameContentLabel.textAlignment = .center
        nameContentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameContentLabel = nameContentLabel
        
        let amountContentLabel = UILabel()
        amountContentLabel.setUpLabelForSingleDayDetailVC()
        amountContentLabel.textAlignment = .center
        self.amountContentLabel = amountContentLabel
        
        let dateContentLabel = UILabel()
        dateContentLabel.setUpLabelForSingleDayDetailVC()
        dateContentLabel.textAlignment = .center
        self.dateContentLabel = dateContentLabel
        
        let categoryContentLabel = UILabel()
        categoryContentLabel.setUpLabelForSingleDayDetailVC()
        categoryContentLabel.textAlignment = .center
        self.categoryContentLabel = categoryContentLabel
    }

    override func setupUI() {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth * heightRatio).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight * heightRatio).isActive = true
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20 * heightRatio - buttonHeight / 2).isActive = true
        button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitleColor(superLightGray, for: .highlighted)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.backButton = button
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button2)
        button2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        button2.widthAnchor.constraint(equalToConstant: buttonWidth * heightRatio).isActive = true
        button2.heightAnchor.constraint(equalToConstant: buttonHeight * heightRatio).isActive = true
        button2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20 * heightRatio - buttonHeight / 2).isActive = true
        button2.setTitle("Edit", for: .normal)
        button2.setTitleColor(superLightGray, for: .highlighted)
        button2.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        self.editButton = button2
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameContentLabel])
        nameStackView.axis = .horizontal
        nameStackView.distribution = .fillEqually
        nameStackView.alignment = .fill
        nameStackView.spacing = 16
        
        let amountStackView = UIStackView(arrangedSubviews: [amountLabel, amountContentLabel])
        amountStackView.axis = .horizontal
        amountStackView.distribution = .fillEqually
        amountStackView.alignment = .fill
        amountStackView.spacing = 16.0
        
        let dateStackView = UIStackView(arrangedSubviews: [dateLabel, dateContentLabel])
        dateStackView.axis = .horizontal
        dateStackView.distribution = .fillEqually
        dateStackView.alignment = .fill
        dateStackView.spacing = 16.0
        
        let categoryStackView = UIStackView(arrangedSubviews: [categoryLabel, categoryContentLabel])
        categoryStackView.axis = .horizontal
        categoryStackView.distribution = .fillEqually
        categoryStackView.alignment = .fill
        categoryStackView.spacing = 16.0
        
        let totalStackView = UIStackView(arrangedSubviews: [nameStackView, amountStackView, dateStackView, categoryStackView])
        totalStackView.axis = .vertical
        totalStackView.distribution = .fillEqually
        totalStackView.alignment = .fill
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //amountContentLabel.leadingAnchor.constraint(equalTo: categoryContentLabel.leadingAnchor).isActive = true
        //nameContentLabel.leadingAnchor.constraint(equalTo: categoryContentLabel.leadingAnchor).isActive = true
        //dateContentLabel.leadingAnchor.constraint(equalTo: categoryContentLabel.leadingAnchor).isActive = true
        
        self.view.addSubview(totalStackView)
        
        totalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        totalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        totalStackView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 0).isActive = true
        
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: totalStackView.bottomAnchor, constant: 30 * heightRatio).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10 * heightRatio).isActive = true
        
        imageView.isUserInteractionEnabled = true
        
        imageView.backgroundColor = superLightGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        self.imageView = imageView
        
        
        let swipeFromLeftGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipeFromLeftEdge))
        swipeFromLeftGesture.edges = .left
        self.view.addGestureRecognizer(swipeFromLeftGesture)
    }
    @objc func editButtonTapped() {
        guard let expense = expense else { return }
        let addEntryVC = AddEntryViewController()
        addEntryVC.date = expense.date
        addEntryVC.expense = expense
        addEntryVC.budgetController = budgetController
        addEntryVC.modalPresentationStyle = .fullScreen
        present(addEntryVC, animated: true)
//        if editButton.titleLabel?.text == "Edit" {
//            editButton.setTitle("Done", for: .normal)
//        } else {
//            editButton.setTitle("Edit", for: .normal)
//        }
    }
    
    @objc func imageTapped() {
        if imageView.image == UIImage(named: "addImage") {
            let alertController = UIAlertController(title: "select source", message: nil, preferredStyle: .actionSheet)
            
            let choseCam = UIAlertAction(title: "Camera", style: .default) { _ in
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true)
            }
            let choseLibrary = UIAlertAction(title: "Photo", style: .default) { _ in
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(choseCam)
            alertController.addAction(choseLibrary)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            
        } else {
            let recieptVC = ReceiptViewController()
            recieptVC.image = imageView.image
            present(recieptVC, animated: true)
        }
    }
    func loadImage() {
        guard let expense = expense else { return }
    
        if let filePathComponent = expense.imagePath {
            print(filePathComponent)
            let fm = FileManager.default
            guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            let filePath = dir.appendingPathComponent(filePathComponent).path
            
            if FileManager.default.fileExists(atPath: filePath) {
                
                image = UIImage(contentsOfFile: filePath)
            }
        } else {
            image = UIImage(named: "addImage")
        }
        
        
    }
    @objc func swipeFromLeftEdge() {
        backButtonTapped()
    }

}

extension SingleExpenseDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let expense = expense,
            let imagePath = budgetController.imageSaver.saveImage(image: userPickedImage) {
            imageView.image = userPickedImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            budgetController.updateExpense(expense: expense, imagePath: imagePath)
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}
extension UILabel {
    func setUpLabelForSingleDayDetailVC() {
        self.textColor = .black
        self.font = UIFont(name: fontName, size: 30)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.3
        //self.translatesAutoresizingMaskIntoConstraints = false
    }
}
