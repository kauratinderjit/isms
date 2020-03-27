//
//  ManageEventsVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 11/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import FSCalendar

class ManageEventsVC: UIViewController {
    
    //MARK:- Outlet and variables
    @IBOutlet weak var viewCalendar: FSCalendar!
    
    var arrayOfEvent1 : [String] = ["2019-11-19","2019-11-20"]
    var arrayOfEvent2 : [String] = ["2019-11-30","2019-12-01"]
    //MARK: - set formatter of date
        fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter }()
    
    //MARK:- lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- lifecycle Methods
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    //MARK:- Actions
    @IBAction func btnAddAction(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK:- FSCa
extension ManageEventsVC: FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance
{
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
//        return UIColor.blue
//    }
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        return UIColor.white
//    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let strDate = formatter.string(from: date)
        if arrayOfEvent1.contains(strDate) && arrayOfEvent2.contains(strDate)
        {
          showAlert(Message: "Holiday")
            print("Event 1&2")
        }
        else if arrayOfEvent1.contains(strDate)
        {
            showAlert(Message: "Exam Result")
        }
        else if arrayOfEvent2.contains(strDate)
        {
            showAlert(Message: "Annual Party")
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
//        let strDate = self.formatter.string(from:date)
//        if arrayOfEvent1.contains(strDate) && arrayOfEvent2.contains(strDate)
//        {
//            return 2
//        }
//        else if arrayOfEvent1.contains(strDate)
//        {
//            return 1
//        }
//        else if arrayOfEvent2.contains(strDate)
//        {
//            return 1
//        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor?
    {
        return UIColor.red
    }
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
     
        let strDate = formatter.string(from: date)
        if arrayOfEvent1.contains(strDate) && arrayOfEvent2.contains(strDate)
        {
           return "Result"
        }
        else if arrayOfEvent1.contains(strDate)
        {
           return "Holiday"
        }
        else if arrayOfEvent2.contains(strDate)
        {
           return "Annual Party"
        }
        return ""
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance,eventDefaultColorsFor date: Date) -> [UIColor]?
    {
        let strDate = formatter.string(from: date)
        if arrayOfEvent1.contains(strDate) && arrayOfEvent2.contains(strDate)
        {
            return [UIColor.red ,UIColor.green]
        }
        else if arrayOfEvent1.contains(strDate)
        {
            return [UIColor.red]
        }
        else if arrayOfEvent2.contains(strDate)
        {
            return [UIColor.green]
        }
        return [UIColor.clear]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let strDate = formatter.string(from: date)
        if arrayOfEvent1.contains(strDate) && arrayOfEvent2.contains(strDate)
        {
            return [UIColor.red ,UIColor.green]
        }
        else if arrayOfEvent1.contains(strDate)
        {
            return [UIColor.red]
        }
        else if arrayOfEvent2.contains(strDate)
        {
            return [UIColor.green]
        }
        return [UIColor.clear]
    }
}
