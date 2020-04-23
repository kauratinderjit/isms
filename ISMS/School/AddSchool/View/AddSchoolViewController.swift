//
//  AddSchoolViewController.swift
//  ISMS
//  VC
//  Created by Atinder Kaur on 6/7/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import MobileCoreServices
import SDWebImage
import PDFKit
class AddSchoolViewController: BaseUIViewController {
    //MARK:- Variables
    let documentInteractionController = UIDocumentInteractionController()
    var viewModel                    : AddSchoolViewModel?
    var imageURL                     :URL?
    var isimageViewProfile           : Bool?
    var imgView_indexPath            :Int?
    var deletedImages                = [String]()
    var arrayAttachments = [SchoolData.ListAttachment]()
    var schoolData: SchoolData?
    var schoolCollegeList = [GetCommonDropdownModel.ResultData]()
    var array_picker = [Int]()
    var array_newUploadFiles = [URL]()
    var selectedLat:String?
    var selectedLong:String?
    var uploadData = [UploadItems]()
    var arrayAttachmentsToShow = [AttachedFiles]()
    var arrayDeletedItems = [AttachedFiles]()
    var isUnauthorizedUser = false
    
    var dictionaries = [[String:Any]]()
        //NSMutableArray()
    var typeID : Int?
    
    //MARK:- Outlets
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnSelectImages: UIButton!
    @IBOutlet weak var txtfieldName: UITextField!
    @IBOutlet weak var txtAffiliationBoard: UITextField!
    @IBOutlet weak var txtGeolocation: UITextField!
    @IBOutlet weak var txtfieldWebsiteLink: UITextField!
    @IBOutlet weak var txtfieldAddress: UITextField!
    @IBOutlet weak var txtfieldPhoneNumber: UITextField!
    @IBOutlet weak var txtfieldEmail: UITextField!
    @IBOutlet weak var txtfieldInquiry: UITextField!
    @IBOutlet weak var txtfileldSchoolCollege: UITextField!
    @IBOutlet weak var txtHeaderContactDetails: UITextField!
    @IBOutlet weak var txtHeaderTypeEstablishment: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtfield_yearOfEstablishment: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectonView: UICollectionView!
    @IBOutlet weak var viewUploadedCertificates: UIView!
    @IBOutlet weak var view_radioButtons: UIView!
    @IBOutlet weak var vieTypeEstablishments: UIView!
    @IBOutlet weak var viewGeoLocation: UIView!
    @IBOutlet weak var viewBlurr: UIView!
    @IBOutlet weak var viewtableView: UIView!
    @IBOutlet weak var viewAffiliationBoard: UIView!
//    @IBOutlet weak var btnRadioCollege: UIButton!
//    @IBOutlet weak var btnRadioSchool: UIButton!
    @IBOutlet weak var viewSchoolCollege: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var collectiviewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var view_document: UIView!
    @IBOutlet weak var view_image: UIView!
    @IBOutlet weak var SchoolCollegeView: UIView!
    @IBOutlet weak var ContactDetailsView: UIView!
    @IBOutlet weak var txtfieldUploadCerts: UITextField!
    
    let formatter: DateFormatter = {
               let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd"
               return formatter
       }()
     
     let dateFormatter = DateFormatter()
    
   
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDatePickerView(self.view, type: .date)
        self.viewModel = AddSchoolViewModel.init(delegate : self )
        self.viewModel?.attachView(view: self)
        self.viewModel?.GetSchoolInformation(institudeId: 1)
        self.tableView.tableFooterView = UIView()
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.width/2
        self.hideKeyboardWhenTappedAround()
        documentInteractionController.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewBlurr.isHidden = true
        self.viewtableView.isHidden = true
    }
    //MARK:- functions
    func setUI() {
        
        setBackButton()
        
      //  addViewCornerShadow(radius: 3, view: txtfieldWebsiteLink)
      //  addViewCornerShadow(radius: 3, view: txtfieldName)
      //  addViewCornerShadow(radius: 3, view: txtfieldAddress)
      //  addViewCornerShadow(radius: 3, view: txtGeolocation)
      //  addViewCornerShadow(radius: 3, view: viewGeoLocation)
     //   addViewCornerShadow(radius: 3, view: viewAffiliationBoard)
     //   addViewCornerShadow(radius: 3, view: vieTypeEstablishments)
     //   addViewCornerShadow(radius: 3, view: viewUploadedCertificates)
    //    addViewCornerShadow(radius: 3, view: view_image)
      //  addViewCornerShadow(radius: 3, view: view_document)
      //  addViewCornerShadow(radius: 3, view: viewPopUp)
      //  addViewCornerShadow(radius: 3, view: btnSubmit)
      //  addViewCornerShadow(radius: 3, view: viewtableView)
      //  addViewCornerShadow(radius: 3, view: ContactDetailsView)
      //  addViewCornerShadow(radius: 3, view: SchoolCollegeView)
        
        //Add Padding
        txtfileldSchoolCollege.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfieldWebsiteLink.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfieldName.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfieldAddress.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtGeolocation.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfieldEmail.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfieldPhoneNumber.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfieldInquiry.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtAffiliationBoard.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfield_yearOfEstablishment.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfieldUploadCerts.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        
        guard let theme = ThemeManager.shared.currentTheme else {return}
        btnSubmit.backgroundColor = theme.uiButtonBackgroundColor
        btnSubmit.titleLabel?.textColor = theme.uiButtonTextColor
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
    
    func clickFunction(){
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    //MARK:- Actions
    
    @IBAction func ActionUploadImage(_ sender: Any) {
        self.isimageViewProfile = false
        self.openGallaryPhotos()
    }
    
    @IBAction func ActionUploadDocument(_ sender: Any) {
        self.clickFunction()
    }
    
    @IBAction func ActionAddimage(_ sender: Any) {
        self.isimageViewProfile = true
        openGallaryPhotos()
    }
    
    @IBAction func openAffiliationBoardOptions(_ sender: UIButton) {
        
    }
    @IBAction func ActionSchoolCollegeList(_ sender: Any) {
        if let establishType = schoolData?.resultData?.establishType{
            //print(establishType)
            self.viewModel?.getSchoolColleges(id:establishType, enumType: 4 )
        }
    }
    @IBAction func openLocationSelection(_ sender: UIButton) {
        self.performSegue(withIdentifier: "moveToMaps", sender: self)
    }
    
    @IBAction func yearOfEsblishment(_ sender: UIButton) {
        showDatePicker(datePickerDelegate: self)
    }
    @IBAction func TypeOfEstablishment(_ sender: UIButton) {
    }
    
    @IBAction func uploadCertificates(_ sender: UIButton) {
        //actionSheet
        viewPopUp.isHidden = false
        viewtableView.isHidden = false
        tableView.isHidden = true
        viewBlurr.isHidden = false
    }
    
    @IBAction func Action_submitInfo(_ sender: Any) {
        
        
        self.viewModel?.updateSchoolAPI(InstititeId: 1, Name: txtfieldName.text ?? "", Latitude: selectedLat ?? "" , Longtitude:selectedLong ?? "", WebsiteLink: txtfieldWebsiteLink.text ?? "", Address: txtfieldAddress.text ?? "", PhoneNo: txtfieldPhoneNumber.text ?? "", Email: txtfieldEmail.text ?? "", BoardId: 1, BoardName:txtAffiliationBoard.text ?? "" , Inquiry: txtfieldInquiry.text ?? "", EstablishDate: txtfield_yearOfEstablishment.text ?? "", TypeId: typeID ?? schoolData?.resultData?.typeId ?? 0, TypeName: txtfileldSchoolCollege.text ?? schoolData?.resultData?.typeName ?? "", IFile: uploadData, LstDeletedAttachment: dictionaries)
    }
    
    @IBAction func ActionCrossBtn(_ sender: UIButton) {
        print(arrayAttachments)
   
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

        if arrayAttachments.count == 0{
            collectiviewHeight.constant = 0.0
        }
        else{
            self.collectiviewHeight.constant =  164.0
        }
        self.collectonView.reloadData()
    }
    //MARK:- Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToMaps"{
            let vc = segue.destination as? GeoLocationVC
            //print(resultData?.resultData?.address)
            vc?.address = schoolData?.resultData?.address
            vc?.delegate = self
        }
    }
    //MARK:- Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.stackView.endEditing(true)
        self.view.endEditing(true)
        viewBlurr.isHidden = true
        viewtableView.isHidden = true
    }
}
//MARK:- AddSchoolDelegate
extension AddSchoolViewController: AddSchoolDelegate {
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    
    func getAllSchoolcollegeData(data: GetCommonDropdownModel) {
        
        if let data = data.resultData{
            schoolCollegeList = data
        }
        viewBlurr.isHidden = false
        viewtableView.isHidden = false
        viewPopUp.isHidden = true
        tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    func dataSchoolInfo(data: SchoolData) {
         schoolData = data
        if let resultdata = data.resultData{
            if let lng = resultdata.longtitude, let lat = resultdata.latitude{
                self.txtGeolocation.text = lat + "," + lng
            }
            txtfieldWebsiteLink.text = resultdata.websiteLink
            txtfieldInquiry.text = resultdata.inquiry
            txtfieldEmail.text  = resultdata.email
            txtfieldPhoneNumber.text  = resultdata.phoneNo
            txtfieldAddress.text = resultdata.address
            txtfieldName.text = resultdata.name
            txtAffiliationBoard.text = resultdata.boardName
            
            if let date = resultdata.establishDate{
                print(date)
                
            }
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

                  if let dateFinal =  dateFormatter.date(from: resultdata.establishDate ?? "") {
                             let dd = formatter.string(from: dateFinal)
                            txtfield_yearOfEstablishment.text = dd
                         }
            
            txtfileldSchoolCollege.text = resultdata.typeName
            //setImage
            if let url_str = resultdata.logo{
                if let imageUrl = URL(string: url_str){
                    imgViewProfile.sd_setImage(with:imageUrl , placeholderImage:UIImage(named: "profile"), options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                        if error != nil {
                            self.imgViewProfile.sd_setImage(with:imageUrl , placeholderImage:UIImage(named: "profile"), options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                                if error != nil {
                                    print("Failed: \(String(describing: error))")
                                } else {
                                    print("Success")
                                }
                            }
                        } else {
                            print("Success")
                        }
                    }
                }
            }
            //Attachments
            if let attachments =  resultdata.instituteAttachmentList{
                arrayAttachments = attachments
                for value in arrayAttachments{
                    if let type = value.type, let attachmentName = value.instituteAttachmentName , let filename = value.instituteFileName , let id = value.instituteAttachmentId{
                        let model = AttachedFiles.init(type: type, instituteAttachmentName: attachmentName, instituteFileName: filename, instituteAttachmentId: id )
                        arrayAttachmentsToShow.append(model)
                    }
                    print(arrayAttachmentsToShow)
                }
                if arrayAttachmentsToShow.count == 0{
                    collectiviewHeight.constant = 0.0
                }
                else{
                    collectiviewHeight.constant = 120.0
                }
                DispatchQueue.main.async {
                    self.collectonView.reloadData()
                }
            }
//            if resultdata.establishType == 2{
//                //selected radio college
//                self.btnRadioCollege.setImage(UIImage(named:"radioSelected"), for: .normal)
//                self.btnRadioSchool.setImage(UIImage(named:"radioUnSelected"), for: .normal)
//            }
//            else{
//                //selected radio school
//                self.btnRadioSchool.setImage(UIImage(named:"radioSelected"), for: .normal)
//                self.btnRadioCollege.setImage(UIImage(named:"radioUnSelected"), for: .normal)
//            }
            
            if let url = schoolData?.resultData?.logo{
                       imageURL = URL(string: url)
                   }
                   
                   if let selectedLatitude = self.schoolData?.resultData?.latitude{
                       selectedLat = selectedLatitude
                   }
                   
                   if let selectedLongitude = self.schoolData?.resultData?.longtitude{
                       selectedLong = selectedLongitude
                   }
        }
    }
}
//MARK:- ViewDelegate
extension AddSchoolViewController: ViewDelegate{
    
    func showLoader() {
        ShowLoader()
    }
    
    func hideLoader() {
        HideLoader()
    }
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
        self.viewBlurr.isHidden = true
        self.viewtableView.isHidden = true
    }
}
//MARK:- Ok Alert Delegates
//MARK:- Custom Ok Alert
extension AddSchoolViewController : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        self.okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
     
    }
}

//MARK:- UIDocumentMenuDelegate UIDocumentPickerDelegate
extension AddSchoolViewController: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
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
        self.collectonView.reloadData()
    }
  
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
//MARK:- UIImagePickerDelegate
extension AddSchoolViewController:UIImagePickerDelegate{
    
    func selectedImageUrl(url: URL) {
        
        if isimageViewProfile == true{
            
            imageURL = url
            //            if let urls = url{
            let model = UploadItems.init(uRL: url as URL, filetype: "Logo")
            uploadData.append(model)
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
            self.collectonView.reloadData()
            
        }
        
        
        
        
    }
    
    func SelectedMedia(image: UIImage?, videoURL: URL?) {
        if isimageViewProfile == true{
            self.imgViewProfile.contentMode = .scaleAspectFill
            self.imgViewProfile.image = image
            //            guard (image?.jpegData(compressionQuality: 1.0)) != nil else { return }
            //            imageURL = videoURL! as URL
            //            if let urls = videoURL{
            //                let model = UploadItems.init(uRL: urls as URL, filetype: "Logo")
            //                uploadData.append(model)
            //            }
        }
        else{
            
            //            if let urls = videoURL{
            //                let modelUpload = UploadItems.init(uRL: urls as URL, filetype: "Image")
            //                uploadData.append(modelUpload)
            //                print(modelUpload)
            //                //print(AttachedFiles)
            //                let model = AttachedFiles.init(type: "Image", instituteAttachmentName: "\(String(describing: urls))" ,instituteFileName: "")
            //                arrayAttachmentsToShow.append(model)
            //                print(arrayAttachmentsToShow)
            //
            //            }
            //            self.collectonView.reloadData()
            
        }
        
    }
    
    
    
}
//MARK:- UICollectionViewDelegate UICollectionViewDelegate
extension AddSchoolViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //CollectionView Height
        print(arrayAttachmentsToShow.count)
        
        return arrayAttachmentsToShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! AttachFilesCollectionViewCell
        let dataFoRow = arrayAttachmentsToShow[indexPath.row]
        cell.setDataCell(data: dataFoRow)
        cell.btn_cross.tag = indexPath.item
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataFoRow = arrayAttachmentsToShow[indexPath.row]
        if(dataFoRow.type == "File"){
            storeAndShare(withURLString: dataFoRow.instituteAttachmentName ?? "")
        }
    }
    
}
//MARK:- Downloading Stuff

extension URL {
    
    var uti: String {
        return (try? self.resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier ?? "public.data"
    }
    
}
//MARK:- UIDocumentInteractionControllerDelegate
extension AddSchoolViewController: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
//MARK:- UITableViewDelegate UITableViewDataSource
extension AddSchoolViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolCollegeList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! AttachFilesTableViewCell
        cell.setData(model:schoolCollegeList[indexPath.row])
        print(schoolCollegeList)
        // cell.textLabel?.text = schoolCollegeList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSelectedRow = schoolCollegeList[indexPath.row]
        
        txtfileldSchoolCollege.text = dataSelectedRow.name
        typeID = dataSelectedRow.id
        viewBlurr.isHidden = true
        viewtableView.isHidden = true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}
//MARK:- SelectLocationDelegate
extension AddSchoolViewController: SelectLocationDelegate{
    func selectedLatitudeLongitude(lat: String, long: String, address: String) {
        txtGeolocation.text = address
        selectedLat = lat
        selectedLong = long
        
    }    
}
//MARK:- SharedUIPickerDelegate
extension AddSchoolViewController:SharedUIDatePickerDelegate{
    func doneButtonClicked(datePicker: UIDatePicker) {
        //yearofestablishment
        let dateFormatter       = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePicker.date)
        
        txtfield_yearOfEstablishment.text = strDate
    }
}
//MARK:- To be placed in BaseUI
extension UIViewController
{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension AddSchoolViewController {
    
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
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
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.share(url: tmpURL)
            }
            }.resume()
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}

