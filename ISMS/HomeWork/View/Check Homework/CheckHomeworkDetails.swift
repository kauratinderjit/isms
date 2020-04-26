//
//  CheckHomeworkDetails.swift
//  ISMS
//
//  Created by Mohit Sharma on 4/26/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class CheckHomeworkDetails: BaseUIViewController
{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var lblPlaceHolderComment: UILabel!
    @IBOutlet weak var tblViewListing: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    var homeWorkDetails : HomeworkResultData?
    let documentInteractionController = UIDocumentInteractionController()
    
    
    var uploadData = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // heightTableView.constant = 0
        
        
        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setUI()
    {
        self.txtViewComment.text = homeWorkDetails?.Comment
        self.lblPlaceHolderComment.text = ""
        
        let dicnry = NSMutableDictionary()
        dicnry.setValue(self.homeWorkDetails?.StudentAttacmentUrl, forKey: "fileName")
        self.uploadData.add(dicnry)
        self.tblViewListing.reloadData()
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionActionFiles(_ sender: UIButton)
    {
        //let importMenu = UIDocumentPickerViewController(documentTypes: ["public.data", "public.content"], in: UIDocumentPickerMode.import)
        //importMenu.delegate = self
        // present(importMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func actionSubmit(_ sender: UIButton)
    {
        //  self.showAlert(Message: "Homework has been uploaded successfully.")
        // _ = self.navigationController?.popViewController(animated: true)
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
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.share(url: tmpURL)
                
               
            }
        }.resume()
    }
    
    func openDoc(file:String)
    {
        //let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: file))
       // dc.delegate = self
       // dc.presentPreview(animated: true)
    }
    
    func share(url: URL)
    {
       // documentInteractionController.url = url
       // documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
       // documentInteractionController.name = url.localizedName ?? url.lastPathComponent
       // documentInteractionController.presentPreview(animated: true)
        
        let pdfFilePath = URL(string: url.absoluteString)
        let pdfData = NSData(contentsOf: pdfFilePath!)
        let activityVC = UIActivityViewController(activityItems: [pdfData!], applicationActivities: nil)

        present(activityVC, animated: true, completion: nil)
    }
}


extension CheckHomeworkDetails:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        lblPlaceHolderComment.isHidden = true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        
        let str = textView.text.trimmingCharacters(in: .whitespaces)
        
        if str == ""
        {
            self.txtViewComment.text = ""
            lblPlaceHolderComment.isHidden = false
            
        }
        else
        {
            self.txtViewComment.text = textView.text
        }
        
        
    }
    
    
    //MARK: UIDocumentInteractionController delegates
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self//or use return self.navigationController for fetching app navigation bar colour
    }
    
}


extension CheckHomeworkDetails: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
    {
        guard let myURL = urls.first else
        {
            return
        }
        
        if uploadData.count <= 5
        {
            
            if uploadData.count > 0
            {
                
                _ = uploadData.enumerated().map { (index,element) in
                    
                    let dd = element as? [String:Any]
                    if dd?["fileName"] as? String == myURL.lastPathComponent
                    {
                        self.showAlert(Message: "You have already selected this file.")
                    }
                        
                    else
                    {
                        var modelHW = [String: Any]()
                        modelHW["url"] = myURL
                        modelHW["fileName"] = myURL.lastPathComponent
                        modelHW["id"] = 0
                        uploadData.add(modelHW)
                    }
                }
                
            }
                
                
            else
            {
                var modelHW = [String: Any]()
                modelHW["url"] = myURL
                modelHW["fileName"] = myURL.lastPathComponent
                modelHW["id"] = 0
                uploadData.add(modelHW)
            }}
        else
        {
            self.showAlert(Message: "Maximum limit to upload the document is 5.")
        }
        
        
        heightTableView.constant  = CGFloat(uploadData.count * 51)
        self.tblViewListing.reloadData()
        print("import result : \(myURL)")
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController)
    {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
    {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
extension CheckHomeworkDetails : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return uploadData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddNotesCell
        cell.btnDel.tag = indexPath.row
        
        let dic = uploadData[indexPath.row] as? [String:Any]
        cell.lblAttachment.text = dic?["fileName"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dic = uploadData[indexPath.row] as? [String:Any]
        let path = dic?["fileName"] as? String ?? ""
        
        if (path.count > 0)
        {
            if (path.contains(".pdf"))
            {
                self.storeAndShare(withURLString: path)
            }
            else
            {
                self.showAlert(Message: "File format is not in PDF")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    
}



