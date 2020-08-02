////
////  RecieptAlbumTableViewCell.swift
////  budget
////
////  Created by Bradley Yin on 7/27/19.
////  Copyright © 2019 bradleyyin. All rights reserved.
////
//
//import UIKit
//
//class ReceiptAlbumTableViewCell: UITableViewCell {
//    weak var monthLabel : UILabel!
//    weak var receiptCollectionView : UICollectionView!
//    
//    var delegate: ReceiptCollectionDelegate?
//
//
//    var expenses : [Expense] = [] {
//        didSet{
//          updateViews()
//        }
//    }
//    
//    var monthString = ""
//
//    var fontSize : CGFloat = 25 * heightRatio
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setUpViews()
//    }
//
//    func setUpViews(){
//        self.backgroundColor = .clear
//
//        let titleLabel = UILabel()
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.textColor = .black
//        titleLabel.font = UIFont(name: fontName, size: fontSize)
//        titleLabel.textAlignment = .left
//        self.addSubview(titleLabel)
//        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
//        self.monthLabel = titleLabel
//        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: 200 * heightRatio, height: 200 * heightRatio)
//        layout.scrollDirection = .horizontal
//
//        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(collectionView)
//        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
//        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
//        collectionView.register(ReceiptCollectionViewCell.self, forCellWithReuseIdentifier: "ReceiptCell")
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.backgroundColor = .clear
//        collectionView.showsHorizontalScrollIndicator = true
//        
//
//    }
//    func updateViews() {
//        print(monthString)
//        monthLabel.text = monthString
//        //receiptCollectionView.reloadData()
//    }
//   
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//
//}
//extension ReceiptAlbumTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return expenses.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiptCell", for: indexPath) as? ReceiptCollectionViewCell else { fatalError("cant make ReceiptCollectionViewCell")}
//        cell.backgroundColor = .clear
//        cell.imagePath = expenses[indexPath.row].imagePath
//        cell.delegate = delegate
//        return cell
//    }
//    
//    
//}
//
