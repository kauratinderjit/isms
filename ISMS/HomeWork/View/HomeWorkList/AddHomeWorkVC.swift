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
    
    
    @IBOutlet weak var txtfieldSubmissionDate: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnAddNote: UIButton!
    @IBOutlet weak var txtfieldClass: UITextField!
    @IBOutlet weak var txtfieldSubject: UITextField!
    @IBOutlet weak var txtfieldTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    func setUp() {
        self.title = "Add Homework"
        tblView.tableFooterView = UIView()
        setDatePickerView(self.view, type: .date)
         setPickerView()
    }
    
    func classListDropdownApi(){
        if checkInternetConnection(){
            self.viewModel?.getClassListDropdown(selectId: 1, enumType: CountryStateCity.classes.rawValue)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //MARK:- SET UP PICKER VIEW
      func setPickerView(){
          pickerView.delegate = self as! UIPickerViewDelegate
          pickerView.dataSource = self as! UIPickerViewDataSource
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
          txtfieldExtraPicker.inputView = pickerView
          txtfieldExtraPicker.inputAccessoryView = toolBar
      }
      @objc func doneClick() {
        
          if let text = textfieldClass.text {
             lastText = text
             
               
                  arrayData.removeAll()
                  
                  if let index = classDropdownData?.index(where: { (dict) -> Bool in
                      return dict.name == text // Will found index of matched id
                  }) {
                      print("Index found :\(index)")
                      let total = classDropdownData?[index].id ?? 0
                       self.viewModel?.getData(teacherId: 0, classID: total)
                  }
                  
                  
              
             
          }
          txtfieldExtraPicker.resignFirstResponder()
      }
      @objc func cancelClick() {
          
          if let text1 = lastText {
            textfieldClass.text = text1
              }
          else  {
              txtfieldClass.text = classDropdownData?[0].name
          }
          txtfieldExtraPicker.resignFirstResponder()
          
      }
    
    
    @IBAction func actionSelectClass(_ sender: UIButton) {
    }
    
    
    
    @IBAction func actionSelectSubjet(_ sender: UIButton) {
    }
    
    
    
    @IBAction func actionSelectSubmissionDate(_ sender: UIButton) {
        showDatePicker(datePickerDelegate: self)

    }
    
    @IBAction func attachFiles(_ sender: UIButton) {
        
      let importMenu = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", kUTTypePDF as String], in: UIDocumentPickerMode.import)
        importMenu.delegate = self
        present(importMenu, animated: true, completion: nil)
    }
    
    @IBAction func actionAddNotes(_ sender: UIButton) {
        
        
    }
    
    @IBAction func actionDelNotes(_ sender: UIButton) {
    }
    
}


extension AddHomeWorkVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddNotesCell
        return cell
    }
  
    
}

extension AddHomeWorkVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
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
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePicker.date)
        
        txtfieldSubmissionDate.text = strDate
    }
}


//MARK: - Picker Datasource and delegate
extension AddHomeWorkVC {
    
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classDropdownData?.count ?? 0
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
             let dic = classDropdownData?[row]
        let title = dic?.name
        return "\(String(describing: title!))"
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print("you printed row here : \(row)")
        if txtfieldExtraPicker.isFirstResponder{
                 let dic = classDropdownData?[row]
                       let title = dic?.name
            txtfieldClass.text = "\(String(describing: title!))"
        }
    }
}
