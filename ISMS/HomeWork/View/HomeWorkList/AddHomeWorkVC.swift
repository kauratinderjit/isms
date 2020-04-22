//
//  AddHomeWorkVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/7/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddHomeWorkVC: BaseUIViewController {
    
    
    @IBOutlet weak var txtfieldExtraPicker: UITextField!
    @IBOutlet weak var txtfieldSubmissionDate: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnAddNote: UIButton!
    @IBOutlet weak var txtfieldClass: UITextField!
    @IBOutlet weak var txtfieldSubject: UITextField!
    @IBOutlet weak var txtfieldTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var tblView: UITableView!
    var viewModel : HomeworkViewModel?
    var lastText: String?
    var classDropdownData : [GetCommonDropdownModel.ResultData]?
    var selectedClassId : Int? = 0
    var selectedSubjectId : Int? = 0
    var strWhichPickerSelected : String? = ""
    var subjectList: [GetSubjectHWResultData]?
    var dictionaries = [[String:Any]]()
    var arrayAttachmentsToShow = [AttachedFiles]()
    var uploadData = NSMutableArray()
    @IBOutlet weak var lblPlaceHolder: UILabel!
    var AssignHomeWorkId : Int? = 0
     var subjectId : Int? = 0
    var attachmentId : Int? = 0
    var selectedIndexPathForDelAttachment : Int? = 0
    var editableHomeWorkData : HomeworkResultData?
    @IBOutlet weak var heightTblView: NSLayoutConstraint!
    @IBOutlet weak var btnAdd: UIButton!
    
    let formatter: DateFormatter = {
              let formatter = DateFormatter()
              formatter.dateFormat = "dd/MM/yyyy"
              return formatter
      }()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        if editableHomeWorkData != nil  {
           
            self.title = "Update Homework"
            heightTblView.constant =  CGFloat((editableHomeWorkData?.lstattachmentModels?.count ?? 0) * 51)
            txtfieldTitle.text = editableHomeWorkData?.Topic
            txtViewDescription.text = editableHomeWorkData?.Details
            guard let dateFinal =  dateFormatter.date(from: editableHomeWorkData?.SubmssionDate ?? "") else {
                print("Condition is not true ")
                return
            }
            let dd = formatter.string(from: dateFinal)
            txtfieldSubmissionDate.text = dd
            btnAdd.setTitle("UPDATE", for: .normal)
            lblPlaceHolder.isHidden = true
            txtfieldClass.text = editableHomeWorkData?.ClassName
            txtfieldSubject.text = editableHomeWorkData?.SubjectName
            AssignHomeWorkId = editableHomeWorkData?.AssignHomeWorkId
            selectedClassId = editableHomeWorkData?.ClassId
            subjectId = editableHomeWorkData?.SubjectId
            selectedSubjectId = editableHomeWorkData?.ClassSubjectId
            
            if editableHomeWorkData?.lstattachmentModels?.count ?? 0 > 0 {
                
                for (index, element) in (editableHomeWorkData?.lstattachmentModels?.enumerated())! {
                  print("Item \(index): \(element)")
                  
                var modelHW = [String: Any]()
                                     modelHW["url"] = nil
                                     modelHW["fileName"] = element.FileName
                                     modelHW["id"] = element.AssignWorkAttachmentId
                                     uploadData.add(modelHW)
                }
                
            }
            

        }
    }
    
    func setUp() {
        self.title = "Add Homework"
        tblView.tableFooterView = UIView()
        setDatePickerView(self.view, type: .date)
         //setPickerView()
        SetpickerView(self.view)

        self.viewModel = HomeworkViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        heightTblView.constant = 0
    }
    
    func classListDropdownApi() {
        if checkInternetConnection(){
            strWhichPickerSelected = "class"
           self.viewModel?.getClassListDropdown(selectId:UserDefaultExtensionModel.shared.userRoleParticularId, enumType: 17)
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    //MARK:- SET UP PICKER VIEW
      func setPickerView(){
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
      @objc func doneClick() {
        
        if strWhichPickerSelected == "class" {
        
          if let text = txtfieldClass.text {
                lastText = text
                subjectList?.removeAll()
                  
                  if let index = classDropdownData?.index(where: { (dict) -> Bool in
                      return dict.name == text // Will found index of matched id
                  }) {
                      print("Index found :\(index)")
                      let total = classDropdownData?[index].id ?? 0
                    selectedClassId = total
                    self.viewModel?.getData(classId: total, teacherId: UserDefaultExtensionModel.shared.userRoleParticularId)
                  }
          }
          txtfieldExtraPicker.resignFirstResponder()
            
        }
        
        else {
            if let text = txtfieldSubject.text {
                           lastText = text
                             
                             if let index = subjectList?.index(where: { (dict) -> Bool in
                                 return dict.Name == text // Will found index of matched id
                             }) {
                                 print("Index found :\(index)")
                                 let total = subjectList?[index].ClassSubjectId ?? 0
                                selectedSubjectId = total
                                 subjectId = subjectList?[index].ID ?? 0
                              // self.viewModel?.getData(classId: total, teacherId: UserDefaultExtensionModel.shared.userRoleParticularId)
                             }
                     }
                     txtfieldExtraPicker.resignFirstResponder()
            
        }
      }
    
    
      @objc func cancelClick() {
          
          if let text1 = lastText {
            txtfieldClass.text = text1
              }
          else  {
            //  txtfieldClass.text = classDropdownData?[0].name
          }
          txtfieldExtraPicker.resignFirstResponder()
          
      }
    
    
    @IBAction func actionSelectClass(_ sender: UIButton) {
        strWhichPickerSelected = "class"
        classListDropdownApi()
    }
    
    
    
    @IBAction func actionSelectSubjet(_ sender: UIButton) {
        
        if checkInternetConnection(){
            if selectedClassId != 0 {
            strWhichPickerSelected = "subject"
            self.viewModel?.getData(classId: selectedClassId ?? 0, teacherId: UserDefaultExtensionModel.shared.userRoleParticularId)
            }
            
            else {
                self.showAlert(Message: "Please select class first.")
            }
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    
    
    @IBAction func actionSelectSubmissionDate(_ sender: UIButton) {
        showDatePicker(datePickerDelegate: self)

    }
    
    @IBAction func attachFiles(_ sender: UIButton) {
      let importMenu = UIDocumentPickerViewController(documentTypes: ["public.data", "public.content"], in: UIDocumentPickerMode.import)
        importMenu.delegate = self
        present(importMenu, animated: true, completion: nil)
    }
    
    @IBAction func actionAddNotes(_ sender: UIButton) {
         if checkInternetConnection(){
            
            if txtfieldClass.text == "" {
                self.showAlert(alert: "Please select class")
            }
            
            else if txtfieldSubject.text == "" {
                
                self.showAlert(alert: "Please select subject")
            }
            
            else if txtfieldTitle.text == "" {
                
                  self.showAlert(alert: "Please enter title")
            }
            
            else if txtViewDescription.text == "" {
                         
                           self.showAlert(alert: "Please enter description")
                     }
            
            else if txtfieldSubmissionDate.text == "" {
                   self.showAlert(alert: "Please select submission date")
            }
           
            else {
            var attachementArr = [URL]()
                 _ = uploadData.enumerated().map { (index,element) in
                   
                   let dd = element as? [String:Any]
                    if let url = dd?["url"] as? URL {
                        if url != nil {
                    attachementArr.append((dd?["url"] as? URL)!)
                        }
                    }
                   }
                
               //  self.showAlert(Message: "Homework added successfully")
              //  self.navigationController?.popViewController(animated: true)
             self.viewModel?.saveHomework(AssignHomeWorkId: AssignHomeWorkId ?? 0, ClassId: selectedClassId ?? 0, SubjectId: subjectId ?? 0, Topic: txtfieldTitle.text ?? "", ClassSubjectId: selectedSubjectId ?? 0, Details: txtViewDescription.text ?? "", SubmissionDate: txtfieldSubmissionDate.text  ?? "", lstAssignHomeAttachmentMapping: attachementArr)
                
            }
            
        }
        
         else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
       
    }
    
    @IBAction func actionDelNotes(_ sender: UIButton) {
        
        if uploadData.count > 0  || editableHomeWorkData != nil {
            selectedIndexPathForDelAttachment = sender.tag
                                initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                                yesNoAlertView.delegate = self
                                yesNoAlertView.lblResponseDetailMessage.text = "Do you really want to delete this attachment?"
                                
                            }
       
        
    }
    
}


extension AddHomeWorkVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            
            let dic = uploadData[selectedIndexPathForDelAttachment ?? 0] as? [String:Any]

           if dic?["id"] as? Int == 0 {
            uploadData.removeObject(at: selectedIndexPathForDelAttachment ?? 0)
                              tblView.reloadData()
          }else{
            self.viewModel?.deleteAttachment(assignWorkAttachmentId: dic?["id"] as? Int )
           
          }
            yesNoAlertView.removeFromSuperview()

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


extension AddHomeWorkVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return uploadData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddNotesCell
        
        cell.btnDel.tag = indexPath.row

       
            let dic = uploadData[indexPath.row] as? [String:Any]
            cell.lblAttachment.text = dic?["fileName"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
  
    
}

extension AddHomeWorkVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        if uploadData.count <= 5 {
            
            if uploadData.count > 0 {
            
            _ = uploadData.enumerated().map { (index,element) in
            
            let dd = element as? [String:Any]
            if dd?["fileName"] as? String == myURL.lastPathComponent {
                self.showAlert(Message: "You have already selected this file.")
            }
            
            else{
                var modelHW = [String: Any]()
                      modelHW["url"] = myURL
                      modelHW["fileName"] = myURL.lastPathComponent
                      modelHW["id"] = 0
                      uploadData.add(modelHW)
            }
        }
            
        }
      
            
        else{
                                 var modelHW = [String: Any]()
                                 modelHW["url"] = myURL
                                 modelHW["fileName"] = myURL.lastPathComponent
                                 modelHW["id"] = 0
                                 uploadData.add(modelHW)
            }}
        else{
            self.showAlert(Message: "Maximum limit to upload the document is 5.")
        }
         
        
        heightTblView.constant  = CGFloat(uploadData.count * 51)
        self.tblView.reloadData()
        print("import result : \(myURL)")
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}


//MARK:- SharedUIPickerDelegate
extension AddHomeWorkVC:SharedUIDatePickerDelegate{
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        //yearofestablishment
        let dateFormatter       = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        txtfieldSubmissionDate.text = strDate
    }
}


extension AddHomeWorkVC : ViewDelegate {
    
    func showAlert(alert: String) {
        self.showAlert(Message: alert)
    }
    
    func showLoader() {
          self.ShowLoader()
    }
    
    func hideLoader() {
        self.HideLoader()
    }
    
}

extension AddHomeWorkVC : AddHomeWorkDelegate {
    func studentHomeworkDetail(data: [HomeworkListStudentData]) {
        
    }
    
    func subjectList(data: [HomeworkResultHWData]) {
        
    }
    
    func attachmentDeletedSuccessfully() {
                   uploadData.removeObject(at: selectedIndexPathForDelAttachment ?? 0)
        tblView.reloadData()

    }
    
    func addedSuccessfully() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getSubjectList(arr: [GetSubjectHWResultData]) {
        if arr.count > 0{
                         //Set data when user first time come
                   

                      subjectList = arr
                      selectedSubjectId = subjectList?[0].ClassSubjectId
                      subjectId = subjectList?[0].ID
                      txtfieldSubject.text = subjectList?[0].Name
            
            if   strWhichPickerSelected == "subject" {

                    UpdatePickerModel(count: subjectList?.count ?? 0, sharedPickerDelegate: self, View: self.view)
            }

                     
                     }else{
                        // self.showAlert(alert: "There is no subject")
                         CommonFunctions.sharedmanagerCommon.println(object: "Count is zero.")
                     }
              
    }
    
    
    func classListDidSuccess(data: GetCommonDropdownModel) {
        if data.resultData != nil{
               if data.resultData?.count ?? 0 > 0{
                   //Set data when user first time come
                classDropdownData = data.resultData
                selectedClassId = classDropdownData?[0].id
                txtfieldClass.text = classDropdownData?[0].name
                UpdatePickerModel(count: data.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view)

                self.viewModel?.getData(classId: selectedClassId ?? 0, teacherId: UserDefaultExtensionModel.shared.userRoleParticularId)
               }else{
                   self.showAlert(alert: "There is no classes")
                   CommonFunctions.sharedmanagerCommon.println(object: "Count is zero.")
               }
           }
    }
    
    
    func AddHomeworkSucceed(array: [HomeworkResultData]) {
    }
    
    func AddHomeworkFailour(msg: String) {
         self.showAlert(Message: msg)
    }
}
//MARK:- Picker View Delegates
extension AddHomeWorkVC:SharedUIPickerDelegate{
    func DoneBtnClicked() {
         doneClick()
    }
    func GetTitleForRow(index: Int) -> String {
        
        if strWhichPickerSelected == "class" {
        let dic = classDropdownData?[index]
        let title = dic?.name
            return "\(String(describing: title!))" }
        else{
            if let dic = subjectList?[index] {
                let title = dic.Name
                return "\(String(describing: title!))"}
            else{
                return ""
            }
        }
    }
    
    func SelectedRow(index: Int) {
        
        if strWhichPickerSelected == "class" {
             let dic = classDropdownData?[index]
                   let title = dic?.name
            txtfieldClass.text = "\(String(describing: title!))"
            
        }
        else{
            let dic = subjectList?[index]
                             let title = dic?.Name
                      txtfieldSubject.text = "\(String(describing: title!))"
            
        }
        
   
}

}


extension AddHomeWorkVC:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lblPlaceHolder.isHidden = true
         self.animateTextView(textView: textView, up: true, movementDistance: 200, scrollView:self.scrollView)
     
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let str = textView.text.trimmingCharacters(in: .whitespaces)
        
        if str == ""
        {
            self.txtViewDescription.text = ""
            lblPlaceHolder.isHidden = false
            
        }
        else{
            txtViewDescription.text = textView.text
        }
        
            DispatchQueue.main.async {
                
                self.animateTextView(textView: textView, up: false, movementDistance: 250, scrollView:self.scrollView)
            }
        
    }
    
}
