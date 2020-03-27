//
//  CalendarEventVC.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/26/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarEventVC: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var lblSelectedDate: UILabel!
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MM-yyyy"
           return formatter
       }()
    override func viewDidLoad() {
        super.viewDidLoad()
//calendar.appearance
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
extension CalendarEventVC : FSCalendarDataSource , FSCalendarDelegate , FSCalendarDelegateAppearance{
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
//        cell.titleLabel.backgroundColor = UIColor.black
//        return cell
//    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return UIColor.red
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return UIColor.white
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
     let key = self.dateFormatter2.string(from: date)
          self.lblSelectedDate.text = key

    }
}
