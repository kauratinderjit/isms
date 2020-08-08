//
//  AddResultVC.swift
//  ISMS
//
//  Created by Poonam  on 26/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//


import UIKit

class AddResultVC: BaseUIViewController {
       
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var btnAddNote: UIButton!
        @IBOutlet weak var txtfieldTitle: UITextField!
        @IBOutlet weak var txtViewDescription: UITextView!
        @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
//     let documentInteractionController = UIDocumentInteractionController()
    let documentInteractionController = UIDocumentInteractionController()
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
     
    @IBOutlet weak var btnAddResult: UIButton!
    var arr_resulrListReq : GetListResultData?
       var isResultEditing: Bool?
         var booledit = false
    var deletedArr = NSMutableArray()
   
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setUp()
              documentInteractionController.delegate = self
            // Do any additional setup after loading the view.

                if isResultEditing == true {
                    topicId = arr_resulrListReq?.ResultId
//                    lblPlaceHolder.isHidden = true
                    txtfieldTitle.text = arr_resulrListReq?.Title
//                    txtViewDescription.text = editableData?.Comment
                    
                    if arr_resulrListReq?.resultAttachmentViewModels?.count ?? 0 > 0 {
                               
                               for (index, element) in (arr_resulrListReq?.resultAttachmentViewModels?.enumerated())! {
                                 print("Item \(index): \(element)")
                                 
                                var modelHW = [String : Any]()
                                modelHW["id"] = element.ResultAttachmentId
                                modelHW["url"] = element.AttachmentUrl
                                uploadData.add(modelHW)
                               }
                                     heightTblView.constant  = 120
                                   self.collectionView.reloadData()
                               
                           }
                    
                }
            if UserDefaultExtensionModel.shared.currentUserRoleId == 2 || UserDefaultExtensionModel.shared.currentUserRoleId == 4 || UserDefaultExtensionModel.shared.currentUserRoleId == 5 || UserDefaultExtensionModel.shared.currentUserRoleId == 6{
                btnAddNote.isHidden = true
                btnAddResult.isHidden = true
                txtfieldTitle.isUserInteractionEnabled = false
            }
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
            AddHomeWorkVC.isFromHomeWorkDate = false
        }
        
        func setUp() {
            
            AddHomeWorkVC.isFromHomeWorkDate = true
             setBackButton()
            self.title = "Add Result"
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
                
//                else if txtViewDescription.text == "" {
//
//                               self.showAlert(alert: "Please enter description")
//                         }
                
               
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
                    
//                     self.showAlert(Message: "Homework added successfully")
//                    self.navigationController?.popViewController(animated: true)
                if isResultEditing == true{
                    self.viewModel?.addResult(ResultId: arr_resulrListReq?.ResultId ?? 0, SessionId: UserDefaultExtensionModel.shared.activeSessionId, Title: txtfieldTitle.text ?? "" , IFile: attachementArr, lstdeleteattachmentModel: deletedArr)
                                   
                }else{
                    self.viewModel?.addResult(ResultId: 0, SessionId: UserDefaultExtensionModel.shared.activeSessionId, Title: txtfieldTitle.text ?? "" , IFile: attachementArr, lstdeleteattachmentModel: deletedArr)
                                   
                }
           
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
          func storeAndShare(withURLString: String)
          {
              let urlString = withURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

              guard let url = URL(string: urlString) else { return }
              /// START YOUR ACTIVITY INDICATOR HERE
              URLSession.shared.dataTask(with: url) { data, response, error in
                  guard let data = data, error == nil else { return }
                  let tmpURL = FileManager.default.temporaryDirectory
                      .appendingPathComponent(response?.suggestedFilename ?? "fileName")
                  do {
                      try data.write(to: tmpURL)
                  } catch {
                      print(error)
                  }
                  DispatchQueue.main.async {
                      self.hideLoader()
                      /// STOP YOUR ACTIVITY INDICATOR HERE
                  self.share(url: tmpURL)
                      
                      let pdfFilePath = URL(string: tmpURL.absoluteString)
                      let pdfData = NSData(contentsOf: pdfFilePath!)
                      let activityVC = UIActivityViewController(activityItems: [pdfData!], applicationActivities: nil)
                      self.present(activityVC, animated: true, completion: nil)
                      
                  }
                  }.resume()
               //  hideLoader()
              
          }
    
    func share(url: URL)
       {
           documentInteractionController.url = url
           documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
           documentInteractionController.name = url.localizedName ?? url.lastPathComponent
           documentInteractionController.presentPreview(animated: true)
       }
    }


    extension AddResultVC : YesNoAlertViewDelegate{
        
        func yesBtnAction() {
            if self.checkInternetConnection(){
                
                let dic = uploadData[selectedIndexPathForDelAttachment ?? 0] as? [String:Any]

               if dic?["id"] as? Int == 0 {
                uploadData.removeObject(at: selectedIndexPathForDelAttachment ?? 0)
                                  collectionView.reloadData()
              }else{
                   let dd = uploadData[selectedIndexPathForDelAttachment ?? 0] as? [String: Any]
                        var modelHW = [String : Any]()
                        modelHW["id"] = dd?["id"]
                        modelHW["url"] = dd?["url"]
                        deletedArr.add(modelHW)
                        uploadData.removeObject(at: selectedIndexPathForDelAttachment ?? 0)
                           collectionView.reloadData()
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


//    extension AddResultVC : UITableViewDelegate, UITableViewDataSource {
//
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//            return uploadData.count
//
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddNotesCell
//
//            cell.btnDel.tag = indexPath.row
//
//
//                let dic = uploadData[indexPath.row] as? [String:Any]
//                cell.lblAttachment.text = dic?["fileName"] as? String
//            return cell
//        }
//
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 57
//        }
//
//
//    }

extension AddResultVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

///MARK:- UICollectionViewDelegate UICollectionViewDelegate
extension AddResultVC : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //CollectionView Height
        print(uploadData.count)
//        if arrayAttachmentsToShow.count > 0{
//            collectionviewHeight.constant = 120
//        }else{
//            collectionviewHeight.constant = -20
//        }
        
        return uploadData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath as IndexPath) as! AttacheFileResultCell
//        let dataFoRow = uploadData[indexPath.row]
        cell.setDataCell()
        cell.btn_cross.tag = indexPath.item
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        let dataFoRow = uploadData[indexPath.row] as! [String:Any]
        showLoader()
//        let dataUrl = dataFoRow as AnyObject as! [String:Any]
        let stringUrl = dataFoRow["url"] as! String
        storeAndShare(withURLString:  stringUrl)
    }
    
}

    extension AddResultVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
        
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
             
            
            heightTblView.constant  = 120
            self.collectionView.reloadData()
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




    extension AddResultVC : ViewDelegate {
        
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

extension AddResultVC : SubjectChapterTopicDelegate {
    func SubjectDeleteSuccess(data: DeleteTopicModel) {
    }
    
    func getTopicList() {
        self.showAlert(alert: "Result Added  successfully")
        self.navigationController?.popViewController(animated: true)
    }
    
    func SubjectListDidSuccess(data: [GetTopicResultData]?) {
       
    }
    
    
    func unauthorizedUser() {
    }
    
}
