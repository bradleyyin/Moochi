//
//  RecietAlbumViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//TODO: - figure out a better way to load data when we have a lot, dont load all at once


class ReceiptAlbumViewController : BasicViewController {
    
    weak var recieptTableView: UITableView!
    
    var expenses: [Expense] = []
    
    var sortedExpenses: [String : [Expense]] = [:]
    
    var monthArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleOfVC = "RECEIPT ALBUM"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadExpenses()
        sortExpenses()
        print(sortedExpenses)
        recieptTableView.reloadData()
        
    }
    func setupUI() {
        self.view.backgroundColor = .white
        
        let titleLabel = TitleLabel()
        
        titleLabel.text = titleOfVC.uppercased()
        self.view.addSubview(titleLabel)
        //titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        //titleLabel.heightAnchor.constraint(equalToConstant: 100 * heightRatio).isActive=true

        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.register(ReceiptAlbumTableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        self.recieptTableView = tableView
    }
    func updateViews() {
        
    }
    func loadExpenses() {
        let context = CoreDataStack.shared.mainContext
        
        let request : NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            expenses = try context.fetch(request)
        }catch{
            print("error loading income")
        }
    }
    func sortExpenses(){
    
        
        for expense in expenses{
            let date = expense.date!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yyyy"
            let dateString = dateFormatter.string(from: date)
            if sortedExpenses[dateString] != nil{
                sortedExpenses[dateString]?.append(expense)
            }else {
                sortedExpenses[dateString] = [expense]
                monthArray.append(dateString)
            }
        }
        monthArray.sort {$0.localizedStandardCompare($1) == .orderedDescending}
    }
    
    
}
extension ReceiptAlbumViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as? ReceiptAlbumTableViewCell else { return UITableViewCell() }
        let monthString = monthArray[indexPath.row]
        cell.monthString = monthString
        let filteredExpenses = sortedExpenses[monthString]!.filter({$0.imagePath != nil})
        cell.expenses = filteredExpenses
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300 * heightRatio
    }
    
    
}
extension ReceiptAlbumViewController : ReceiptCollectionDelegate{
    func receiptTapped(image: UIImage) {
        let receiptVC = ReceiptViewController()
        receiptVC.image = image
        present(receiptVC, animated:  true)
    }
}
