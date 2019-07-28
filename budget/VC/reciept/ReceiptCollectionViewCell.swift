//
//  ReceiptCollectionViewCell.swift
//  budget
//
//  Created by Bradley Yin on 7/28/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

protocol ReceiptCollectionDelegate {
    func receiptTapped(image: UIImage)
}

class ReceiptCollectionViewCell: UICollectionViewCell {
    weak var imageView : UIImageView!
    
    var delegate : ReceiptCollectionDelegate?
    
    var imagePath: String?{
        didSet{
            updateViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews() {
        self.backgroundColor = .clear
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        imageView.backgroundColor = .darkGray
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tap)
        self.imageView = imageView
        
    }
    
    func updateViews(){
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        if let imagePath = imagePath{
            let filePath = dir.appendingPathComponent(imagePath).path
            imageView.image = UIImage(contentsOfFile: filePath)
        }
    }
    @objc func imageTapped(){
        if let image = imageView.image{
            delegate?.receiptTapped(image: image)
        }
       
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
