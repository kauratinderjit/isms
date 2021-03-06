//
//  StudentDetailHomeworkVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/16/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentDetailHomeworkVC: BaseUIViewController {
    
    let documentInteractionController = UIDocumentInteractionController()

    @IBOutlet weak var txtfieldClass: UITextField!
    @IBOutlet weak var txtfieldSubject: UITextField!
    @IBOutlet weak var txtfieldTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtfieldSubmissionDate: UITextField!
    @IBOutlet weak var tblViewListing: UITableView!
    @IBOutlet weak var heightTblView: NSLayoutConstraint!
      var viewModel : HomeworkViewModel?
    var objGetStudentHomeDetail : Int?
    var uploadData = NSMutableArray()
    var  datalocal: [HomeworkListStudentData]?
    public var lstActionAccess : GetMenuFromRoleIdModel.ResultData?

    
    let formatter: DateFormatter = {
              let formatter = DateFormatter()
              formatter.dateFormat = "dd/MM/yyyy"
              return formatter
      }()
    
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Homework Details"
        heightTblView.constant = 0
        self.viewModel = HomeworkViewModel.init(delegate: self)
               self.viewModel?.attachView(viewDelegate: self)
        tblViewListing.tableFooterView = UIView()
        tblViewListing.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        tblViewListing.separatorStyle = .singleLine
       
        documentInteractionController.delegate = self
        setBackButton()

        
    }
    override func viewWillAppear(_ animated: Bool) {
         self.viewModel?.getHomeworkDataForStudent(studentId: UserDefaultExtensionModel.shared.enrollmentIdStudent, assignHomeWorkId: objGetStudentHomeDetail ?? 0)
    }

    
    @IBAction func actionbtnSubmit(_ sender: UIButton) {
       // StudentUploadHomeWorkVC
        if datalocal?.count ?? 0 > 0 {
            let vc = UIStoryboard.init(name:"Homework", bundle: Bundle.main).instantiateViewController(withIdentifier: "StudentUploadHomeWorkVC") as! StudentUploadHomeWorkVC
          //  print(datalocal)
            vc.AssignHomeWorkId = datalocal?[0].AssignHomeWorkId
            //vc.StudentHomeworkId = datalocal?[0].
            
            if (datalocal?.count ?? 0 > 0)
            {
                if (datalocal?[0].lststuattachmentModels?.count ?? 0 > 0)
                {
                    vc.lststuattachmentModels = datalocal?[0].lststuattachmentModels?[0].stuAttachmentViewModels
                }
            }
            vc.datalocalStu = datalocal
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func actionBtnDownload(_ sender: UIButton) {
        
        let dic = uploadData[sender.tag] as? [String:Any]
              storeAndShare(withURLString: dic?["url"] as? String ?? "")
//
//        guard let url = URL(string: dic?["url"] as! String) else { return }
//
//             let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
//
//             let downloadTask = urlSession.downloadTask(with: url)
//             downloadTask.resume()

        
    }
    
    
    
}
extension StudentDetailHomeworkVC : ViewDelegate {
    
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

extension StudentDetailHomeworkVC : AddHomeWorkDelegate {
    func studentHomeworkDetail(data: [HomeworkListStudentData]) {
        datalocal = data
        txtfieldTitle.text = data[0].Topic
        txtViewDescription.text = data[0].Details
        
        if txtViewDescription.text == "" {
            txtViewDescription.text = "No Description Available"
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        if let dateFinal =  dateFormatter.date(from: data[0].SubmssionDate ?? "") {
                        let dd = formatter.string(from: dateFinal)
                        txtfieldSubmissionDate.text = dd
                    }
        
        if data[0].lstattachmentModels?.count ?? 0 > 0 {
            for (index, element) in (data[0].lstattachmentModels?.enumerated())! {
                          print("Item \(index): \(element)")
                          
                        var modelHW = [String: Any]()
                         modelHW["url"] = element.AttachmentUrl
                         modelHW["fileName"] = element.FileName
                         modelHW["id"] = element.AssignWorkAttachmentId
                         uploadData.add(modelHW)
                         heightTblView.constant =  CGFloat((data[0].lstattachmentModels?.count ?? 0) * 51)
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
extension StudentDetailHomeworkVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return uploadData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentHomeworkDownloadCell
        
        cell.btnDownload.tag = indexPath.row

       
            let dic = uploadData[indexPath.row] as? [String:Any]
            cell.lblAttachment.text = dic?["fileName"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataFoRow = uploadData[indexPath.row] as? [String:Any]
        storeAndShare(withURLString: dataFoRow?["url"] as? String ?? "")
    }
  
    
    func storeAndShare(withURLString: String) {
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
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.share(url: tmpURL)
            }
            }.resume()
    }
    
    
       func share(url: URL) {
           documentInteractionController.url = url
           documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
           documentInteractionController.name = url.localizedName ?? url.lastPathComponent
           documentInteractionController.presentPreview(animated: true)
       }
    
}
extension StudentDetailHomeworkVC:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.showAlert(alert: "Attachment Downloaded successfully")
            //self.pdfURL = destinationURL
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
//MARK:- UIDocumentMenuDelegate UIDocumentPickerDelegate
extension StudentDetailHomeworkVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
 
    }
  
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
//MARK:- UIDocumentInteractionControllerDelegate
extension StudentDetailHomeworkVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
