//
//  CheckHomeworkVC.swift
//  ISMS
//
//  Created by Mohit Sharma on 4/26/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class CheckHomeworkVC: BaseUIViewController
{
    
    @IBOutlet var tableViewHomework: UITableView!
    @IBOutlet weak var txtfieldClass: UITextField!
    @IBOutlet weak var txtfieldSubject: UITextField!
    @IBOutlet weak var txtfieldExtraPicker: UITextField!
    
    var classDropdownData : [GetCommonDropdownModel.ResultData]?
    var subjectList: [GetSubjectHWResultData]?
    var uploadData = NSMutableArray()
    
    var homeWorkData = [HomeworkResultData]()
    
    var workList = [HomeworkListStudentData]()
    
    var viewModel : HomeworkViewModel?
    
    var subjectId : Int? = 0
    
    var strWhichPickerSelected : String? = ""
    var lastText: String?
    var selectedClassId : Int? = 0
    var selectedSubjectId : Int? = 0
    var selectedIndexPathForDelAttachment : Int? = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setUp()
        
        // self.viewModel = HomeworkViewModel.init(delegate: self)
        //  self.viewModel?.attachView(viewDelegate: self)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionSelectClass(_ sender: Any)
    {
        strWhichPickerSelected = "class"
        classListDropdownApi()
    }
    @IBAction func actionSelectSubject(_ sender: Any)
    {
        if checkInternetConnection()
        {
            if selectedClassId != 0
            {
                strWhichPickerSelected = "subject"
                self.viewModel?.getData(classId: selectedClassId ?? 0, teacherId: UserDefaultExtensionModel.shared.userRoleParticularId)
            }
            else
            {
                self.showAlert(Message: "Please select class first.")
            }
        }
        else
        {
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    @IBAction func actionDelNotes(_ sender: UIButton)
    {
        if uploadData.count > 0
        {
            selectedIndexPathForDelAttachment = sender.tag
            initializeCustomYesNoAlert(self.view, isHideBlurView: true)
            yesNoAlertView.delegate = self
            yesNoAlertView.lblResponseDetailMessage.text = "Do you really want to delete this attachment?"
        }
        
    }
    
    func classListDropdownApi()
    {
        if checkInternetConnection()
        {
            strWhichPickerSelected = "class"
            self.viewModel?.getClassListDropdown(selectId:UserDefaultExtensionModel.shared.userRoleParticularId, enumType: 17)
        }
        else
        {
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    
    func setUp()
    {
        setBackButton()
        self.title = "Check Homework"
        tableViewHomework.tableFooterView = UIView()
        setDatePickerView(self.view, type: .date)
        //setPickerView()
        SetpickerView(self.view)
        
        self.viewModel = HomeworkViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
    }
    
    
    //MARK:- SET UP PICKER VIEW
    func setPickerView()
    {
        //  pickerView.delegate = self as! UIPickerViewDelegate
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        //UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        //  txtfieldExtraPicker.inputView = pickerView
        txtfieldExtraPicker.inputAccessoryView = toolBar
    }
    
    
    @objc func doneClick()
    {
        
        if strWhichPickerSelected == "class"
        {
            
            if let text = txtfieldClass.text
            {
                lastText = text
                subjectList?.removeAll()
                
                if let index = classDropdownData?.index(where: { (dict) -> Bool in
                    return dict.name == text // Will found index of matched id
                })
                {
                    print("Index found :\(index)")
                    let total = classDropdownData?[index].id ?? 0
                    selectedClassId = total
                    self.viewModel?.getData(classId: total, teacherId: UserDefaultExtensionModel.shared.userRoleParticularId)
                }
            }
            txtfieldExtraPicker.resignFirstResponder()
            
        }
            
        else
        {
            if let text = txtfieldSubject.text
            {
                lastText = text
                
                if let index = subjectList?.index(where: { (dict) -> Bool in
                    return dict.Name == text // Will found index of matched id
                })
                {
                    print("Index found :\(index)")
                    let total = subjectList?[index].ClassSubjectId ?? 0
                    selectedSubjectId = total
                    subjectId = subjectList?[index].ID ?? 0
                    //self.viewModel?.getData(classId: total, teacherId: UserDefaultExtensionModel.shared.userRoleParticularId)
                }
            }
            txtfieldExtraPicker.resignFirstResponder()
            
        }
    }
    
    
    @objc func cancelClick()
    {
        
        if let text1 = lastText
        {
            txtfieldClass.text = text1
        }
        else
        {
            //  txtfieldClass.text = classDropdownData?[0].name
        }
        txtfieldExtraPicker.resignFirstResponder()
    }
    
    
}


//MARK:- Picker View Delegates
extension CheckHomeworkVC:SharedUIPickerDelegate
{
    func DoneBtnClicked()
    {
        if (txtfieldSubject.text?.count ?? 0 > 0)
        {
            //call api
            // self.viewModel?.getData(classId: selectedClassId ?? 0, teacherId: subjectId ?? 0)
            self.viewModel?.getDataOfHW(SubjectID : subjectId,ClassID : selectedClassId ?? 0,ClassSubjectID : selectedSubjectId,TeacherID : UserDefaultExtensionModel.shared.userRoleParticularId)
        }
    }
    
    func GetTitleForRow(index: Int) -> String
    {
        
        if strWhichPickerSelected == "class"
        {
            let dic = classDropdownData?[index]
            let title = dic?.name
            return "\(String(describing: title!))"
        }
        else
        {
            if let dic = subjectList?[index]
            {
                let title = dic.Name
                return "\(String(describing: title!))"
            }
            else
            {
                return ""
            }
        }
    }
    
    func SelectedRow(index: Int)
    {
        
        if strWhichPickerSelected == "class"
        {
            let dic = classDropdownData?[index]
            let title = dic?.name
            txtfieldClass.text = "\(String(describing: title!))"
        }
        else
        {
            let dic = subjectList?[index]
            let title = dic?.Name
            txtfieldSubject.text = "\(String(describing: title!))"
        }
    }
    
}



extension CheckHomeworkVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.homeWorkData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddNotesCell
        
        cell.btnDel.tag = indexPath.row
        
        
        let dic = self.homeWorkData[indexPath.row]
        cell.lblAttachment.text = dic.Topic
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //let obj = self.homeWorkData[indexPath.row]
        // let wrkid = obj.AssignHomeWorkId
        
        let vc = UIStoryboard.init(name:"Homework", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckHomeworkDetails") as! CheckHomeworkDetails
        vc.homeWorkDetails = self.homeWorkData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    
}



extension CheckHomeworkVC : AddHomeWorkDelegate
{
    func studentHomeworkDetail(data: [HomeworkListStudentData])
    {
        self.workList = data
        // tableViewHomework.reloadData()
    }
    
    func subjectList(data: [HomeworkResultHWData])
    {
        
    }
    
    func attachmentDeletedSuccessfully()
    {
        uploadData.removeObject(at: selectedIndexPathForDelAttachment ?? 0)
        tableViewHomework.reloadData()
    }
    
    func addedSuccessfully()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getSubjectList(arr: [GetSubjectHWResultData])
    {
        if arr.count > 0
        {
            //Set data when user first time come
            
            
            subjectList = arr
            selectedSubjectId = subjectList?[0].ClassSubjectId
            subjectId = subjectList?[0].ID
            txtfieldSubject.text = subjectList?[0].Name
            
            if   strWhichPickerSelected == "subject"
            {
                
                UpdatePickerModel(count: subjectList?.count ?? 0, sharedPickerDelegate: self, View: self.view)
            }
            
            
        }
        else
        {
            // self.showAlert(alert: "There is no subject")
            CommonFunctions.sharedmanagerCommon.println(object: "Count is zero.")
        }
        
    }
    
    
    func classListDidSuccess(data: GetCommonDropdownModel)
    {
        if data.resultData != nil{
            if data.resultData?.count ?? 0 > 0
            {
                //Set data when user first time come
                classDropdownData = data.resultData
                selectedClassId = classDropdownData?[0].id
                txtfieldClass.text = classDropdownData?[0].name
                UpdatePickerModel(count: data.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view)
                
                self.viewModel?.getData(classId: selectedClassId ?? 0, teacherId: UserDefaultExtensionModel.shared.userRoleParticularId)
            }
            else
            {
                self.showAlert(Message: "There is no classes")
                CommonFunctions.sharedmanagerCommon.println(object: "Count is zero.")
            }
        }
    }
    
    
    func AddHomeworkSucceed(array: [HomeworkResultData])
    {
        self.homeWorkData = array
        tableViewHomework.reloadData()
    }
    
    func AddHomeworkFailour(msg: String)
    {
        self.showAlert(Message: msg)
    }
}

extension CheckHomeworkVC : YesNoAlertViewDelegate
{
    
    func yesBtnAction()
    {
        //        if self.checkInternetConnection()
        //        {
        //            let dic = uploadData[selectedIndexPathForDelAttachment ?? 0] as? [String:Any]
        //            if dic?["id"] as? Int == 0
        //            {
        //                uploadData.removeObject(at: selectedIndexPathForDelAttachment ?? 0)
        //                tableViewHomework.reloadData()
        //            }
        //            else
        //            {
        //                self.viewModel?.deleteAttachment(assignWorkAttachmentId: dic?["id"] as? Int )
        //            }
        //            yesNoAlertView.removeFromSuperview()
        //        }
        //        else
        //        {
        //            self.showAlert(Message: Alerts.kNoInternetConnection)
        //            yesNoAlertView.removeFromSuperview()
        //        }
        
        yesNoAlertView.removeFromSuperview()
    }
    
    func noBtnAction()
    {
        yesNoAlertView.removeFromSuperview()
    }
}


extension CheckHomeworkVC : ViewDelegate
{
    
    func showAlert(alert: String)
    {
        self.showAlert(Message: alert)
    }
    
    func showLoader()
    {
        self.ShowLoader()
    }
    
    func hideLoader()
    {
        self.HideLoader()
    }
    
}
