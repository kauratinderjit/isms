//
//  UpdateSyllabusVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class UpdateSyllabusVC: UIViewController {

    
    struct ExpandableNames {
        var isExpanded : Bool
        var names : [Contact]
      
    }
    struct Contact {
        let names : String
        
   }
    var array = ["Chapter 1", "Chapter 2" , "Chapter 3", "Chapter 4" , "Chapter 5" , "Chapter 6", "Chapter 7" , "Chapter 8"]
    var arrayData = [UpdateSyllabusResultData]()
    var SelectedChapter = [String]()
    var classSubjectID : Int?
    
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var lblSubjectName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblProgressPercentage: UILabel!
    
    var viewModel : UpdateSyllabusViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = UpdateSyllabusViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        lblSubjectName.text = "Chemistry"
        
        if let id = classSubjectID {
            self.viewModel?.GetChapterList(search : "" ,Skip : 0,  PageSize : 0 , SortColumnDir : "" , SortCoumn : "" , particularId : id)
        }
        
        
        lblProgressPercentage.text = "\(50)" +  "%"
        progressBar.transform = CGAffineTransform(scaleX: 1, y: 3.0)
        progressBar.progressTintColor = UIColor(red: 183/255, green: 23/255, blue: 36/255, alpha: 1)
    }
    
    
  
    @IBAction func ActionUpdate(_ sender: Any) {
        
        var StrChapter = ""
        var isFirst = 0
        print("selected chapter count is : \(SelectedChapter.count)")
        for key in SelectedChapter {
            
            var k = ""

            if isFirst == 0 {
                isFirst = 1


                  StrChapter.append(key)
            }
            else {
                k = "," + key
               StrChapter.append(key)
            }
            
          
        }
        print("you will check here : \(StrChapter)")
       if let classSubject = classSubjectID {
        print("your class subject : \(classSubject)")
        self.viewModel?.getData(StringChapterID : StrChapter, ClassSubject :classSubject, classId : 1 , userID : 295)
       }
    }
    

   

}



extension UpdateSyllabusVC : UITableViewDelegate, UITableViewDataSource , UpdateSyllabusTableViewCellDelegate {
    
    
    func didPressButton(_ tag: Int) {
        
        if arrayData[tag].isSelected == 0{
            arrayData[tag].isSelected = 1
            //add value
            if let chapterID = arrayData[tag].chapterID {
                let id = "\(chapterID)"
            SelectedChapter.append(id)
            }
        }else{
            print("tag count : \(tag)")
            print("array data count : \(SelectedChapter.count)")
            //  SelectedChapter.remove(at: count)
            arrayData[tag].isSelected = 0
           //remove value
        }
        
//        _ = arrayData.enumerated().map({ (index,value) in
//            if index != tag{
//                arrayData[index].isSelected = 0
//            }
//        })
 
        tableView.reloadData()
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UpdateSyllabusTableViewCell
        cell.cellDelegate = self
        cell.btnCheckBox.tag = indexPath.row
        if let chapterName = arrayData[indexPath.row].chapterName {
        cell.lblTopic.text = chapterName
        }
        if  arrayData[indexPath.row].isSelected == 0{
            let check = UIImage.init(named: "uncheck")
            cell.btnCheckBox.setImage(check, for: .normal)
            
        }
        else {
            let check = UIImage.init(named: "check")
            cell.btnCheckBox.setImage(check, for: .normal)
        }
//        let check = UIImage.init(named: "uncheck")
//        cell.btnCheckBox.setImage(check, for: .normal)
       
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        var separatorView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        separatorView.backgroundColor = UIColor.separatorColor
        footerView.addSubview(separatorView)
        
        return separatorView
    }
    
  
    
    
    
    
}

extension UpdateSyllabusVC : UpdateSyllabusDelegate {
    func UpdateSyllabusSucceed(array: [UpdateSyllabusResultData] ) {
        arrayData = array
        tableView.reloadData()
    }
    
    func UpdateSyllabusFailour(msg: String) {
        self.showAlert(Message: msg)
    }
    
    
    
    
}
extension UpdateSyllabusVC : ViewDelegate {
    
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
extension UIColor {
    class var separatorColor: UIColor {
        return UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
}
