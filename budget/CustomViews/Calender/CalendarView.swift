//
//  CalendarView.swift
//  budget
//
//  Created by Bradley Yin on 7/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

protocol CalendarDelegate: AnyObject {
    func goToSingleDay(date: Date)
}

class CalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    
    var numOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    
    weak var delegate: CalendarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex - 1] = 29
        }
        //end
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        
        setupViews()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex - 1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                            for: indexPath) as? DateCollectionViewCell else { fatalError("cant make DateCollectionViewCell") }
        cell.backgroundColor = .clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row - firstWeekDayOfMonth + 2
            cell.isHidden = false
            cell.lbl.text = "\(calcDate)"
            
           
            cell.isUserInteractionEnabled = true
            cell.lbl.textColor = .black
        }
//        if cell.lbl.text == "\(todaysDate)" && currentMonthIndex == Calendar.current.component(.month, from: Date()) {
//            cell.isToday = true
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell else { return }

        let lbl = cell.lbl
 
        let day = lbl.text ?? "01"
        if let date = "\(currentYear)-\(currentMonthIndex)-\(day)".date {
            delegate?.goToSingleDay(date: date)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7 - 8
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        print(day)
        return day
    }
    func goToToday() {
        monthView.gotoThisMonth()
        let day = Calendar.current.component(.day, from: Date())
        myCollectionView.selectItem(at: IndexPath(item: day - 1 + firstWeekDayOfMonth - 1, section: 0), animated: true, scrollPosition: .top)
        
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex + 1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        myCollectionView.reloadData()
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        monthView.delegate = self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive = true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive = true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        let totalNumberOfCells = numOfDaysInMonth[currentMonthIndex - 1] + firstWeekDayOfMonth - 1
        print("total cells", totalNumberOfCells)
        let totalRows = (Double(totalNumberOfCells) / 7.0).rounded(.up)
        print("total row", totalRows)
        myCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(totalRows * 60)).isActive = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goToLastMonth))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goToNextMonth))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
    }
    @objc func goToLastMonth() {
        monthView.goToLastMonth()
    }
    @objc func goToNextMonth() {
        monthView.goToNextMonth()
    }
    
    let monthView: MonthView = {
        let v = MonthView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v = WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.backgroundColor = UIColor.clear
        myCollectionView.allowsMultipleSelection = false
        return myCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
