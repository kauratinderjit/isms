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
    var firstRun = 1
    var coveredTopicData = [[String : Any]]()
  //  var sections = sectionsData

    var subjectData : SyllabusCoverageListResultData?
    var isCheck = false
    
    @IBOutlet weak var tableBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var lblSubjectName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblProgressPercentage: UILabel!
    
    var viewModel : UpdateSyllabusViewModel?
    
    var indexRow : Int?
    var section :Int?
    var indexPath :  IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = UpdateSyllabusViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        if UserDefaultExtensionModel.shared.currentUserRoleId == 5{
             btnUpdate.isHidden = true
            self.title = "Syllabus Coverage"
            tableBottomConstraints.constant = -80
        }else if UserDefaultExtensionModel.shared.currentUserRoleId == 6{
            btnUpdate.isHidden = true
            self.title = "Syllabus Coverage"
            tableBottomConstraints.constant = -80
        }else if isFromStudent == true {
            btnUpdate.isHidden = true
            self.title = "Syllabus Coverage"
            tableBottomConstraints.constant = -80
        }else{
            btnUpdate.isHidden = false
            self.title = "Update Syllabus"
            tableBottomConstraints.constant = 24
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
            progressBar.cornerRadius = progressBar.layer.fs_height / 2
            progressBar.clipsToBounds = true
            progressBar.transform = CGAffineTransform(scaleX: 1, y: 3.0)
            progressBar.progressTintColor = KAPPContentRelatedConstants.kThemeColour//UIColor(red: 183/255, green: 23/255, blue: 36/255, alpha: 1)
            //    let floatPercentage = percentage / 100
                print("your float percenage : \(percentage)")
            if percentage < 100 && percentage > 0{
                progressBar.progressTintColor =  UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
            }else if percentage == 100{
                progressBar.progressTintColor =  UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
            }else if percentage == 0{
                progressBar.progressTintColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            }
                
                let morePrecisePI = Double(percentage)
            print("your more precise pi :\(morePrecisePI)")
            let c = morePrecisePI / 100
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
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        tableView.delegate?.tableView!(tableView, didSelectRowAt: self.indexPath!)
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
        
        if arrayData.count > 0{
            tableView.separatorStyle = .singleLine
            return (arrayData.count)
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
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
        self.indexPath = indexPath
        var isCover = item?.isCover
        if firstRun == 1{
            if isCover == 0{
                cell.checkBox.setImage(UIImage(named: "uncheck"), for: .normal)
            }else{
                cell.checkBox.setImage(UIImage(named: "check"), for: .normal)
                
            }
        }
        if UserDefaultExtensionModel.shared.currentUserRoleId == 5{
            
        }else if UserDefaultExtensionModel.shared.currentUserRoleId == 6{
            
        }else if isFromStudent == false{
            if isCheck == true{
                if cell.checkBox.tag == indexRow && indexPath.section == section{
                    cell.checkBox.setImage(UIImage(named: "check"), for: .normal)
                }
            }else{
                if cell.checkBox.tag == indexRow && indexPath.section == section{
                    cell.checkBox.setImage(UIImage(named: "uncheck"), for: .normal)
                }
                
            }
        }
//        cell.checkBox.addTarget(self, action: #selector(self.updateSyllabus), for: .touchUpInside)
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
        if arrayData[section].chapterStatus ==  "Completed"{
            header.contentView.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
            header.titleLabel.textColor = UIColor.white
        }
        if arrayData[section].chapterStatus ==  "Inprocess"{
             header.contentView.backgroundColor =  UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
            header.titleLabel.textColor = UIColor.white
        }
        if arrayData[section].chapterStatus ==  ""{
              header.contentView.backgroundColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            header.titleLabel.textColor = UIColor.white
        }
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
        if UserDefaultExtensionModel.shared.currentUserRoleId == 5{
        }else if UserDefaultExtensionModel.shared.currentUserRoleId == 6{
        }else if isFromStudent == false {
        indexRow = indexPath.row
        section = indexPath.section
        firstRun = 2
        let item = arrayData[indexPath.section].TopicListViewModels?[indexPath.row]
        if isCheck == false {
            isCheck = true
            if coveredTopicData.count > 0{
                for i in 0..<coveredTopicData.count{
                    if i<coveredTopicData.count{
                        if item?.TopicId == (coveredTopicData[i] as NSDictionary).value(forKey: "topicId") as? Int{
                            coveredTopicData[i]["IsCover"] = true
                        }
                        
                    }
                }
            }
            print("our selected arraty: ",coveredTopicData)
            tableView.reloadData()
        }else{
            isCheck = false
            if coveredTopicData.count > 0{
                for i in 0..<coveredTopicData.count{
                    if i<coveredTopicData.count{
                        if item?.TopicId == (coveredTopicData[i] as NSDictionary).value(forKey: "topicId") as? Int{
                            coveredTopicData[i]["IsCover"] = false
                        }
                        
                    }
                }
              
            }
             print("our selected arraty delete: ",coveredTopicData)
            tableView.reloadData()
            }
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
                                data = ["chapterId":arrayData[i].chapterID ?? 0 , "topicId": arrayData[i].TopicListViewModels?[j].TopicId ?? 0,"IsCover":true]
                                print("data: ",data)
                                coveredTopicData.append(data)
                            }else{
                                var data = [String:Any]()
                                data = ["chapterId":arrayData[i].chapterID ?? 0 , "topicId": arrayData[i].TopicListViewModels?[j].TopicId ?? 0,"IsCover":false]
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
        //self.showAlert(Message: alert)
        
        self.AlertMessageWithOkAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: alert, Target: self) {
            self.navigationController?.popViewController(animated: false)
        }
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
