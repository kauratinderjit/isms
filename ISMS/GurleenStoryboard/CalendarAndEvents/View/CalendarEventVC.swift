//
//  CalendarEventVC.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/26/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarEventVC: BaseUIViewController
{
    
    @IBOutlet var viewStack: UIStackView!
    @IBOutlet var viewInfo: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var lblSelectedDate: UILabel!
    
    var datesRange = [[String:Any]]()
    var datesRangeDATE = [Date]()
    
    
    fileprivate lazy var dateFormatter2: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.calendar.allowsSelection = true
        self.calendar.allowsMultipleSelection = true
        
        setBackButton()
        
        self.viewInfo.isHidden = true
        self.viewStack.isHidden = true
        
        //   self.calendar.minimumDate = Date()
        
        fetchDates()
    }
    
    
    func fetchDates()
    {
        if(arrEventlistGlobal.count > 0)
        {
            for obj in arrEventlistGlobal
            {
                let stDate = obj.StartDate ?? ""
                let edDate = obj.EndDate ?? ""
                
                self.get_all_Dates_from_startToEndDate(strtDate: stDate, endDate: edDate, descpn: obj.Description ?? "")
            }
        }
    }
    
    func get_all_Dates_from_startToEndDate(strtDate:String,endDate:String,descpn:String)
    {
        var strtdate = self.stringToDate(strDate:strtDate) // first date
        let enddate = self.stringToDate(strDate:endDate) // last date
        
        // Formatter for printing the date, adjust it according to your needs:
        
        
        while strtdate <= enddate
        {
            print(dateFormatter2.string(from: strtdate))
            strtdate = Calendar.current.date(byAdding: .day, value: 1, to: strtdate)!
            
            let obj = ["date":strtdate,"desc":descpn] as [String : Any]
            
            datesRangeDATE.append(strtdate)
            datesRange.append(obj)
            calendar.select(strtdate)
        }
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.reloadData()
    }
    
    
    func stringToDate(strDate:String) -> Date
    {
        //2020-05-23T00:00:0
        let dateFormatter = DateFormatter()
        //  dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:s"
        let date = dateFormatter.date(from:strDate)!
        return date
        
    }
    
}
extension CalendarEventVC : FSCalendarDataSource , FSCalendarDelegate , FSCalendarDelegateAppearance
{
    //    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    //        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
    //        cell.titleLabel.backgroundColor = UIColor.black
    //        return cell
    //    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor?
    {
        return UIColor.clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor?
    {
        return UIColor.black
    }
    
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
//    {
//        let key = self.dateFormatter2.string(from: date)
//        self.lblSelectedDate.text = key
//
//        self.viewInfo.isHidden = false
//        self.viewStack.isHidden = false
//
//        calendar.deselect(date)
//       // self.calendar.reloadData()
//    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        calendar.select(date)
      //  self.calendar.reloadData()
        
        let key = self.dateFormatter2.string(from: date)
        self.lblSelectedDate.text = key
        
        self.viewInfo.isHidden = false
        self.viewStack.isHidden = false
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date
    {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor?
    {
        if (datesRangeDATE.contains(date))
        {
           // calendar.select(date)
            return UIColor.blue
        }
        
        return appearance.selectionColor
    }
    
    
    
    
}
