//
//  AddTopicVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 6/17/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class AddTopicVC: BaseUIViewController {
       
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var btnAddNote: UIButton!
        @IBOutlet weak var txtfieldTitle: UITextField!
        @IBOutlet weak var txtViewDescription: UITextView!
        @IBOutlet weak var tblView: UITableView!
        var viewModel : SubjectChapterTopicViewModel?
        var lastText: String?
        var dictionaries = [[String:Any]]()
        var arrayAttachmentsToShow = [AttachedFiles]()
        var uploadData = NSMutableArray()
        @IBOutlet weak var lblPlaceHolder: UILabel!
        var topicId : Int? = 0
         var chapterId : Int? = 0
        var selectedIndexPathForDelAttachment : Int? = 0
        var editableData : GetTopicResultData?
        static var isFromHomeWorkDate:Bool?
        @IBOutlet weak var heightTblView: NSLayoutConstraint!
        @IBOutlet weak var btnAdd: UIButton!
         var booledit = false
    var deletedArr = NSMutableArray()
   
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setUp()
            // Do any additional setup after loading the view.

                if editableData != nil {
                    topicId = editableData?.topicId
                    lblPlaceHolder.isHidden = true
                    txtfieldTitle.text = editableData?.topicName
                    txtViewDescription.text = editableData?.Comment
                    
                    if editableData?.lsTopicAttachmentMapping?.count ?? 0 > 0 {
                               
                               for (index, element) in (editableData?.lsTopicAttachmentMapping?.enumerated())! {
                                 print("Item \(index): \(element)")
                                 
                               var modelHW = [String: Any]()
                                                    modelHW["url"] = element.AttachmentUrl
                                                    modelHW["fileName"] = element.FileName
                                                    modelHW["id"] = element.TopicAttachmentId
                                                    uploadData.add(modelHW)
                               }
                                     heightTblView.constant  = CGFloat(uploadData.count * 51)
                                   self.tblView.reloadData()
                               
                           }
                    
                }
                
            
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
            AddHomeWorkVC.isFromHomeWorkDate = false
        }
        
        func setUp() {
            
            AddHomeWorkVC.isFromHomeWorkDate = true
             setBackButton()
            self.title = "Add Topic"
            tblView.tableFooterView = UIView()

            self.viewModel = SubjectChapterTopicViewModel.init(delegate: self)
            self.viewModel?.attachView(viewDelegate: self)
            heightTblView.constant = 0
        }
        
        
        @IBAction func attachFiles(_ sender: UIButton) {
            self.view.endEditing(true)
          let importMenu = UIDocumentPickerViewController(documentTypes: ["public.data", "public.content"], in: UIDocumentPickerMode.import)
            importMenu.delegate = self
            present(importMenu, animated: true, completion: nil)
        }
        
        @IBAction func actionAddNotes(_ sender: UIButton) {
             if checkInternetConnection(){
                
                
                
              if txtfieldTitle.text == "" {
                    
                      self.showAlert(alert: "Please enter title")
                }
                
                else if txtViewDescription.text == "" {
                             
                               self.showAlert(alert: "Please enter description")
                         }
                
               
                else {
                var attachementArr = [URL]()
                     _ = uploadData.enumerated().map { (index,element) in
                       
                       let dd = element as? [String:Any]
                       if let url = dd?["id"] as? Int {
                            if url == 0  {
                        attachementArr.append((dd?["url"] as? URL)!)
                            }
                        }
                       }
                    
                   //  self.showAlert(Message: "Homework added successfully")
                  //  self.navigationController?.popViewController(animated: true)
                self.viewModel?.add_Topic(TopicId: topicId ?? 0, UserId: 5, TopicName: txtfieldTitle.text ?? "" , ChapterId: chapterId ?? 0, Comment: txtViewDescription.text ?? "", IsTopicAttachmentMapping: attachementArr, lstdeleteattachmentModel: deletedArr)
                    
                }
            }
             else{
                self.showAlert(Message: Alerts.kNoInternetConnection)
            }
           
        }
        
        @IBAction func actionDelNotes(_ sender: UIButton) {
            
            if uploadData.count > 0  || editableData != nil {
                selectedIndexPathForDelAttachment = sender.tag
                                    initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                                    yesNoAlertView.delegate = self
                                    yesNoAlertView.lblResponseDetailMessage.text = "Do you really want to delete this attachment?"
                                    
                                }
            
        }
        
    }


    extension AddTopicVC : YesNoAlertViewDelegate{
        
        func yesBtnAction() {
            if self.checkInternetConnection(){
                
                let dic = uploadData[selectedIndexPathForDelAttachment ?? 0] as? [String:Any]

               if dic?["id"] as? Int == 0 {
                uploadData.removeObject(at: selectedIndexPathForDelAttachment ?? 0)
                                  tblView.reloadData()
              }else{
                   let dd = uploadData[selectedIndexPathForDelAttachment ?? 0] as? [String: Any]
                        var modelHW = [String : Any]()
                        modelHW["id"] = dd?["id"]
                        modelHW["url"] = dd?["url"]
                        deletedArr.add(modelHW)
                        uploadData.removeObject(at: selectedIndexPathForDelAttachment ?? 0)
                           tblView.reloadData()
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


    extension AddTopicVC : UITableViewDelegate, UITableViewDataSource {
        
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

    extension AddTopicVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
        
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




    extension AddTopicVC : ViewDelegate {
        
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

extension AddTopicVC : SubjectChapterTopicDelegate {
    func SubjectDeleteSuccess(data: DeleteTopicModel) {
    }
    
    func getTopicList() {
        self.showAlert(alert: "Topic added successfully")
        self.navigationController?.popViewController(animated: true)
    }
    
    func SubjectListDidSuccess(data: [GetTopicResultData]?) {
       
    }
    
    
    func unauthorizedUser() {
    }
    
}

   

    extension AddTopicVC:UITextViewDelegate{
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            
            if text == "\n"
            {
                textView.resignFirstResponder()
            }
            return true
            
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            lblPlaceHolder.isHidden = true
            if DeviceType.IS_IPHONE_6P_7P || DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.animateTextView(textView: textView, up: true, movementDistance:150, scrollView:self.scrollView)
            }
            
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
                    if DeviceType.IS_IPHONE_6P_7P || DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
                       self.animateTextView(textView: textView, up: false, movementDistance: 150, scrollView:self.scrollView)
                    }
                }
            
        }
        
    }
