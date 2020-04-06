//
//  AddEventVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/2/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit
import FSCalendar

let month_Formatter: DateFormatter =
{
    let form = DateFormatter()
    form.dateFormat = "yyyy-MM-dd"
    return form
}()

class AddEventVC: BaseUIViewController {
    
    @IBOutlet weak var calenderDate: FSCalendar!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var txtfieldTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate var str_date_selected:    String? = ""
    @IBOutlet weak var lbl_MessagePlaceholder: UILabel!
    var viewModel     : EventScheduleViewModel?
    var selectedTime : String?
    var eventId :Int = 0
    var editMode : Bool = false
    var editEventModel : EventScheduleListResultData?

    //Converts string into date
    let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    func setView() {
        
        self.viewModel = EventScheduleViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        self.title = "Add Event"
         addShadow(view: calenderDate)
         addShadow(view: txtViewDescription)
         styleTextField(textField: txtfieldTitle)
         styleLabel(textField: lblTime)
         self.CreateNavigationBackBarButton()
        
         txtfieldTitle.attributedPlaceholder = NSAttributedString(string:"Enter Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        if editMode == true {
            
            if editEventModel != nil {
                
                txtViewDescription.text = editEventModel?.Description
                lbl_MessagePlaceholder.isHidden = true
                txtfieldTitle.text = editEventModel?.Title
                
                
                let localDateFormatter = DateFormatter()
                localDateFormatter.dateFormat = "h:mm a"
                
                let localDateFormatter2 = DateFormatter()
                localDateFormatter2.dateFormat = "HH:mm"
                
                let dateObj = localDateFormatter2.date(from: editEventModel?.StrStartTime ?? "")
                print("\(localDateFormatter.string(from: dateObj!))")
                lblTime.text = "\(localDateFormatter.string(from: dateObj!))"
                 
                selectedTime = editEventModel?.StrStartTime
                guard let strDate = editEventModel?.strStartDate else { return  }
                str_date_selected = strDate
                let dateFinal =  formatter.date(from: strDate)
                self.calenderDate.deselect(dateFinal!)
                self.calenderDate.select(dateFinal, scrollToDate: true)
                
            }
        }
         
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         editMode = false
    }
    
    private func styleTextField(textField: UITextField){
        textField.borderStyle = .none
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 5.0;
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowOpacity = 0.4
        textField.layer.shadowRadius = 5.0
    }
    
    private func styleLabel(textField: UILabel){
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 5.0;
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowOpacity = 0.4
        textField.layer.shadowRadius = 5.0
    }

    
    func CreateNavigationBackBarButton()
    {
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"backIcon"), for: UIControl.State())
        myBackButton.addTarget(self, action: #selector(self.PopToRootViewController), for: UIControl.Event.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
    }
    
    
    @objc  func PopToRootViewController()
     {
         _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           DispatchQueue.main.async{
              self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 800) }
    }
    
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
     print(scrollView.contentOffset.y)
     print(scrollView.contentOffset.x)

 }
 
    
    @IBAction func actionbtnDone(_ sender: UIButton) {
        
        if self.lblTime.text != "" {
                
                DispatchQueue.main.async {
                    self.viewPicker.isHidden = true
                    self.calenderDate.isUserInteractionEnabled = true
                    self.pickerTime.minimumDate = nil

                }
            }
    }
    
    @IBAction func btnSelectDate(_ sender: UIButton) {
        
        DispatchQueue.main.async{
             self.calenderDate.isUserInteractionEnabled = false
             self.view.endEditing(true)
              self.viewPicker.isHidden = false
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "h:mm a"
              let dateFormatter1 = DateFormatter()
              dateFormatter1.dateFormat = "HH:mm"
              
              let date_ = dateFormatter.string(from: self.pickerTime.date)
              print(date_)
              self.lblTime.text = "\(date_)"
            self.selectedTime = "\(dateFormatter1.string(from: self.pickerTime.date))"
          }
    }
    
    
    @IBAction func actionTimePicker(_ sender: UIDatePicker) {
        
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            let tody_date = Date()
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "HH:mm"
            
            //date format
            let str_tody_Date = month_Formatter.string(from: tody_date)
            print(str_tody_Date)
            
            //Time Format
            let str_tody_time = dateFormatter.string(from: tody_date)
            print(str_tody_time)
            
            let picker_selected_time = dateFormatter.string(from: sender.date)
            //********
            
            //Selected date from Picker
            print(self.str_date_selected)
            
            if self.str_date_selected == str_tody_Date {
                
                
                let dateString = self.str_date_selected! + " " + picker_selected_time
                
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "yyyy-MM-dd hh:mm a"
                
                let dateObj = dateFormatter2.date(from: dateString)
                
                
                dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                
                    print("\(dateFormatter2.string(from: dateObj!))")
                
                let str_new = dateFormatter2.string(from: dateObj!)
             
                
                let date_new = dateFormatter2.date(from: str_new)
                print(date_new)
                let currentDate = Date()
                print(currentDate)
                
                let dateComparisionResult: ComparisonResult = date_new!.compare(currentDate)
                
                
                if dateComparisionResult == ComparisonResult.orderedAscending
                {
                    
                    print("smaller")
                    self.pickerTime.minimumDate = Date()
                    self.showAlert(Message: "Please select future time")
                    let date_ = dateFormatter.string(from: Date())
                    print(date_)
                    self.lblTime.text = "\(date_)"
                  //  self.str_time =  self.lblTime.text
                    selectedTime = "\(dateFormatter1.string(from: Date()))"
                    
                }
                    
                else if dateComparisionResult == ComparisonResult.orderedDescending
                {
                    
                    print("greater")
                    
                    //********
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    
                    let date_ = dateFormatter.string(from: sender.date)
                    print(date_)
                    lblTime.text = "\(date_)"
                    //str_time =  lblTime.text
                    self.pickerTime.minimumDate = nil
                    selectedTime = "\(dateFormatter1.string(from: sender.date))"
                    //**********

                }
                else if dateComparisionResult == ComparisonResult.orderedSame
                {
                    
                    //********
                    let date_ = dateFormatter.string(from: sender.date)
                    print(date_)
                    lblTime.text = "\(date_)"
                    //str_time =  lblTime.text
                    self.pickerTime.minimumDate = nil
                    selectedTime = "\(dateFormatter1.string(from: sender.date))"

                    //*********
                }
       
        }
            
            else {
                let date_ = dateFormatter.string(from: sender.date)
                print(date_)
                lblTime.text = "\(date_)"
               // str_time =  lblTime.text
                self.pickerTime.minimumDate = nil
                selectedTime = "\(dateFormatter1.string(from: sender.date))"

            }
            
        
    }
    
    
    @IBAction func actionSendBtn(_ sender: UIBarButtonItem) {
         if checkInternetConnection(){
            
            self.viewModel?.addUpdateEvent(eventId: eventId, title: txtfieldTitle.text, description: txtViewDescription.text, time: selectedTime, Date: str_date_selected)
            
        }
         else{
             self.showAlert(alert: Alerts.kNoInternetConnection)
         }
        
    }
    
    

}

extension AddEventVC:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lbl_MessagePlaceholder.isHidden = true
        self.viewPicker.isHidden = true
         self.animateTextView(textView: textView, up: true, movementDistance: 250, scrollView:self.scrollView)
     
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let str = textView.text.trimmingCharacters(in: .whitespaces)
        
        if str == ""
        {
            self.txtViewDescription.text = ""
            lbl_MessagePlaceholder.isHidden = false
            
        }
        else{
            txtViewDescription.text = textView.text
        }
        
            DispatchQueue.main.async {
                
                self.animateTextView(textView: textView, up: false, movementDistance: 250, scrollView:self.scrollView)
            }
        
    }
    
}
extension AddEventVC:FSCalendarDelegate,FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
         if date < calendar.today!
                {
                    calenderDate.deselect(date)
                    self.showAlert(Message: "Please select future date.")
                    return
                }
        
                else{
                    if date == calendar.today!
                    {
                    lblTime.text = "00:00"
                    //str_time =  ""
                    self.pickerTime.minimumDate = nil
                    }
                    str_date_selected = (self.formatter.string(from: date))
                    print(str_date_selected)
                }
    }
    
    
    //Called when available date is selected
//    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
//
//
//        if date < calendar.today!
//        {
//            calenderDate.deselect(date)
//            self.showAlert(Message: "Please select future date.")
//            return
//        }
//
//        else{
//            if date == calendar.today!
//            {
//            lblTime.text = "00:00"
//            //str_time =  ""
//            self.pickerTime.minimumDate = nil
//            }
//            str_date_selected = (self.formatter.string(from: date))
//            print(str_date_selected)
//        }
//
//    }
   
    //calendarCurrentPageDidChange
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
     
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        if date == calenderDate.today
        {
            return "Today"
        }
        else{
            return nil
        }
    }
    
}

extension AddEventVC : EventScheduleDelegate {
    func SubjectEventSuccess() {
        
    }
    
    func AddEventScheduleSucceed() {
        
        if editMode == true {
            self.showAlert(alert: "Event updated successfully.")

        }
        else {
            self.showAlert(alert: "Event added successfully.")

        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func EventScheduleSucceed(array: [EventScheduleListResultData]) {
        
    }
    
    func EventScheduleFailour(msg: String) {
        
    }
    
    
}

extension AddEventVC : ViewDelegate {
    
    func showAlert(alert: String) {
        print("your error : \(alert)")
        self.showAlert(Message: alert)
    }
    
    func showLoader() {
         ShowLoader()
    }
    
    func hideLoader() {
       HideLoader()
    }
    
}
