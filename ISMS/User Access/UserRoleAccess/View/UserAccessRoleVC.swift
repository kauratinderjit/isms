//
//  UserAccessVCViewController.swift
//  ISMS
//
//  Created by Poonam Sharma on 6/21/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class UserAccessRoleVC: BaseUIViewController {

    //MARK:- Variables
    var viewModel                   : UserAccessViewModel?
    let kHeaderSectionTag           = 1
    var expandedSectionHeaderNumber = -1
    var expandedSectionHeader       : UITableViewHeaderFooterView!
    var sectionItems                = [UserAccesstModel.lstActionAccessData]()
    var sectionNames                = [UserAccesstModel.lstPageAccessData]()
    var actionIds                   = [String]()
    var pageIds                     = [String]()
    var sectionForbutton = Int()
    var userId : Int?
    var roleId : Int?
    var isUserAccessUpdateSuccess = false
    var isUnauthorizedUser = false
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnUpdate: UIButton!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserAccessList()
    }
    
    //Get user Access List
    func getUserAccessList(){
        if checkInternetConnection(){
            self.viewModel?.GetUserAccessList(userId: userId ?? 0, roleId: roleId ?? 0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    //MARK:- Button Action For Action Id's
    @IBAction func ActionCheckUncheck(_ sender: UIButton) {
        //For Check the user is selected/deselected action's of pages's
        if  sender.currentImage == UIImage(named: kImages.kUncheck){
            sender.setImage(UIImage(named: kImages.kCheck), for: .normal)
            //Append Action Ids
            let selectedAction = self.sectionItems[sender.tag]
            sectionNames[expandedSectionHeaderNumber].lstActionAccess?[sender.tag].isAccess = true
//            CommonFunctions.sharedmanagerCommon.println(object: "Header Section button tag:- \(expandedSectionHeaderNumber)")
//            CommonFunctions.sharedmanagerCommon.println(object: "Rows button tag:- \(sender.tag)")
            //For Select the page if user select any action
                let pageIsAccess = sectionNames[expandedSectionHeaderNumber].isAccess
                if pageIsAccess != true{
                    sectionNames[expandedSectionHeaderNumber].isAccess = true
                    tableView.reloadData()
                    if let selectedSectionPageId = self.sectionNames[expandedSectionHeaderNumber].pageId{
                        if pageIds.contains(String(describing: selectedSectionPageId)){
                            CommonFunctions.sharedmanagerCommon.println(object: "\(pageIds)")
                        }else{
                            pageIds.append(String(describing: selectedSectionPageId))
                        }
                    }
                }
            //Append action id's from array
            if let actionId = selectedAction.actionId{
                let strActionId = "\(actionId)"
                if actionIds.contains(strActionId){
                    CommonFunctions.sharedmanagerCommon.println(object: "\(sectionItems)")
                }else{
                    actionIds.append(strActionId)
                }
//                CommonFunctions.sharedmanagerCommon.println(object: "Action Id's Array :- \(actionIds)")
            }
        }
        else{
            sender.setImage(UIImage(named:  kImages.kUncheck), for: .normal)
            //remove action ids
            let selectedAction = self.sectionItems[sender.tag]
            sectionNames[expandedSectionHeaderNumber].lstActionAccess?[sender.tag].isAccess = false
            if let actionId = selectedAction.actionId{
                let str_actionId = "\(actionId)"
                if actionIds.contains(str_actionId){
                    actionIds = actionIds.filter(){$0 != str_actionId}
                    print(actionIds)
                }
//                CommonFunctions.sharedmanagerCommon.println(object: "Uncheck Action Id's Array :- \(actionIds)")
            }
        }
    }
    //MARK:- Actions Submit
    @IBAction func ActionSubmit(_ sender: Any) {
        if checkInternetConnection(){
            let strPageIds = pageIds.joined(separator: ",")
            let strActionIds = actionIds.joined(separator: ",")
            self.viewModel?.UpdateUserAccessList(userId: userId ?? 0, actionIDs: strActionIds, pageiDs: strPageIds, roleId: roleId ?? 0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
   
}


//MARK:- Table view delegates methods
extension UserAccessRoleVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
