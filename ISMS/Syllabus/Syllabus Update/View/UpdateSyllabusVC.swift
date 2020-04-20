//
//  UpdateSyllabusVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class UpdateSyllabusVC: BaseUIViewController {

    
    struct ExpandableNames {
        var isExpanded : Bool
        var names : [Contact]
      
    }
    struct Contact {
        let names : String
        
   }
    var array = ["Chapter 1", "Chapter 2" , "Chapter 3", "Chapter 4" , "Chapter 5" , "Chapter 6", "Chapter 7" , "Chapter 8"]
    var arrayData = [UpdateSyllabusResultData]()
    var ClassSubjectId : Int?
    var ClassId : Int?
    var SelectedChapter = [String]()
    var isFromStudent : Bool?
    var coveredTopicData = [[String : Any]]()
  //  var sections = sectionsData

    var subjectData : SyllabusCoverageListResultData?
    var isCheck = false
    
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var lblSubjectName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblProgressPercentage: UILabel!
    
    var viewModel : UpdateSyllabusViewModel?
    
    var indexRow : Int?
    var section :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = UpdateSyllabusViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        if isFromStudent == true{
            btnUpdate.isHidden = true
        }else{
            btnUpdate.isHidden = false
        }
        
        
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
        print(UserDefaultExtensionModel.shared.currentUserId)
          print(ClassSubjectId)
           print(ClassId)
           print(coveredTopicData)
        self.viewModel?.getData(ClassSubjectId : ClassSubjectId ?? 0, ClassId :ClassId ?? 0, UserId : UserDefaultExtensionModel.shared.currentUserId , lstchaptertopiclists : coveredTopicData)
    }

}





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
        print("our cell tag : ",indexPath.row)
        let item = arrayData[indexPath.section].TopicListViewModels?[indexPath.row]
        cell.checkBox.tag = indexPath.row
        cell.nameLabel.text = item?.TopicName
        var isCover = item?.isCover
        if isCover == 0{
                cell.checkBox.setImage(UIImage(named: "uncheck"), for: .normal)
        }else{
             cell.checkBox.setImage(UIImage(named: "check"), for: .normal)
           
        }
        if isCheck == true{
             if cell.checkBox.tag == indexRow && indexPath.section == section{
                cell.checkBox.setImage(UIImage(named: "check"), for: .normal)
            }
        }else{
             if cell.checkBox.tag == indexRow && indexPath.section == section{
                cell.checkBox.setImage(UIImage(named: "uncheck"), for: .normal)
            }
           
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexRow = indexPath.row
        section = indexPath.section
        if isCheck == false {
            isCheck = true
            if coveredTopicData.count == 0{
                var data = [String:Any]()
                    
                data = ["chapterId":arrayData[indexPath.section].chapterID ?? 0 , "topicId": arrayData[indexPath.section].TopicListViewModels?[indexPath.row].TopicId ?? 0]
                print("data: ",data)
                coveredTopicData.append(data)
            }else{
                var data = [String:Any]()
                
                data = ["chapterId":arrayData[indexPath.section].chapterID ?? 0 , "topicId": arrayData[indexPath.section].TopicListViewModels?[indexPath.row].TopicId ?? 0]
                print("data: ",data)
                coveredTopicData.append(data)
                
            }
            print("our selected arraty: ",coveredTopicData)
            tableView.reloadData()
        }else{
            isCheck = false
//            for i in 0..<coveredTopicData.count{
//                if arrayData[indexPath.section].TopicListViewModels?[indexPath.row].TopicId == (coveredTopicData[i] as NSDictionary).value(forKey: "topicId") as? Int{
//                    coveredTopicData.remove(at: i)
//                }
//            }
//             print("our selected arraty delete: ",coveredTopicData)
            tableView.reloadData()
        }
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
      if array.count > 0{
        for i in 0..<arrayData.count{
            if let total = arrayData[i].TopicListViewModels{
                for j in 0..<total.count{
                    if let item = arrayData[i].TopicListViewModels?[j]{
                        if item.isCover == 1{
                            var data = [String:Any]()
                            data = ["chapterId":arrayData[i].chapterID ?? 0 , "topicId": arrayData[i].TopicListViewModels?[j].TopicId ?? 0]
                            print("data: ",data)
                            coveredTopicData.append(data)
                        }
                    }
                }
            }
            
            }
        }
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
