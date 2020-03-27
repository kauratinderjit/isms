//
//  UserAccessPresenter.swift
//  ISMS
//  Presenter
//  Created by Poonam Sharma on 6/21/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol UserAcessDelegate:class {
    func unauthorizedUser()
    func getUserAccessDidSucced(data: UserAccesstModel)
    func getUserAccessDidFalied()
    func updateUserAccessListDidSuccess(data: CommonSuccessResponseModel)
    func updateUserAccessListDidFailed()
}
class UserAccessViewModel{
    weak var delegate : UserAcessDelegate?
    
    //UserAccess View
    weak var userAccessView : ViewDelegate?
    //Initialize the Presenter class
    init(delegate:UserAcessDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: ViewDelegate) {
        userAccessView = view
    }
    
    //Detaching login view
    func detachView() {
        userAccessView = nil
    }
    
    func GetUserAccessList(userId:Int,roleId:Int)
    {
        var postDict = [String:Any]()
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kUserId] = userId
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kRoleId] = roleId

        self.userAccessView?.showLoader()
        UserAccessApi.sharedInstance.getUserAccess(url: ApiEndpoints.kUserAccess, parameters: postDict, completionResponse: { (userAccessModel) in
            self.userAccessView?.hideLoader()
            switch userAccessModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.delegate?.getUserAccessDidSucced(data: userAccessModel)
            case KStatusCode.kStatusCode401:
                self.userAccessView?.showAlert(alert: userAccessModel.message ?? "")
                self.delegate?.unauthorizedUser()
            default:
                self.userAccessView?.showAlert(alert: userAccessModel.message ?? "")
                self.delegate?.getUserAccessDidFalied()
            }
        }, completionnilResponse: { (nilResponseError) in
            self.userAccessView?.hideLoader()
            self.delegate?.getUserAccessDidFalied()
            if let error = nilResponseError{
                self.userAccessView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "User Access APi Nil response")
            }
        }) { (error) in
            self.userAccessView?.hideLoader()
            self.delegate?.getUserAccessDidFalied()
            if let err = error?.localizedDescription{
                self.userAccessView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "User Access APi error response")
            }
        }
    }
    
    func UpdateUserAccessList(userId:Int, actionIDs :String, pageiDs: String,roleId : Int){
        self.userAccessView?.showLoader()
        var postDict = [String: Any]()
        postDict["UserID"] = userId
        postDict["PageIds"] = pageiDs
        postDict["ActionIds"] = actionIDs
        postDict["RoleId"] = roleId
        
        UserAccessApi.sharedInstance.updateUserAccess(url:  ApiEndpoints.kUserAccessUpdate  , parameters: postDict, completionResponse: { (model) in
            print(model)
            self.userAccessView?.hideLoader()
            switch model.statusCode{
            case KStatusCode.kStatusCode200:
                self.userAccessView?.showAlert(alert: model.message ?? "")
                self.delegate?.updateUserAccessListDidSuccess(data: model)
            case KStatusCode.kStatusCode401:
                self.userAccessView?.showAlert(alert: model.message ?? "")
                self.delegate?.unauthorizedUser()
            default:
                self.userAccessView?.showAlert(alert: model.message ?? "")
                self.delegate?.updateUserAccessListDidFailed()
            }
        }, completionnilResponse: { (nilresponse) in
             self.userAccessView?.hideLoader()
            self.userAccessView?.showAlert(alert: nilresponse ?? "")
        }, complitionError: { (error) in
           self.userAccessView?.hideLoader()
            self.userAccessView?.showAlert(alert: error!.localizedDescription)
        })
    }
}

//MARK: - ViewDelegate
extension UserAccessRoleVC : ViewDelegate{
    
    //Set UI
    func setUI(){
        //Initiallize memory for viewModel
        self.viewModel = UserAccessViewModel.init(delegate : self )
        self.viewModel?.attachView(view: self)
        //Theme
        guard let theme = ThemeManager.shared.currentTheme else{ return }
        btnUpdate.backgroundColor = theme.uiButtonBackgroundColor
        //Unhide navifgation bar
        UnHideNavigationBar(navigationController: self.navigationController)
        //Set the footer view
        self.tableView!.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //Set back button
        setBackButton()
        //Set table view row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 10
        tableView.reloadData()
    }
    
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
}

//MARK:- Custom Ok Alert
extension UserAccessRoleVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        if isUserAccessUpdateSuccess == true{
            self.navigationController?.popViewController(animated: true)
        }
        else if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        } else{
            okAlertView.isHidden = true
            visualBlurView.isHidden = true
        }
    }
}

//MARK:-  UserAcessDelegate
extension UserAccessRoleVC: UserAcessDelegate{
    func updateUserAccessListDidSuccess(data: CommonSuccessResponseModel) {
        isUserAccessUpdateSuccess = true
    }
    func updateUserAccessListDidFailed() {
        isUserAccessUpdateSuccess = false
    }
    func getUserAccessDidSucced(data: UserAccesstModel) {
        if let resuldata =  data.resultData{
            print(resuldata)
            if let lstpage = resuldata.lstPageAccess{
                sectionNames = lstpage
                print(sectionNames)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func getUserAccessDidFalied() {
        isUserAccessUpdateSuccess = false
    }
    
    //MARK:- Unathorized User
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
}
//MARK:- Table View Data Source Methods
extension UserAccessRoleVC : UITableViewDataSource{
    
    //MARK:- Section Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tableView.backgroundView = nil
            tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
            return sectionNames.count
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            if let sectItems = sectionNames[section].lstActionAccess{
                sectionItems = sectItems
                return sectionItems.count
            }
            return 0
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.sectionNames.count != 0) {
            let pageName = self.sectionNames[section].pageName
            return pageName
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return  60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return CGFloat.leastNormalMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
        headerView.backgroundColor = .white
         headerView.tag = section
        
      
        
        if let viewWithTag = headerView.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
       
        if (self.sectionNames.count != 0){
            
            let headerLabel = UILabel()
            if let font = UIFont.init(name: KFontNames.kOpenSansNBold, size: 17) {
            //LABEL
            let height = heightForView(text:  self.sectionNames[section].pageName ?? "", font: font , width: headerView.frame.width-40)
            print(height)//Output : 41.0
            headerLabel.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width-40, height: height)
            headerLabel.numberOfLines = 0
            headerLabel.textColor = KAPPContentRelatedConstants.kThemeColour
            headerLabel.text = self.sectionNames[section].pageName
            headerView.addSubview(headerLabel)
            
            
            //BUTTON CHECK BOX
            let headerFrame = headerView.frame.size
            let btnHeaderCheckBox = UIButton(frame: CGRect(x: headerFrame.width - 32, y: height/2 - 7 , width: 22, height: 22))
            let isAccess = sectionNames[section].isAccess
            if isAccess == false {
                btnHeaderCheckBox.setImage(UIImage(named: kImages.kUncheck), for: .normal)
             }
            else if isAccess == true{
                btnHeaderCheckBox.setImage(UIImage(named: kImages.kCheck), for: .normal)
                if let selectedSectionPageId = self.sectionNames[section].pageId {
                    if pageIds.contains(String(describing: selectedSectionPageId)){
                        CommonFunctions.sharedmanagerCommon.println(object: "\(pageIds)")
                    }else{
                        pageIds.append(String(describing: selectedSectionPageId))
                    }
                }
            }
            btnHeaderCheckBox.addTarget(self, action: #selector(actionRadiobutton(_:)), for: .touchUpInside)
            btnHeaderCheckBox.tag = kHeaderSectionTag + section
            //        CommonFunctions.sharedmanagerCommon.println(object: "Header Button checkbox:- \(btnHeaderCheckBox.tag)")
            
            headerView.addSubview(btnHeaderCheckBox)
            }
            
        }
       
        // make headers touchable
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(self.sectionHeaderWasTouched(_:)))
        headerView.addGestureRecognizer(headerTapGesture)
        return headerView
    
    }
    
    //MARK:- Action For Pages Id's
    @objc func actionRadiobutton(_ sender: UIButton){
        if sender.currentImage == UIImage(named: kImages.kUncheck){
            sender.setImage(UIImage(named:kImages.kCheck), for: .normal)
            //Append Page Ids
            let selectedSection = self.sectionNames[sender.tag-kHeaderSectionTag]
            if let strPageId = selectedSection.pageId{
                sectionNames[sender.tag - kHeaderSectionTag].isAccess = true
                if pageIds.contains("\(strPageId)"){
                    CommonFunctions.sharedmanagerCommon.println(object: "\(pageIds)")
                }else{
                    pageIds.append("\(strPageId)")
                }
//                print("Pages Id Array:- \(pageIds)")
            }
        }
        else{
            sender.setImage(UIImage(named:kImages.kUncheck), for: .normal)
            //Remove pageIds
            let selectedSection = self.sectionNames[sender.tag - kHeaderSectionTag]
            if let pageId = selectedSection.pageId{
                let str_pageId = "\(pageId)"
                sectionNames[sender.tag - kHeaderSectionTag].isAccess = false
                
                //Remove the page id from array
                if pageIds.contains(str_pageId){
                    pageIds = pageIds.filter(){$0 != str_pageId}
                    print(pageIds)
                }
                else{
                    //do nothing
                }
                //Remove Action's Id's from array When User Deselct the page
                if let count = sectionNames[exist: expandedSectionHeaderNumber]?.lstActionAccess?.count{
                    if count > 0{
                        for value in 0..<(sectionNames[expandedSectionHeaderNumber].lstActionAccess?.count)!{
//                            CommonFunctions.sharedmanagerCommon.println(object: "Value:- \(value)")
                            sectionNames[expandedSectionHeaderNumber].lstActionAccess?[value].isAccess = false
                            if let selectedSectionActionId = sectionNames[expandedSectionHeaderNumber].lstActionAccess?[value].actionId{
                                actionIds = actionIds.filter(){$0 != String(describing: selectedSectionActionId)}
                                print(actionIds)
                            }
                        }
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        
        let headerView = sender.view as! UIView
        let section    = headerView.tag
        let btnSelectedHeader = headerView.viewWithTag(kHeaderSectionTag + section) as? UIButton
        print(btnSelectedHeader?.frame)
        if (self.expandedSectionHeaderNumber == -1) {
            
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, button: btnSelectedHeader!)
            
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, button: btnSelectedHeader!)
            } else {
                let btnSelected = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIButton
                tableViewCollapeSection(self.expandedSectionHeaderNumber, button: btnSelected!)
                tableViewExpandSection(section, button: btnSelectedHeader!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, button: UIButton) {
        let sectionData = sectionNames[section].lstActionAccess
        self.expandedSectionHeaderNumber = -1
        if (sectionData?.count == 0) {
            return;
        } else {
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData!.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView.endUpdates()
        }
    }
    func tableViewExpandSection(_ section: Int, button: UIButton ) {
        let sectionData = self.sectionNames[section].lstActionAccess
        if (sectionData?.count ?? 0 == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData!.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kUserAccessTableViewCell, for: indexPath) as! UserAccessTableViewCell
        
        let isAccess = self.sectionNames[expandedSectionHeaderNumber].lstActionAccess?[indexPath.row].isAccess
        //        sectionItems[indexPath.row].isAccess
        if let actionId = self.sectionNames[expandedSectionHeaderNumber].lstActionAccess?[indexPath.row].actionId{
            if isAccess == true{
                cell.btnCheckUncheck.setImage(UIImage.init(named: kImages.kCheck), for: .normal)
                
                if self.actionIds.contains(String(describing: actionId)){
                    CommonFunctions.sharedmanagerCommon.println(object: "\(self.actionIds)")
                }else{
                    self.actionIds.append(String(describing: actionId))
                }
            }else{
                cell.btnCheckUncheck.setImage(UIImage.init(named: kImages.kUncheck), for: .normal)
            }
            cell.setUpCell(indexPath: indexPath, sectionItems: self.sectionItems, arrActionId: self.actionIds)
        }
        return cell
    }
    //MARK :- Function
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}
