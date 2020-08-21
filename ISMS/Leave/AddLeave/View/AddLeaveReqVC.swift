//
//  AddLeaveReqVC.swift
//  ISMS
//
//  Created by Poonam  on 08/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit
import MobileCoreServices
import SDWebImage
import PDFKit

class AddLeaveReqVC: BaseUIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnAttachFiles: UIButton!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var btnToDate: UIButton!
    @IBOutlet weak var txtFieldToDate: UITextField!
    @IBOutlet weak var btnFromDate: UIButton!
    @IBOutlet weak var txtFieldFromDate: UITextField!
    @IBOutlet weak var btnLeaveType: UIButton!
    @IBOutlet weak var txtFieldLeaveType: UITextField!
    
    @IBOutlet weak var viewAcceptRejectBtn: UIView!
    @IBOutlet weak var lblDescrption: UILabel!
    @IBOutlet weak var collectionviewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var viewTableView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
      let documentInteractionController = UIDocumentInteractionController()
    var arrayAttachments = [attachmentListData]()
    var isSelectFromDate = false
    var isSeclectToDate = false
     var viewModel : AddLeaveReqViewModel?
    var arrLeaveListReq : GetLeaveListResultData?
    var leaveId = 0
    
       var arrLeavelist = ["Sick Leave","Urgent Work","Not mentioned in list"]
      static var isFromLeaveListDate:Bool?
      var arrayAttachmentsToShow = [AttachedFiles]()
      var uploadData = [UploadItems]()
     var dictionaries = [[String:Any]]()
      var uploadFile = [[String:Any]]()
      var isimageViewProfile           : Bool?
        var imageURL                     :URL?
    var startDate = Date()
    var endDate = Date()
    var isLeaveEditing: Bool?
    var isFromSubmit = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         AddLeaveReqVC.isFromLeaveListDate = true
        self.viewModel = AddLeaveReqViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        documentInteractionController.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
         if UserDefaultExtensionModel.shared.currentUserRoleId == 2{
            txtFieldLeaveType.isUserInteractionEnabled = false
            txtFieldFromDate.isUserInteractionEnabled = false
            txtFieldToDate.isUserInteractionEnabled = false
            txtViewDescription.isUserInteractionEnabled = false
            btnLeaveType.isUserInteractionEnabled = false
            btnFromDate.isUserInteractionEnabled = false
            btnToDate.isUserInteractionEnabled = false
            btnAttachFiles.isUserInteractionEnabled = false
            viewAcceptRejectBtn.isHidden = false
         }else{
            btnLeaveType.isUserInteractionEnabled = true
            btnFromDate.isUserInteractionEnabled = true
            btnToDate.isUserInteractionEnabled = true
            btnAttachFiles.isUserInteractionEnabled = true
            viewAcceptRejectBtn.isHidden = true
        }
        setUI()
       if isLeaveEditing == true{
            setData()
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
     func dateFromString(string: String) -> String?
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let dt = dateFormatter.date(from: string)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat =  "yyyy-MM-dd"
    //        print("\(dateFormatter.string(from: dt!))")
            return dateFormatter.string(from: dt!)
            
        }
    
   func setData(){
    lblDescrption.isHidden = true
    txtFieldLeaveType.text = arrLeaveListReq?.leaveAppType
    if let dateStr = arrLeaveListReq?.strStartDate{
//        let startDate = self.dateFromString(string:  dateStr ?? "\(Date())")
        let isoDate = arrLeaveListReq?.strStartDate ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from:isoDate)
        startDate = date ?? Date()
           txtFieldFromDate.text = dateStr
    }
    if let dateEnd = arrLeaveListReq?.strEndDate{
//        let endDate = self.dateFromString(string: dateEnd ?? "\(Date())")
//        endDate = arrLeaveListReq?.endDate
        let isoDate = arrLeaveListReq?.strEndDate ?? ""

               let dateFormatter = DateFormatter()
               dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
               dateFormatter.dateFormat = "dd/MM/yyyy"
               let date = dateFormatter.date(from:isoDate)
        endDate = date ?? Date()
             txtFieldToDate.text = dateEnd
    }
  
    txtViewDescription.text = arrLeaveListReq?.discription
    self.leaveId = arrLeaveListReq?.leaveAppId ?? 0
    if let attachments =  arrLeaveListReq?.attachmentList{
                   arrayAttachments = attachments
                   for value in arrayAttachments{
//                       if let type = value.IFile, let attachmentName = value.AttachmentUrl , let filename = value.AttachmentUrl , let id = value.LeaveAppAttachmentId{
                    let model = AttachedFiles.init(type: value.IFile ?? "", instituteAttachmentName:  value.AttachmentUrl ?? "", instituteFileName:  value.AttachmentUrl ?? "", instituteAttachmentId: value.LeaveAppAttachmentId ?? 0 )
                           arrayAttachmentsToShow.append(model)
//                       }
                       print(arrayAttachmentsToShow)
                   }
//                   if arrayAttachmentsToShow.count == 0{
//                       collectionviewHeight.constant = 0.0
//                   }
//                   else{
//                       collectionviewHeight.constant = 120.0
//                   }
                   DispatchQueue.main.async {
                       self.collectionView.reloadData()
                   }
               }
    }
    @objc override func dismissKeyboard() {
      view.endEditing(true)
    }
    func setUI(){
        //Set Back Button
        self.setBackButton()
        
        //Set picker view
        self.SetpickerView(self.view)
        
        setDatePickerView(self.view, type: .date)
        
        //Title
        if isLeaveEditing == true{
             self.title = "Update Leave"
        }else{
             self.title = "Add Leave"
        }
       
        
    }
    override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
           
            AddLeaveReqVC.isFromLeaveListDate = false
       }
    
    @IBAction func actionAccept(_ sender: Any) {
        viewModel?.submitAcceptReject(LeaveAppId : self.leaveId,IsApproved: 1)
    }
    
    @IBAction func actionReject(_ sender: Any) {
          viewModel?.submitAcceptReject(LeaveAppId : self.leaveId,IsApproved: 2)
    }
    

    @IBAction func actionLeaveTypeBtn(_ sender: Any) {
        if checkInternetConnection(){
                    if arrLeavelist.count > 0{
                        UpdatePickerModel2(count: arrLeavelist.count, sharedPickerDelegate: self, View:  self.view, index: 0)
        
                    }
                }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
                }
    }
    @IBAction func actionFromDateBtn(_ sender: Any) {
        isSelectFromDate = true
        isSeclectToDate = false
        showDatePicker(datePickerDelegate: self)
        
        
    }
    @IBAction func actionToDateBtn(_ sender: Any) {
        isSelectFromDate = false
        isSeclectToDate = true
        showDatePicker(datePickerDelegate: self)
    }
    
    @IBAction func actionAttachFilesBtn(_ sender: Any) {
        if uploadData.count < 5
               {
                   viewPopUp.isHidden = false
                   viewTableView.isHidden = false
//                   viewBlur.isHidden = false
               }
               else
               {
                self.showAlert(Message: "Sorry you can not add more than 5 attachments in one time.")
               }
    }
    
    @IBAction func actionCrossBtn(_ sender: Any) {
     let i =  (sender as AnyObject).tag!
        //let imageSelected = arrayAttachmentsToShow[i]
        let selecteditem = arrayAttachmentsToShow[i]
        print(selecteditem)
        if let attachedId = selecteditem.instituteAttachmentId{
            let  subdictionary = ["deleteAttachmentId": attachedId]
            dictionaries.append(subdictionary)
            
        }
        //arrayDeletedItems.append(imageSelected)
        arrayAttachmentsToShow.remove(at: i)

//        if arrayAttachmentsToShow.count == 0
//        {
//            collectionviewHeight.constant = 0.0
//        }
//        else
//        {
//            self.collectionviewHeight.constant =  164.0
//        }
        self.collectionView.reloadData()
    }
    
    @IBAction func actionSubmitBtn(_ sender: Any) {
        if  self.leaveId != 0{
            isFromSubmit = 1
            
            var attachementArr = [URL]()
            for i in 0..<uploadData.count{
                if let urlData = uploadData[i].uRL{
                    attachementArr.append((urlData as? URL)!)
                }
            }

            self.viewModel?.submitLeaveReq(LeaveAppId: self.leaveId, LeaveAppType: txtFieldLeaveType.text ?? "", Discription: txtViewDescription.text ?? "" , StartDate:txtFieldFromDate.text ?? "", EndDate: txtFieldToDate.text ?? "", IsApproved: 0, EnrollmentId: UserDefaultExtensionModel.shared.enrollmentIdStudent ?? 0, ClassId: UserDefaultExtensionModel.shared.StudentClassId, GuardianId: UserDefaultExtensionModel.shared.userRoleParticularId, IFile: attachementArr, leaveAppAttachmentDelete: dictionaries)
        }else{
             isFromSubmit = 1
            var attachementArr = [URL]()
            for i in 0..<uploadData.count{
                if let urlData = uploadData[i].uRL{
                     attachementArr.append((urlData as? URL)!)
                }
            }
            self.viewModel?.submitLeaveReq(LeaveAppId: 0, LeaveAppType: txtFieldLeaveType.text ?? "", Discription: txtViewDescription.text ?? "" , StartDate:txtFieldFromDate.text ?? "", EndDate: txtFieldToDate.text ?? "", IsApproved: 0, EnrollmentId: UserDefaultExtensionModel.shared.enrollmentIdStudent ?? 0, ClassId: UserDefaultExtensionModel.shared.StudentClassId, GuardianId: UserDefaultExtensionModel.shared.userRoleParticularId, IFile: attachementArr, leaveAppAttachmentDelete: dictionaries)
        }
    }
    
    
    @IBAction func actionUploadImage(_ sender: Any) {
        self.isimageViewProfile = false
        self.openGallaryPhotos()
    }
    
    @IBAction func actionUploadDocument(_ sender: Any) {
        self.clickFunction()
    }
    
    func clickFunction(){
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func openGallaryPhotos(){
        let alert = UIAlertController(title: KAlertTitle.KChooseImage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: KAlertTitle.KCamera, style: .default, handler: { _ in
            self.OpenGalleryCamera(camera: true, imagePickerDelegate: self)
        }))
        
        alert.addAction(UIAlertAction(title: KAlertTitle.KGallery, style: .default, handler: { _ in
            self.OpenGalleryCamera(camera: false, imagePickerDelegate: self)
        }))
        alert.addAction(UIAlertAction.init(title: KAlertTitle.KCancel, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
              hideLoader()
           
       }
    func share(url: URL)
    {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    
}
extension AddLeaveReqVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
//MARK:- PICKER DELEGATE FUNCTIONS
extension AddLeaveReqVC : SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if checkInternetConnection(){
           
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
       
            if arrLeavelist.count > 0 {
                txtFieldLeaveType.text = arrLeavelist[index]
                return arrLeavelist[index] ?? ""
            }
        return ""
    }
    
    func SelectedRow(index: Int) {
            if arrLeavelist.count > 0 {
                txtFieldLeaveType.text = arrLeavelist[index]
            }
    }
}

extension AddLeaveReqVC:SharedUIDatePickerDelegate{
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        //yearofestablishment
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale.current
        let convertedDate = formatter.string(from: datePicker.date)
        let strDate = formatter.date(from: convertedDate)
        
        if isSelectFromDate == true{
            startDate = strDate!
            if txtFieldToDate.text != ""{
                if startDate <= endDate{
                     txtFieldFromDate.text = convertedDate
                }else{
                    txtFieldFromDate.text = ""
                    showAlert(alert: "Please enter valid start and end date")
                }
            }else{
                 txtFieldFromDate.text = convertedDate
            }
            
        }else{
        
            endDate = strDate!
            if startDate <= endDate{
                txtFieldToDate.text = convertedDate
            }else{
                showAlert(alert: "Please enter valid start and end date")
            }
            
        }
       
    }
}

//MARK:- UIDocumentMenuDelegate UIDocumentPickerDelegate
extension AddLeaveReqVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
       
        let model = UploadItems.init(uRL: (myURL), filetype: "File")
        uploadData.append(model)
        
        //gurleen
        let modelq = AttachedFiles.init(type: "File", instituteAttachmentName: "\(String(describing: myURL))" ,instituteFileName: "", instituteAttachmentId: 0)
        arrayAttachmentsToShow.append(modelq)
        self.collectionView.reloadData()
         viewTableView.isHidden = true
        self.view.endEditing(true)
//        viewBlur.isHidden = true
    }
  
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
//MARK:- UIImagePickerDelegate
extension AddLeaveReqVC:UIImagePickerDelegate{
    
    func selectedImageUrl(url: URL) {
        
        if isimageViewProfile == true{
            
            imageURL = url
            //            if let urls = url{
            let model = UploadItems.init(uRL: url as URL, filetype: "Logo")
            uploadData.append(model)
            self.collectionView.reloadData()
            //            }
        }
        else{
            
            //            if let urls = videoURL{
            let modelUpload = UploadItems.init(uRL: url as URL, filetype: "Image")
            uploadData.append(modelUpload)
            print(modelUpload)
            //print(AttachedFiles)
            let model = AttachedFiles.init(type: "Image", instituteAttachmentName: "\(String(describing: url))" ,instituteFileName: "", instituteAttachmentId: 0)
            arrayAttachmentsToShow.append(model)
            self.collectionView.reloadData()
            viewTableView.isHidden = true
            self.view.endEditing(true)
//            viewBlur.isHidden = true
            
        }
        
        
        
        
    }
    
    func SelectedMedia(image: UIImage?, videoURL: URL?) {
        
    }
    
    
    
}
//MARK:- UICollectionViewDelegate UICollectionViewDelegate
extension AddLeaveReqVC : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //CollectionView Height
        print(arrayAttachmentsToShow.count)
//        if arrayAttachmentsToShow.count > 0{
//            collectionviewHeight.constant = 120
//        }else{
//            collectionviewHeight.constant = -20
//        }
        return arrayAttachmentsToShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! AttachFilesCollectionViewCell
        let dataFoRow = arrayAttachmentsToShow[indexPath.row]
        cell.setDataCell(data: dataFoRow)
        cell.btn_cross.tag = indexPath.item
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        DispatchQueue.main.async {
            self.showLoader()
        }
        let dataFoRow = arrayAttachmentsToShow[indexPath.row]
        let string = dataFoRow.instituteAttachmentName
        let stringResult = string?.contains(".pdf")
        if stringResult == true{
            storeAndShare(withURLString: dataFoRow.instituteAttachmentName ?? "")
        }
    }
}

//MARK:- Custom Ok Alert
extension AddLeaveReqVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
//        if isUnauthorizedUser == true{
//            isUnauthorizedUser = false
//            CommonFunctions.sharedmanagerCommon.setRootLogin()
//        }
         self.okAlertView.removeFromSuperview()
        if viewAcceptRejectBtn.isHidden == false{
            let storyboard = UIStoryboard.init(name: "Leave", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LeaveListVC") as? LeaveListVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
        }
        if  isFromSubmit == 1{
            let storyboard = UIStoryboard.init(name: "Leave", bundle: nil)
                   let vc = storyboard.instantiateViewController(withIdentifier: "LeaveListVC") as? LeaveListVC
                   let frontVC = revealViewController().frontViewController as? UINavigationController
                   frontVC?.pushViewController(vc!, animated: false)
                   revealViewController().pushFrontViewController(frontVC, animated: true)
        }
       
        }
}
//MARk:- View Delegate
extension AddLeaveReqVC : ViewDelegate{
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }
    func showLoader() {
        ShowLoader()
    }
    func hideLoader() {
        HideLoader()
    }
}
extension AddLeaveReqVC : AddLeaveReqDelegate{
    func addLeaveSucess(msg: String){
        self.showAlert(alert: msg)
    }
   
}
extension AddLeaveReqVC:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lblDescrption.isHidden = true
         self.animateTextView(textView: textView, up: true, movementDistance: 200, scrollView:self.scrollView)
     
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let str = textView.text.trimmingCharacters(in: .whitespaces)
        
        if str == ""
        {
            self.txtViewDescription.text = ""
            lblDescrption.isHidden = false
            
        }
        else{
            txtViewDescription.text = textView.text
        }
        
            DispatchQueue.main.async {
                
                self.animateTextView(textView: textView, up: false, movementDistance: 250, scrollView:self.scrollView)
            }
        
    }
    
}
