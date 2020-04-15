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
  //  var sections = sectionsData

    var subjectData : SyllabusCoverageListResultData?
    
    
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var lblSubjectName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblProgressPercentage: UILabel!
    
    var viewModel : UpdateSyllabusViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = UpdateSyllabusViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        lblSubjectName.text = subjectData?.subjectName
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        if let id = subjectData?.ClassSubjectId {
            self.viewModel?.GetChapterList(search : "" ,Skip : 0,  PageSize : 0 , SortColumnDir : "" , SortCoumn : "" , particularId : id)
        }
        
        
        if let percentage = subjectData?.coveragePercentage {
            
             lblProgressPercentage.text = "\(String(describing: percentage))" +  "%"
            progressBar.transform = CGAffineTransform(scaleX: 1, y: 3.0)
            progressBar.progressTintColor = UIColor(red: 183/255, green: 23/255, blue: 36/255, alpha: 1)
            //    let floatPercentage = percentage / 100
                print("your float percenage : \(percentage)")
              
                
                let morePrecisePI = Double(percentage)
                print("your more precise pi :\(morePrecisePI!)")
                let c = morePrecisePI! / 100
                print("your c : \(c)")
                progressBar.progress = Float(c)
                
            }
        
        
        if let userName = UserDefaultExtensionModel.shared.currentHODRoleName  as?  String{
                 if userName == KConstants.kHod{
                     btnUpdate.isHidden = true
                    self.title = "Syllabus Details"
                 }
    }
    }
    
    @objc func updateSyllabus(_ sender: UIButton) {
        
    }
    
    @IBAction func backbtnAction(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func ActionUpdate(_ sender: Any) {
        
        self.showAlert(alert: "Coming Soon")
        
//        var StrChapter = ""
//        var isFirst = 0
//        print("selected chapter count is : \(SelectedChapter.count)")
//        for key in SelectedChapter {
//
//            var k = ""
//
//            if isFirst == 0 {
//                isFirst = 1
//
//
//                  StrChapter.append(key)
//            }
//            else {
//                k = "," + key
//               StrChapter.append(key)
//            }
//
//
//        }
//        print("you will check here : \(StrChapter)")
//        if let classSubject = subjectData?.ClassSubjectId {
//        print("your class subject : \(classSubject)")
//        self.viewModel?.getData(StringChapterID : StrChapter, ClassSubject :classSubject, classId : 1 , userID : 295)
//       }
    }

}



//extension UpdateSyllabusVC : UITableViewDelegate, UITableViewDataSource , UpdateSyllabusTableViewCellDelegate {
//
//
//    func didPressButton(_ tag: Int) {
//
//        if arrayData[tag].isSelected == 0{
//            arrayData[tag].isSelected = 1
//            //add value
//            if let chapterID = arrayData[tag].chapterID {
//                let id = "\(chapterID)"
//            SelectedChapter.append(id)
//            }
//        }else{
//            print("tag count : \(tag)")
//            print("array data count : \(SelectedChapter.count)")
//            //  SelectedChapter.remove(at: count)
//            arrayData[tag].isSelected = 0
//           //remove value
//        }
//
////        _ = arrayData.enumerated().map({ (index,value) in
////            if index != tag{
////                arrayData[index].isSelected = 0
////            }
////        })
//
//        tableView.reloadData()
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrayData.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UpdateSyllabusTableViewCell
//        cell.cellDelegate = self
//        cell.btnCheckBox.tag = indexPath.row
//        if let chapterName = arrayData[indexPath.row].chapterName {
//        cell.lblTopic.text = chapterName
//        }
//        if  arrayData[indexPath.row].isSelected == 0{
//            let check = UIImage.init(named: "uncheck")
//            cell.btnCheckBox.setImage(check, for: .normal)
//
//        }
//        else {
//            let check = UIImage.init(named: "check")
//            cell.btnCheckBox.setImage(check, for: .normal)
//        }
////        let check = UIImage.init(named: "uncheck")
////        cell.btnCheckBox.setImage(check, for: .normal)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 1.0
//    }
//
//     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView()
//        var separatorView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
//        separatorView.backgroundColor = UIColor.separatorColor
//        footerView.addSubview(separatorView)
//
//        return separatorView
//    }
//
//
//
//
//
//
//}


//
// MARK: - View Controller DataSource and Delegate
//
extension UpdateSyllabusVC : UITableViewDelegate, UITableViewDataSource {

     func numberOfSections(in tableView: UITableView) -> Int {
        return arrayData.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData[section].collapsed ?? false ? 0 : arrayData[section].TopicListViewModels?.count ?? 0
    }
    
    // Cell
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsibleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CollapsibleTableViewCell ??
            CollapsibleTableViewCell(style: .default, reuseIdentifier: "cell")
        
        let item = arrayData[indexPath.section].TopicListViewModels?[indexPath.row]
        cell.checkBox.tag = indexPath.row
        cell.nameLabel.text = item?.TopicName
        cell.checkBox.addTarget(self, action: #selector(self.updateSyllabus), for: .touchUpInside)
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // Header
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = arrayData[section].chapterName
        header.arrowLabel.text = ">"
        header.setCollapsed(arrayData[section].collapsed ?? false)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

}

//
// MARK: - Section Header Delegate
//
extension UpdateSyllabusVC: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !(arrayData[section].collapsed ?? false)
        
        // Toggle collapse
        arrayData[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
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
