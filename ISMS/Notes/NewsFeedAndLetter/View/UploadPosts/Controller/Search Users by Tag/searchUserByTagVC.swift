//
//  searchUserByTagVC.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 6/29/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import UIKit
import SDWebImage


class searchUserByTagVC: BaseUIViewController {

     
    @IBOutlet weak var noDataFound: UILabel!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var tblView: UITableView!
        var viewModel:  QuestionAnswerViewModel?
        var result_Data = [getUserDetailResultData]()
        var skip = Int()
        var isScrolling : Bool?
        var pageSize = KIntegerConstants.kInt10
        var pointNow:CGPoint!
        var isFetching:Bool?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            btnUpload.isHidden = true
            // Do any additional setup after loading the view.
              self.setSearchBarInNavigationController(placeholderText: "Enter username", navigationTitle: "Tag User", navigationController: self.navigationController, navigationSearchBarDelegates: self)
                 BackButton()
                 //Table View Settings
                 tblView.separatorStyle = .singleLine
                 tblView.tableFooterView = UIView()

        }
        
        override func viewWillAppear(_ animated: Bool) {
            skip = 0
             setView()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
             super.viewWillDisappear(animated)
            result_Data.removeAll()
            if tblView != nil {
                tblView.reloadData()
            }
             navigationController?.view.setNeedsLayout() //force update layout
             navigationController?.view.layoutIfNeeded() //to fix height of the navigation bar
         }
    
    
    
    @IBAction func actionUpload(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
   
        func setView() {
                   tblView.tableFooterView = UIView()
                   self.viewModel = QuestionAnswerViewModel.init(delegate: self)
                   self.viewModel?.attachView(view: self)
          //   self.viewModel?.searchResult(Search: "", skip: skip, PageSize: pageSize, SortColumnDir: "", SortColumn: "", ParticularId: UserDefaultExtensionModel.shared.currentUserId)
                 // self.viewModel?.getMutipleQuestionList(userId: userIdOther)
        }
    }

    extension searchUserByTagVC : UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return result_Data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
            if  result_Data.count > 0  {
                let rsltData = result_Data[indexPath.row]
            cell.lblName.text = (rsltData.firstName ?? "") + " " + (rsltData.lastName ?? "")
                if rsltData.imageUrl != nil{
                
                cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let url = rsltData.imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""
                        cell.imgProfile.sd_setImage(with: URL.init(string: url)) { (img, error, cacheType, url) in
                            if error == nil{
                                cell.imgProfile.contentMode = .scaleAspectFill
                                cell.imgProfile.image = img
                            }else{
                                if let nameStr = rsltData.firstName {
                                    CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: cell.imgProfile)
                                }
                            }
                        }
                    }else{
                        if let nameStr = rsltData.firstName{
                            CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: cell.imgProfile)
                        }
                    }
                
                if rsltData.IsSelected ==  true {
                                 cell.imgChk.image = UIImage(named: "check")
                             }
                             else {
                                 cell.imgChk.image = UIImage(named: "uncheck")

                             }
                
                
                for tagdic in tagArray where tagdic.UserId == rsltData.userId {
                         cell.imgChk.image = UIImage(named: "check")
                                 
                               }
                
             
            }
            return cell
                  
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.view.endEditing(true)
             if checkInternetConnection(){
                
                self.showLoader()
                let rsltData = result_Data[indexPath.row]
                
                if result_Data[indexPath.row].IsSelected == true {
                    result_Data[indexPath.row].IsSelected = false
                    
                    for (index,value) in tagArray.enumerated() {
                        if value.UserId == rsltData.userId {
                            if tagArray.count == 1 {
                           tagArray.remove(at: 0)
                            }
                            else{
                                tagArray.remove(at: index)

                            }
                        }
                    }
                    
                    if tagArray.count == 0 {
                         btnUpload.isHidden = true
                    }
                    else{
                        btnUpload.isHidden = false

                    }
                    
                    
                }
                else{
                    
                         if tagArray.count < 5 {
                             btnUpload.isHidden = false
                       result_Data[indexPath.row].IsSelected = true
                       var tagdic = LocalPostModel()
                       tagdic.UserId = rsltData.userId
                       tagdic.Name =  (rsltData.firstName ?? "") + " " + (rsltData.lastName ?? "")
                       tagdic.IsSelected = true
                       tagArray.append(tagdic)
                            }
                    else{
                        self.showAlert(alert: "Max 5 users can selected for a single post.")

                                          }
                    
                       
                }
                tblView.reloadData()
               self.hideLoader()
                
                    }
                     else{
                          self.showAlert(Message: Alerts.kNoInternetConnection)
                      }

        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }

    }
    ///MARK:- View Delegate
    extension searchUserByTagVC : ViewDelegate{
        func showAlert(alert: String){
            self.showAlert(Message: alert)
        }
        func showLoader() {
            ShowLoader()
        }
        func hideLoader() {
            HideLoader()
        }
    }


    extension searchUserByTagVC : QuestionAnswerDelegate {
        
        func GetSearchResult(data: GetSearchResultModel) {
            
            isFetching = true
            if data.resultData?.count ?? 0 > 0 {
                result_Data.append(contentsOf: data.resultData!)
           
            }
            
            if result_Data.count == 0 {
                noDataFound.isHidden = false
            }
            else{
                noDataFound.isHidden = true

            }
            tblView.reloadData()
        }
        
        func QuestionAnswerSuccess(message: String) {
        }
        
        func GetQuestionAnswerSuccess(data: GetQuestionsModel) {
        }
        
        func GetMultipleQuestionSuccess(data: QuestionsChoiceModel) {
        }
        
        func DidFailed() {
        }
    }
    //MARK:- UISearchController Bar Delegates
    extension searchUserByTagVC : NavigationSearchBarDelegate{
        
        func textDidChange(searchBar: UISearchBar, searchText: String) {
            result_Data.removeAll()
           
             self.viewModel?.searchResult(Search: searchText, skip: KIntegerConstants.kInt0, PageSize: pageSize, SortColumnDir: "", SortColumn: "", ParticularId: UserDefaultExtensionModel.shared.currentUserId)
        }
        
        func cancelButtonPress(uiSearchBar: UISearchBar) {
            DispatchQueue.main.async {
                self.result_Data.removeAll()
                self.tblView.reloadData()
                self.noDataFound.isHidden =  false
//                self.viewModel?.searchResult(Search: "", skip: KIntegerConstants.kInt0, PageSize: self.pageSize, SortColumnDir: "", SortColumn: "", ParticularId: UserDefaultExtensionModel.shared.currentUserId)
            }
        }
        
        
    }


    //MARK:- Scroll View delegates
    extension searchUserByTagVC : UIScrollViewDelegate{
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

            if (tblView.contentOffset.y < pointNow.y){
                CommonFunctions.sharedmanagerCommon.println(object: "Down scroll view")
                isScrolling = true
            }
            else if (tblView.contentOffset.y + tblView.frame.size.height >= tblView.contentSize.height){
                isScrolling = true
                if (isFetching == true){
                    skip = skip + KIntegerConstants.kInt10
                    isFetching = false
                    self.viewModel?.searchResult(Search: "", skip: skip, PageSize: self.pageSize, SortColumnDir: "", SortColumn: "", ParticularId: UserDefaultExtensionModel.shared.currentUserId)
                }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
            }
        }
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            pointNow = scrollView.contentOffset
        }
    }
