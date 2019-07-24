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
    
    var imagePicker : UIImagePickerController!
    

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
    }
    override func setupUI() {
        super.setupUI()
        
        
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
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 50 * heightRatio).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300 * heightRatio).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
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
