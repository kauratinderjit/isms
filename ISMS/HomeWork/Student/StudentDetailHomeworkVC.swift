//
//  StudentDetailHomeworkVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/16/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentDetailHomeworkVC: BaseUIViewController {
    
    
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
        self.viewModel?.getHomeworkDataForStudent(studentId: UserDefaultExtensionModel.shared.userRoleParticularId, assignHomeWorkId: objGetStudentHomeDetail ?? 0)
        
    }

    
    @IBAction func actionbtnSubmit(_ sender: UIButton) {
        
        
    }
    
    @IBAction func actionBtnDownload(_ sender: UIButton) {
        
        let dic = uploadData[sender.tag] as? [String:Any]

        guard let url = URL(string: dic?["url"] as! String) else { return }
             
             let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
             
             let downloadTask = urlSession.downloadTask(with: url)
             downloadTask.resume()

        
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
