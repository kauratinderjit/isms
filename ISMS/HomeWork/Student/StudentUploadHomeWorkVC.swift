//
//  StudentUploadHomeWorkVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/16/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentUploadHomeWorkVC: BaseUIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var lblPlaceHolderComment: UILabel!
    @IBOutlet weak var tblViewListing: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    var uploadData = NSMutableArray()
  var viewModel : HomeworkViewModel?
    var AssignHomeWorkId : Int? = 0
     var StudentId : Int? = 0
    var StudentHomeworkId : Int? = 0
      var lststuattachmentModels: [stuAttachmentViewModels]?
    @IBOutlet weak var btnSubmit: UIButton!
     var  datalocalStu: [HomeworkListStudentData]?
    var booledit = false
    var selectedIndexPathForDelAttachment : Int? = 0
   var deletedAttachmentArray = NSMutableArray()
    public var lstActionAccess : GetMenuFromRoleIdModel.ResultData?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Upload Tasks"
        setBackButton()
        heightTableView.constant = 0
        self.viewModel = HomeworkViewModel.init(delegate: self)
                      self.viewModel?.attachView(viewDelegate: self)
        
        if datalocalStu != nil
        {
            if (datalocalStu?.count ?? 0 > 0)
            {
                if (datalocalStu?[0].lststuattachmentModels?.count ?? 0 > 0)
                {
                    StudentHomeworkId = datalocalStu?[0].lststuattachmentModels?[0].StudentHomeworkId
                    
                     self.title = "Update Tasks"
                    heightTableView.constant =  CGFloat((lststuattachmentModels?.count ?? 0) * 52)
                     txtViewComment.text = datalocalStu?[0].lststuattachmentModels?[0].Comment
                     btnSubmit.setTitle("UPDATE", for: .normal)
                     lblPlaceHolderComment.isHidden = true
                    if lststuattachmentModels?.count ?? 0 > 0 {
                         
                        for (index, element) in (lststuattachmentModels?.enumerated())! {
                           print("Item \(index): \(element)")
                           
                         var modelHW = [String: Any]()
                            modelHW["url"] = element.AttachmentUrl
                                              modelHW["fileName"] = element.FileName
                                              modelHW["id"] = element.StudentAttachmentId
                                              uploadData.add(modelHW)
                         
                         }
                        tblViewListing.reloadData()
                     }
                }
            }
         }
    }
    
    
    
    @IBAction func actionDel(_ sender: UIButton) {
        if uploadData.count > 0   {
                 selectedIndexPathForDelAttachment = sender.tag
                                     initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                                     yesNoAlertView.delegate = self
                                     yesNoAlertView.lblResponseDetailMessage.text = "Do you really want to delete this attachment?"
                                     
                                 }
        
    }
    
    @IBAction func actionActionFiles(_ sender: UIButton) {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.data", "public.content"], in: UIDocumentPickerMode.import)
               importMenu.delegate = self
               present(importMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        
        if checkInternetConnection(){
                   
                   if txtViewComment.text == "" {
                    self.showAlert(Message: "Please enter comment")
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
                       
                     

                   StudentId =  UserDefaultExtensionModel.shared.enrollmentIdStudent
                    self.viewModel?.uploadHomeworkStudent(AssignHomeWorkId: AssignHomeWorkId ?? 0, StudentId: StudentId ?? 0, StudentHomeworkId: StudentHomeworkId ?? 0, Comment: txtViewComment.text, Status: true, lstAssignHomeAttachmentMapping: attachementArr, delArr: deletedAttachmentArray)
                       
                   }
                   
               }
               
                else{
                   self.showAlert(Message: Alerts.kNoInternetConnection)
               }
        //self.showAlert(Message: "Homework has been uploaded successfully.")
       // _ = self.navigationController?.popViewController(animated: true)
    }
}

extension StudentUploadHomeWorkVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            
            let dic = uploadData[selectedIndexPathForDelAttachment ?? 0] as? [String:Any]

           if dic?["id"] as? Int == 0 {
            uploadData.removeObject(at: selectedIndexPathForDelAttachment ?? 0)
                              tblViewListing.reloadData()
          }else{
            let dd = uploadData[selectedIndexPathForDelAttachment ?? 0] as? [String: Any]
            var modelHW = [String : Any]()
            modelHW["StudentAttachmentId"] = dd?["id"]
            modelHW["AttachmentUrl"] = dd?["url"]
            deletedAttachmentArray.add(modelHW)
            uploadData.removeObject(at: selectedIndexPathForDelAttachment ?? 0)
               tblViewListing.reloadData()
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
extension StudentUploadHomeWorkVC:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lblPlaceHolderComment.isHidden = true
       
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let str = textView.text.trimmingCharacters(in: .whitespaces)
        
        if str == ""
        {
            self.txtViewComment.text = ""
            lblPlaceHolderComment.isHidden = false
            
        }
        else{
            self.txtViewComment.text = textView.text
        }
        
        
    }
    
}


extension StudentUploadHomeWorkVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
  booledit = false
          if uploadData.count <= 5 {
              
              if uploadData.count > 0 {
              
              _ = uploadData.enumerated().map { (index,element) in
              
              let dd = element as? [String:Any]
              if dd?["fileName"] as? String == myURL.lastPathComponent {
                  self.showAlert(Message: "You have already selected this file.")
                  booledit = true
                  return
              }
                  }
                  if booledit == false {
            
                  var modelHW = [String: Any]()
                        modelHW["url"] = myURL
                        modelHW["fileName"] = myURL.lastPathComponent
                        modelHW["id"] = 0
                        uploadData.add(modelHW)
             
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
           
          
          heightTableView.constant  = CGFloat(uploadData.count * 51)
          self.tblViewListing.reloadData()
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
extension StudentUploadHomeWorkVC : UITableViewDelegate, UITableViewDataSource {
    
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
extension StudentUploadHomeWorkVC : ViewDelegate {
    
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

extension StudentUploadHomeWorkVC : AddHomeWorkDelegate {
    func studentHomeworkDetail(data: [HomeworkListStudentData]) {
        
//        txtfieldTitle.text = data[0].Topic
//        txtViewDescription.text = data[0].Details
//
//        if txtViewDescription.text == "" {
//            txtViewDescription.text = "No Description Available"
//        }
        
        
        if data[0].lstattachmentModels?.count ?? 0 > 0 {
            for (index, element) in (data[0].lstattachmentModels?.enumerated())! {
                          print("Item \(index): \(element)")
                          
                        var modelHW = [String: Any]()
                         modelHW["url"] = element.AttachmentUrl
                         modelHW["fileName"] = element.FileName
                         modelHW["id"] = element.AssignWorkAttachmentId
                         uploadData.add(modelHW)
                         heightTableView.constant =  CGFloat((data[0].lstattachmentModels?.count ?? 0) * 51)
                        tblViewListing.reloadData()
            }
        }
        
    }
    
    func subjectList(data: [HomeworkResultHWData]) {
        
    }
    
    func attachmentDeletedSuccessfully() {
        
    }
    
    func addedSuccessfully() {
        
    }
    
    func getSubjectList(arr: [GetSubjectHWResultData]) {
        
    }
    
    
    func classListDidSuccess(data: GetCommonDropdownModel) {
        
    }
    
    
    func AddHomeworkSucceed(array: [HomeworkResultData]) {

    }
    
    func AddHomeworkFailour(msg: String) {
         self.showAlert(Message: msg)
    }
}
