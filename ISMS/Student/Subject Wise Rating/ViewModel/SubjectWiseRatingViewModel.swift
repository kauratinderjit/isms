//
//  SubjectWiseRatingViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/4/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol SubjectWiseRatingDelegate : class {
    func SubjectWiseRatingDidSucceed(data : [SubjectWiseRatingResultData])
    func SubjectWiseRatingDidFailour()


}

class SubjectWiseRatingViewModel {
    
    var isSearching : Bool?
    private weak var subjectWiseRatingView : ViewDelegate?
    private  weak var subjectWiseRatingDelegate: SubjectWiseRatingDelegate?
    
    
    init(delegate : SubjectWiseRatingDelegate) {
        self.subjectWiseRatingDelegate = delegate
    }
    
    func attachView(viewDelegate : ViewDelegate){
        subjectWiseRatingView = viewDelegate
    }
    
//    func createLabel(x: CGFloat, y: CGFloat, text: String) {
//        let label = UILabel(frame: CGRectMake(x, y, 100, 25))
//        label.text = text
//        view.addSubview(label)
//    }
//
    
    
    //MARK:- SUBJECT LIST
    func getSubjectWiseRating(enrollmentsId : Int?,classId: Int?){
        self.subjectWiseRatingView?.showLoader()
       
        let paramDict = [ "EnrollmentId": enrollmentsId!,
                           "ClassId" : classId!
                         ] as [String : Any]
        
        AddStudentRatingApi.sharedInstance.SubmitApiList(url: ApiEndpoints.kGetSubjectWiseRating, parameters: paramDict, completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.subjectWiseRatingView?.hideLoader()
        self.subjectWiseRatingDelegate?.SubjectWiseRatingDidSucceed(data: SubjectListModel.resultData!)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.subjectWiseRatingView?.hideLoader()
                self.subjectWiseRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.subjectWiseRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.subjectWiseRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.subjectWiseRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.subjectWiseRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.addStudentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
    }
}


extension SubjectWiseRatingVC : UITableViewDataSource  {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 105
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //    return arrSkillList.count
        return arrSubjectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubjectWiseRating.kSubjectSkillRatingCell, for: indexPath) as! SubjectWiseRatingTableViewCell
        
      
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
      //        cell.lblPercentage.text = "97 %"
        return cell
    }  
  
}
extension SubjectWiseRatingVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Teacher", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeacherSubjectSkillRatingVC") as! SubjectSkillRatingVC
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
