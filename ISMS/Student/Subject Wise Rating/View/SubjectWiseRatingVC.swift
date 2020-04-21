//
//  SubjectWiseRatingVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/4/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SubjectWiseRatingVC: BaseUIViewController {

    var viewModel : SubjectWiseRatingViewModel?
    var array = [1,2,3,4,5,6,7,8,9]
    var arrSubjectList = [SubjectWiseRatingResultData]()
     var subjectName : String?
    
    @IBOutlet var tableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.viewModel = SubjectWiseRatingViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        tableView.reloadData()
        // Do any additional setup after loading the view.
        self.viewModel?.getSubjectWiseRating(enrollmentsId: 7, classId: 1)
    }
  
    
}
extension SubjectWiseRatingVC : UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //    return arrSkillList.count
        return arrSubjectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubjectWiseRating.kSubjectWiseRatingCell, for: indexPath) as! SubjectWiseRatingTableViewCell
        if arrSubjectList.count > 0{
            if let subjectName = arrSubjectList[indexPath.row].Name {
                cell.lblSubjectName.text = subjectName
                let text = subjectName
                let getFirstCharacter = text.characters.first
                print("print your first getFirstCharacter : \(getFirstCharacter)")
                cell.lblFirstChar.text = "\(getFirstCharacter!)"
            }
            if let percentage = arrSubjectList[indexPath.row].rating {
                cell.lblPercentage.text = percentage
                
            }
        }
        
        
        //        cell.lblPercentage.text = "97 %"
        return cell
    }
    
}
extension SubjectWiseRatingVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let storyboard = UIStoryboard.init(name: "Student", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubjectSkillRatingVC") as! SubjectSkillRatingVC
        if arrSubjectList.count > 0{
             self.subjectName = arrSubjectList[indexPath.row].Name
               vc.subjectName = self.subjectName
        }
     
        //        if let id = arrSubjectList[indexPath.row].ClassSubjectId {
        //            print("your value printed : \(id)")
        //            vc.classId = id
        //        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension SubjectWiseRatingVC : SubjectWiseRatingDelegate {
    func SubjectWiseRatingDidSucceed(data: [SubjectWiseRatingResultData]) {
        arrSubjectList = data
        tableView.reloadData()
    }
    
    
    
    func SubjectWiseRatingDidFailour() {
        print("")
    }
    
}

extension SubjectWiseRatingVC : ViewDelegate {
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }
    func showLoader() {
        ShowLoader()
    }
    func hideLoader() {
        HideLoader()
    }
    //MARK:- SET UI
    func setUI(){
        //Set Back Button
        self.setBackButton()
        //Set picker view
        self.SetpickerView(self.view)
        // cornerButton(btn: btnSubmit, radius: 8)
        //Title
        self.title = KStoryBoards.KClassListIdentifiers.kClassListTitle
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.viewModel?.isSearching = false
    }
}

extension SubjectWiseRatingVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
    }
    
    
}
