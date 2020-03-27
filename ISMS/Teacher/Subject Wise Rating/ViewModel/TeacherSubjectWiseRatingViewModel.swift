//
//  TeacherSubjectWiseRatingViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol TeacherSubjectWiseRatingDelegate : class {
    func TeacherSubjectWiseRatingDidSucceed(data : [TeacherSubjectWiseRatingResultData])
    func TeacherSubjectWiseRatingDidFailour()
    
    
}

class TeacherSubjectWiseRatingViewModel {
    
    var isSearching : Bool?
    private weak var teacherSubjectWiseRatingView : ViewDelegate?
    private  weak var teacherSubjectWiseRatingDelegate: TeacherSubjectWiseRatingDelegate?
    
    
    init(delegate : TeacherSubjectWiseRatingDelegate) {
        self.teacherSubjectWiseRatingDelegate = delegate
    }
    
    func attachView(viewDelegate : ViewDelegate){
        teacherSubjectWiseRatingView = viewDelegate
    }
    
    //    func createLabel(x: CGFloat, y: CGFloat, text: String) {
    //        let label = UILabel(frame: CGRectMake(x, y, 100, 25))
    //        label.text = text
    //        view.addSubview(label)
    //    }
    //
    
    
    //MARK:- SUBJECT LIST
    func getSubjectWiseRating(enrollmentsId : Int?,classId: Int?){
        self.teacherSubjectWiseRatingView?.showLoader()
        
        let paramDict = [
            "TeacherId": enrollmentsId!,
            "ClassId": classId!
    
            ] as [String : Any]
        
        TeacherSubjectWiseRatingApi.sharedInstance.SubjectWiseList(url: ApiEndpoints.kGetTeacherSubjectWiseRating, parameters: paramDict, completionResponse: { (SubjectListModel) in
    
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.teacherSubjectWiseRatingView?.hideLoader()
                self.teacherSubjectWiseRatingDelegate?.TeacherSubjectWiseRatingDidSucceed(data: SubjectListModel.resultData!)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.teacherSubjectWiseRatingView?.hideLoader()
                self.teacherSubjectWiseRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.teacherSubjectWiseRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.teacherSubjectWiseRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.teacherSubjectWiseRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.teacherSubjectWiseRatingView?.hideLoader()
          
        }
        
    }
}
extension TeacherSubjectWiseRatingVC : UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Teacher", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeacherSubjectSkillRatingVC") as! TeacherSubjectSkillRatingVC
        if let id = arrSubjectList[indexPath.row].ClassSubjectId {
            print("your value printed : \(id)")
        vc.classId = id
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension TeacherSubjectWiseRatingVC : UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 105
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //    return arrSkillList.count
        return arrSubjectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubjectWiseRating.kTeacherSubjectSkillRatingCell, for: indexPath) as! TeacherSubjectWiseRatingTableViewCell
      
        if let subjectName = arrSubjectList[indexPath.row].Name {
            cell.lblSubjectName.text = subjectName
            let text = subjectName
            let getFirstCharacter = text.characters.first
            print("print your first getFirstCharacter : \(getFirstCharacter)")
            cell.lblFirstChar.text = "\(getFirstCharacter!)"
        }
        if let percentage = arrSubjectList[indexPath.row].rating {
            cell.lblPercentage.text = percentage + "%"
        }
        //        cell.lblPercentage.text = "97 %"
        return cell
    }
    
}
extension TeacherSubjectWiseRatingVC : TeacherSubjectWiseRatingDelegate {
  

    func TeacherSubjectWiseRatingDidSucceed(data: [TeacherSubjectWiseRatingResultData]) {
        arrSubjectList = data
        tableView.reloadData()
    }
    
    
    
    func TeacherSubjectWiseRatingDidFailour() {
        print("")
    }
    
}

extension TeacherSubjectWiseRatingVC : ViewDelegate {
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

extension TeacherSubjectWiseRatingVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
    }
    
    
}
