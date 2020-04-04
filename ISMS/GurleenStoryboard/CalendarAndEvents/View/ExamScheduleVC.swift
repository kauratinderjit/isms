//
//  ExamScheduleVC.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/26/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ExamScheduleVC: BaseUIViewController {
    
    var viewModel     : EventScheduleViewModel?
    @IBOutlet weak var tableView: UITableView!
    var arrEventlist = [EventScheduleListResultData]()
    var selectedSubjectArrIndex : Int?
    var eventId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        setBackButton()
        self.viewModel = EventScheduleViewModel.init(delegate: self)
                  self.viewModel?.attachView(viewDelegate: self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.getData(RoleId: 0, ParticularId: 0)
    }
    

    @IBAction func actionEditEvent(_ sender: UIButton) {
        
        if arrEventlist.count>0{
                      let data = arrEventlist[(sender as AnyObject).tag]
                      selectedSubjectArrIndex = (sender as AnyObject).tag
                      eventId = data.EventId
                      let storyboard = UIStoryboard.init(name: "CalendarAndEvents", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "AddEventVC") as? AddEventVC {
                          vc.eventId = eventId ?? 0
                vc.editMode = true
                vc.editEventModel = data
                        self.navigationController?.pushViewController(vc, animated: false)
            }
                      
                  }
    }
    
    
    @IBAction func actionDeleteEvent(_ sender: UIButton) {
        
        
        if arrEventlist.count>0{
                  let data = arrEventlist[(sender as AnyObject).tag]
                  selectedSubjectArrIndex = (sender as AnyObject).tag
                  eventId = data.EventId
                  initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                  yesNoAlertView.delegate = self
                  yesNoAlertView.lblResponseDetailMessage.text = "Do you really want to delete this event?"
                  
              }
    }
    
}
extension ExamScheduleVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEventlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ExamScheduleTableViewCell
        cell?.btnDel.tag = indexPath.row
        cell?.btnEdit.tag = indexPath.row
        cell?.lblTitle.text = arrEventlist[indexPath.row].Title
        cell?.lblDate.text =  "Date : \(String(describing: arrEventlist[indexPath.row].strStartDate!))"
        cell?.lblTime.text =  "Time : \(String(describing: arrEventlist[indexPath.row].StrStartTime!))"
        cell?.imgView.addInitials(first: "E", second: "")
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
}
public extension UIImageView {
    
    func addInitials(first: String, second: String) {
        let initials = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        initials.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        initials.textAlignment = .center
        initials.text = first + " " + second
        initials.textColor = .white
        initials.backgroundColor = .random
     
        self.addSubview(initials)
   
}
}



extension ExamScheduleVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            if let SubjectId1 = self.eventId{
                self.viewModel?.deleteEvent(eventId: eventId ?? 0)
                yesNoAlertView.removeFromSuperview()
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete event id is nil")
                yesNoAlertView.removeFromSuperview()
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
            yesNoAlertView.removeFromSuperview()
        }
        yesNoAlertView.removeFromSuperview()
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}

extension ExamScheduleVC : EventScheduleDelegate {
    func SubjectEventSuccess() {
        self.viewModel?.getData(RoleId: 0, ParticularId: 0)

    }
    
    func AddEventScheduleSucceed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
  
    func EventScheduleSucceed(array: [EventScheduleListResultData]) {
        
        if array.count > 0 {
            
            arrEventlist = array
            tableView.reloadData()
        }
        
    }
    
    func EventScheduleFailour(msg: String) {
        
    }
    
    
}

extension ExamScheduleVC : ViewDelegate {
    
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
