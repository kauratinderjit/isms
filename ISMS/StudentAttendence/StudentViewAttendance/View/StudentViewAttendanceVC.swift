//
//  StudentViewAttendanceVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 15/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentViewAttendanceVC: BaseUIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStudentName: UILabel!
    
    var isSelectStartDate = false
    var isSeclectEndDate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePickerView(self.view, type: .date)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnPickerEndDate(_ sender: Any) {
        isSelectStartDate = false
        isSeclectEndDate = true
        showDatePicker(datePickerDelegate: self)
    }
    
    @IBAction func btnPickerStartDate(_ sender: Any) {
        isSelectStartDate = true
        isSeclectEndDate = false
        showDatePicker(datePickerDelegate: self)
    }
    
}
extension StudentViewAttendanceVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension;//Choose your custom row height
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //        return 100;//Choose your custom row height
    //    }
    
}
extension StudentViewAttendanceVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if arrGetTeacherRating.count > 0{
//            tableView.separatorStyle = .singleLine
//            return (arrGetTeacherRating.count)
//        }else{
//            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
//            return 0
//        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ViewStudentAttendanceCell
        //
        cell.lblPresntAbsent.text = "Present"
        cell.lblDate.text = "2020-4-14"
//        cell.setCellUI(data: arrGetTeacherRating, indexPath: indexPath)
        return cell
    }
}
extension StudentViewAttendanceVC:SharedUIDatePickerDelegate{
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        //yearofestablishment
        let dateFormatter       = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        if isSelectStartDate == true{
             lblStartDate.text = strDate
        }else{
            lblEndDate.text = strDate
        }
       
    }
}
