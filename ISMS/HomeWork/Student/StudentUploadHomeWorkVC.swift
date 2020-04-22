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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Upload Tasks"
        heightTableView.constant = 0
    }
    

    @IBAction func actionActionFiles(_ sender: UIButton) {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.data", "public.content"], in: UIDocumentPickerMode.import)
               importMenu.delegate = self
               present(importMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        self.showAlert(Message: "Homework has been uploaded successfully.")
       // _ = self.navigationController?.popViewController(animated: true)
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
