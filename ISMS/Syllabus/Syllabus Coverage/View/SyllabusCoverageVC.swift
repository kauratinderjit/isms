//
//  SyllabusCoverageVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SyllabusCoverageVC : BaseUIViewController  {
 
    @IBOutlet weak var lblNoRecordFound: UILabel!
    @IBOutlet var textfieldClass: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var txtfieldExtraPicker: UITextField!
    var classDropdownData : [GetCommonDropdownModel.ResultData]?
    var lastText : String?
    private var pickerView = UIPickerView()
    enum PickerTypes: Int {
        case statePicker = 1
    }
    var viewModel     : SyllabusCoverageViewModel?
    var selectedClassId:Int?
    var arrayData = [SyllabusCoverageListResultData]()
    var boolFirstTime = false
    @IBOutlet weak var viewBehindClass: UIView!
    
    
    //MARK:- OVERRIDE CLASS FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = SyllabusCoverageViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        setPickerView()
        boolFirstTime = true
         self.classListDropdownApi()
        //self.viewModel?.getData(teacherId: 0, classID: 10)
        setBackButton()
     //   tableView.allowsSelection = false
        tableView.reloadData()
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
            textfieldClass.text = classDropdownData?[0].name
        }
        txtfieldExtraPicker.resignFirstResponder()
        
    }
    
    //MARK:- ACTION PICKER
    @IBAction func ActionClassPicker(_ sender: UIButton) {
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.reloadAllComponents()
        pickerView.reloadComponent(0)
        
        if   textfieldClass.text!  == ""{
            textfieldClass.text = classDropdownData?[0].name
              self.txtfieldExtraPicker.becomeFirstResponder()
        }
          else {
               let text = textfieldClass.text!
                if let index = classDropdownData?.index(where: { (dict) -> Bool in
                    return dict.name == text // Will found index of matched id
                }) {
                    print("Index found :\(index)")
                     pickerView.selectRow(index, inComponent: 0, animated: true)
                    self.txtfieldExtraPicker.becomeFirstResponder()
                }
          }
      }
 }

extension SyllabusCoverageVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Courses", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateSyllabusVC") as! UpdateSyllabusVC
            vc.subjectData = arrayData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- TABLE VIEW DATA SOURCE
extension SyllabusCoverageVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SyllabusCoverage.kCell, for: indexPath) as! SyllabusCoverageTableViewCell
        if let subjectName = arrayData[indexPath.row].subjectName {
        cell.lblSubjectName.text = subjectName
        }
        
        if let percentage = arrayData[indexPath.row].coveragePercentage {
        //    let floatPercentage = percentage / 100
            print("your float percenage : \(percentage)")
          
            
            let morePrecisePI = Double(percentage)
            print("your more precise pi :\(morePrecisePI!)")
            let c = morePrecisePI! / 100
            print("your c : \(c)")
            cell.progressBar.progress = Float(c)
            
        }
      //  cell.progressBar.transform.scaledBy(x: 1, y: 9)
        //cell.progressBar.layer.cornerRadius = 6.0
      cell.progressBar.transform = CGAffineTransform(scaleX: 1, y: 3.0)
        cell.progressBar.progressTintColor = UIColor(red: 183/255, green: 23/255, blue: 36/255, alpha: 1)

         if let percentage = arrayData[indexPath.row].coveragePercentage {
      cell.lblprogressPercentage.text = "\(percentage)" + "%"
        }
        
            
             if let percentage = arrayData[indexPath.row].coveragePercentage {
                 cell.lblprogressPercentage.text = "\(percentage)" + "%"
                if percentage == "100" {
        cell.progressBar.progressTintColor = UIColor(red: 183/255, green: 23/255, blue: 36/255, alpha: 1)
                }
        
        }
       return cell
    }
    
    
    
}

//MARK: - Picker Datasource and delegate
extension SyllabusCoverageVC {
    
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
            textfieldClass.text = "\(String(describing: title!))"
        }
    }
}


extension SyllabusCoverageVC : SyllabusCoverageDelegate {
    func classListDidFailed() {
        
    }
    

       
       func classListDidSuccess(data: GetCommonDropdownModel)
       {
           if data.resultData != nil{
               if data.resultData?.count ?? 0 > 0{
              
                classDropdownData = data.resultData
                   textfieldClass.text = data.resultData?[0].name
                   selectedClassId = data.resultData?[0].id
                
                if boolFirstTime == true {
                boolFirstTime = false
                    self.viewModel?.getData(teacherId: 0, classID: selectedClassId ?? 0)}

               }else{
                    
                   CommonFunctions.sharedmanagerCommon.println(object: "Count is zero.")
               }
           }
    }
    

func SyllabusCoverageSucceed(array: [SyllabusCoverageListResultData]) {
   // self.showAlert(Message: "Good")
    arrayData = array
        if arrayData.count > 0{
         lblNoRecordFound.isHidden = true
         tableView.isHidden = false
         
        }else{
             tableView.isHidden = true
            lblNoRecordFound.isHidden = false
            CommonFunctions.sharedmanagerCommon.println(object: "Count is zero.")
        }
    
    
    
    tableView.reloadData()
}

func SyllabusCoverageFailour(msg: String) {
  self.showAlert(Message: msg)
}

}


extension SyllabusCoverageVC : ViewDelegate {
    
    func showAlert(alert: String) {
        print("your error : \(alert)")
        self.showAlert(Message: alert)
    }
    
    func showLoader() {
         ShowLoader()
    }
    
    func hideLoader() {
       HideLoader()
    }
    
    
}

