//
//  AddExamVC.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class AddExamVC: BaseUIViewController {
    //MARK:- Variables
    var array = ["dhdsjh","dfdh"]
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var txtfieldTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtfieldStartDate: UITextField!
    @IBOutlet weak var txtfieldEndDate: UITextField!
    
    //MARK:- View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        txtfieldStartDate.addTarget(self, action: #selector(startDateAction), for: .touchUpInside)
        txtfieldEndDate.addTarget(self, action: #selector(endDateAction), for: .touchUpInside)
         SetpickerView(self.view)
        setDatePickerView(self.view, type: .date)
        
    }
    @objc func startDateAction(textField: UITextField) {
      //  UpdatePickerModel2(count:array.count , sharedPickerDelegate: self, View: self.view)
        showDatePicker(datePickerDelegate: self)
    }
    @objc func endDateAction(textField: UITextField) {
        //UpdatePickerModel2(count:array.count , sharedPickerDelegate: self, View: self.view)
        showDatePicker(datePickerDelegate: self)
    }
    @IBAction func ActionAttachFiles(_ sender: Any) {
    }
    
}
extension AddExamVC : SharedUIPickerDelegate {
    func DoneBtnClicked() {
        
    }
    
    func GetTitleForRow(index: Int) -> String {
     //   if let count = array.count{
            if array.count > 0{
                txtfieldTitle.text = array[index]
                return array[index]
            }
       // }
        return ""
    }
    
    func SelectedRow(index: Int) {
        
    }
    
    
}
extension AddExamVC: SharedUIDatePickerDelegate {
    func doneButtonClicked(datePicker: UIDatePicker) {
  
        let dateFormatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        dateFormatter.dateFormat = KConstants.kDateFormat
        //Date which you need to convert in string
        let dateString = dateFormatter.string(from: datePicker.date)
        txtfieldEndDate.text = dateString
        
        }
    
}
