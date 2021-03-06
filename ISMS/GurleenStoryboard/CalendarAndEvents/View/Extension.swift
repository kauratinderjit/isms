//
//  Extension.swift
//  ISMS
//
//  Created by Mohit Sharma on 4/23/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit

extension AddEventVC
{
    //MARK: DATE PICKER HANDLING
    func showDatePickerEventDate()
    {
        //Formate Date
        self.datePickerStartDate = UIDatePicker()
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
       // let maxDate = calendar.date(byAdding: components, to: currentDate)!
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        datePickerStartDate.minimumDate = minDate
       // datePicker.maximumDate = maxDate
        
        self.datePickerStartDate.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePickerDate));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        self.tfEventDate.inputAccessoryView = toolbar
        self.tfEventDate.inputView = datePickerStartDate
        
    }
    
    func showDatePickerEventDateEnd()
    {
        //Formate Date
        self.datePickerEndDate = UIDatePicker()
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
       // let maxDate = calendar.date(byAdding: components, to: currentDate)!
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        datePickerEndDate.minimumDate = minDate
       // datePicker.maximumDate = maxDate
        
        self.datePickerEndDate.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePickerDateEnd));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        self.tfEventEndDate.inputAccessoryView = toolbar
        self.tfEventEndDate.inputView = datePickerEndDate
        
    }
    
    func showDatePickerEventStartTime()
    {
        //Formate Date
        self.datePickerStartTime = UIDatePicker()
        self.datePickerStartTime.datePickerMode = .time
        
        if (self.selectedStrtDate == self.selectedStrtDate2)
        {
            self.datePickerStartTime.minimumDate = Date()
        }
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePickerStartTime));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        self.tfStartTime.inputAccessoryView = toolbar
        self.tfStartTime.inputView = datePickerStartTime
        
    }
    
    func showDatePickerEventEndTime()
    {
        //Formate Date
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .time
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePickerEndTime));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        self.tfEndTime.inputAccessoryView = toolbar
        self.tfEndTime.inputView = datePicker
        
    }
    
    
    @objc func donedatePickerDate()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.tfEventDate.text = formatter.string(from: datePickerStartDate.date)
        self.selectedStrtDate = self.tfEventDate.text!
        self.showDatePickerEventStartTime()
        self.view.endEditing(true)
    }
    @objc func donedatePickerDateEnd()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.tfEventEndDate.text = formatter.string(from: datePickerEndDate.date)
        self.view.endEditing(true)
    }

    @objc func donedatePickerStartTime()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        self.startTimes = formatter.string(from: datePickerStartTime.date)
        formatter.dateFormat = "hh:mm a"
        self.tfStartTime.text = formatter.string(from: datePickerStartTime.date)
        startTime = formatter.date(from: self.tfStartTime.text ?? "") ?? Date()
        self.view.endEditing(true)
    }
    @objc func donedatePickerEndTime()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        self.endTimes = formatter.string(from: datePicker.date)
         formatter.dateFormat = "hh:mm a"
        self.tfEndTime.text = formatter.string(from: datePicker.date)
        endTime = formatter.date(from: self.tfEndTime.text ?? "") ?? Date()
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    
    
    
    func getTime_DIfference_isCorrect() -> Bool
    {
        
        if (endTime == nil || startTime == nil)
        {
             startTime = formatter.date(from: self.tfStartTime.text ?? "") ?? Date()
             endTime = formatter.date(from: self.tfEndTime.text ?? "") ?? Date()
        }
        
        if (self.tfEventDate.text == self.tfEventEndDate.text)
        {
            let val = getDateDiff(start: startTime ?? Date(), end: endTime ?? Date())
            
            if (val >= 1)
            {
                return true
            }
            else
            {
               self.showAlert(alert: "The minimum event duration should be 1 hour for same dates!")
               return false
            }
        }
        else
        {
            return true
        }
    }
    
    func getDateDiff(start: Date, end: Date) -> Int
    {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.hour], from: start, to: end)

        let seconds = Int(dateComponents.hour ?? 0)
        return seconds
    }
    
    
}
