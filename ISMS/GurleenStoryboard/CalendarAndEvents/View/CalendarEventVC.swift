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
    @IBOutlet var lblInfo: UILabel!
    
    var datesRange = [[String:Any]]()
    var datesRangeDATE = [String]()
    
    
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
            
            let dd = dateFormatter2.string(from: strtdate)
            let obj = ["date":dd,"desc":descpn] as [String : Any]
            
            datesRangeDATE.append(dd)
            datesRange.append(obj)
            calendar.select(strtdate)
            
            strtdate = Calendar.current.date(byAdding: .day, value: 1, to: strtdate)!
        }
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.reloadData()
    }
    
    
    func get_event_Info_fromDate(sDate:String) -> String
    {
        if(datesRange.count > 0)
        {
            for obj in datesRange
            {
                let stDate = obj["date"]as? String ?? "N/A"
                let desc = obj["desc"] as? String ?? "N/A"
                
                if sDate == stDate
                {
                    return desc
                }
            }
            
            return "N/A"
        }
        
        return "N/A"
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        calendar.deselect(date)
        let key = self.dateFormatter2.string(from: date)
        let info = get_event_Info_fromDate(sDate:key)
        self.lblInfo.text = "Event: \(info)"
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        calendar.select(date)
        
        let key = self.dateFormatter2.string(from: date)
        self.lblSelectedDate.text = key
        
        self.viewInfo.isHidden = false
        self.viewStack.isHidden = false
        
        let info = get_event_Info_fromDate(sDate:key)
        self.lblInfo.text = "Event: \(info)"
        
        
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date
    {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor?
    {
        
        let cDate = dateFormatter2.string(from: date)
       // let cDate2 = dateFormatter2.date(from: cDate) ?? Date()
        
        
        if (datesRangeDATE.contains(cDate))
        {
           // calendar.select(date)
            return UIColor.blue
        }
        
        return appearance.selectionColor
    }
    
    
    
    
}
