//
//  SyllabusCoverageVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SyllabusCoverageVC : UIViewController  {
 
    @IBOutlet var textfieldClass: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var txtfieldExtraPicker: UITextField!
    
    var array = ["Chemistry", "Physics", "Biology" ,"Maths", "Geography", "Economics"]
    var arrayprog = [0.8, 0.6]
    var arrPicker = ["I","II","III","IV","V","VI", "VII", "VIII", "IX", "X"]
    var lastText : String?
    private var pickerView = UIPickerView()
    enum PickerTypes: Int {
        case statePicker = 1
    }
    var viewModel     : SyllabusCoverageViewModel?
    
    var arrayData = [SyllabusCoverageListResultData]()
    
    //MARK:- OVERRIDE CLASS FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = SyllabusCoverageViewModel.init(delegate: self)
       self.viewModel?.attachView(viewDelegate: self)
        setPickerView()
        
        self.viewModel?.getData(teacherId: 0, classID: 10)
    
     //   tableView.allowsSelection = false
        tableView.reloadData()
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
                
                if let index = arrPicker.index(where: { (dict) -> Bool in
                    return dict == text // Will found index of matched id
                }) {
                    print("Index found :\(index)")
                   let total = index + 1
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
            textfieldClass.text = arrPicker[0]
        }
        txtfieldExtraPicker.resignFirstResponder()
        
    }
    
    //MARK:- ACTION PICKER
    @IBAction func ActionClassPicker(_ sender: UIButton) {
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.reloadAllComponents()
        pickerView.reloadComponent(0)
        
        if   textfieldClass.text!  == ""{
            textfieldClass.text = arrPicker[0]
              self.txtfieldExtraPicker.becomeFirstResponder()
        }
          else {
               let text = textfieldClass.text!
                if let index = arrPicker.index(where: { (dict) -> Bool in
                    return dict == text // Will found index of matched id
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
        if let id = arrayData[indexPath.row].classSubjectId {
               vc.classSubjectID = id
        }
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
        cell.progressBar.layer.cornerRadius = 6.0
        cell.progressBar.transform = CGAffineTransform(scaleX: 1, y: 3.0)
        cell.progressBar.progressTintColor = UIColor(red: 183/255, green: 23/255, blue: 36/255, alpha: 1)
         if let percentage = arrayData[indexPath.row].coveragePercentage {
      cell.lblprogressPercentage.text = "\(percentage)" + "%"
        }
        
            
             if let percentage = arrayData[indexPath.row].coveragePercentage {
                 cell.lblprogressPercentage.text = "\(percentage)" + "%"
                if percentage == "100" {
        cell.progressBar.progressTintColor =  UIColor(red: 14/255, green: 164/255, blue: 67/255, alpha: 1)
                }
        
        }
       return cell
    }
    
    
    
}

//MARK: - Picker Datasource and delegate
extension SyllabusCoverageVC : UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
             let dic = arrPicker[row]
            let title = dic
            return "\(title)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print("you printed row here : \(row)")
        if txtfieldExtraPicker.isFirstResponder{
                let dic = arrPicker[row]
                let title = dic
            textfieldClass.text = "\(title)"
        }
    }
}


extension SyllabusCoverageVC : SyllabusCoverageDelegate {


func SyllabusCoverageSucceed(array: [SyllabusCoverageListResultData]) {
   // self.showAlert(Message: "Good")
    arrayData = array
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
