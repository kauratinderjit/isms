//
//  PTMScheduleVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class PTMScheduleVC: BaseUIViewController {

    
    @IBOutlet weak var txtFieldEndTime: UITextField!
    @IBOutlet weak var txtFieldStartTime: UITextField!
    @IBOutlet weak var txtFieldStartDate: UITextField!
    @IBOutlet weak var txtFieldEndDate: UITextField!
    
    var startBtn : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
   setDatePickerView(self.view, type: .date)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnstartDate(_ sender: Any) {
        startBtn = 0
         showDatePicker(datePickerDelegate: self)
    }
    
    @IBAction func btnEndDate(_ sender: Any) {
        startBtn = 1
         showDatePicker(datePickerDelegate: self)
    }
    
    @IBAction func btnStartTime(_ sender: Any) {
    }
    
    
    
}
extension PTMScheduleVC: SharedUIDatePickerDelegate {
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateString = dateFormatter.string(from: datePicker.date)
        print("our date: ",dateString)
        if startBtn == 0{
             txtFieldStartDate.text = dateString
        }else{
            txtFieldEndDate.text = dateString
        }
    }
}
