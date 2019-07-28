//
//  SingleDayDetailViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

class SingleDayDetailViewController: BasicViewController {
    weak var imageView : UIImageView!
    
    var image: UIImage?
    
    var expense : Expense?
    lazy var imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }

    

    override func setupUI(){
        
        loadImage()
        
        self.view.backgroundColor = .lightGray
        
        guard let expense = expense else {return}
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth * heightRatio).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight * heightRatio).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + 20 * heightRatio - buttonHeight / 2).isActive = true
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let nameLabel = UILabel()
        nameLabel.text = "NAME"
        nameLabel.setUpLabelForSingleDayDetailVC()
        nameLabel.backgroundColor = .red
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let nameContentLabel = UILabel()
        nameContentLabel.text = expense.name
        nameContentLabel.setUpLabelForSingleDayDetailVC()
        nameContentLabel.textAlignment = .center
        nameContentLabel.translatesAutoresizingMaskIntoConstraints = false
       
        
        let amountLabel = UILabel()
        amountLabel.text = "AMOUNT"
        amountLabel.setUpLabelForSingleDayDetailVC()
        
        let amountContentLabel = UILabel()
        amountContentLabel.text = NSString(format:"%.2f", expense.amount) as String
        amountContentLabel.setUpLabelForSingleDayDetailVC()
        amountContentLabel.textAlignment = .center
        
        let dateLabel = UILabel()
        dateLabel.text = "DATE"
        dateLabel.setUpLabelForSingleDayDetailVC()
        
        let dateContentLabel = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateContentLabel.text = formatter.string(from: expense.date!)
        dateContentLabel.setUpLabelForSingleDayDetailVC()
        dateContentLabel.textAlignment = .center
        
        
        
        let categoryLabel = UILabel()
        categoryLabel.text = "CATEGORY"
        categoryLabel.setUpLabelForSingleDayDetailVC()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        //categoryLabel.widthAnchor.constraint(equalToConstant: screenWidth * 3 / 10).isActive = true
        
        let categoryContentLabel = UILabel()
        categoryContentLabel.text = expense.category?.uppercased()
        categoryContentLabel.setUpLabelForSingleDayDetailVC()
        categoryContentLabel.textAlignment = .center
        
        
        
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
        
        
        imageView.image = image
        if imageView.image == UIImage(named: "addImage"){
            imageView.contentMode = .center
        }else{
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
        
        
        
        imageView.backgroundColor = .darkGray
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        self.imageView = imageView
    }
    
    @objc func imageTapped(){
        if imageView.image == UIImage(named: "addImage"){
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
            
        }else{
            let recieptVC = RecieptViewController()
            recieptVC.image = imageView.image
            present(recieptVC, animated: true)
        }
    }
    func loadImage(){
        guard let expense = expense else { return }
    
        if let filePathComponent = expense.imagePath{
            print(filePathComponent)
            let fm = FileManager.default
            guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else{return}
            
            let filePath = dir.appendingPathComponent(filePathComponent).path
            
            if FileManager.default.fileExists(atPath: filePath){
                
                image = UIImage(contentsOfFile: filePath)
            }
        }else{
            image = UIImage(named: "addImage")
        }
        
        
    }

}

extension SingleDayDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            let imagePath = saveImage(image: userPickedImage)
            expense?.imagePath = imagePath
            
            saveExpense()
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}
extension UILabel{
    func setUpLabelForSingleDayDetailVC() {
        self.textColor = .white
        self.font = UIFont(name: fontName, size: 30)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.3
        //self.translatesAutoresizingMaskIntoConstraints = false
    }
}
