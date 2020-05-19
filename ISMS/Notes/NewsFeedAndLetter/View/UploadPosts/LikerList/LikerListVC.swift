//
//  LikerListVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/19/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class LikerListVC: UIViewController {
    
      var likerList : [lstgetLikesListViewModels]?
      var viewModel : UploadPostViewModel?
      var postId = 0
     @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Who Likes The Post?"
    
          self.viewModel = UploadPostViewModel.init(delegate: self)
                     self.viewModel?.attachView(viewDelegate: self)
        self.viewModel?.getlikerList(postId: postId)
        tblView.tableFooterView = UIView()
    }
    

}

extension LikerListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if likerList?.count ?? 0 > 0{
            tableView.separatorStyle = .singleLine
            return (likerList?.count ?? 0)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LikerListCell
        cell.lblName.text = likerList?[indexPath.row].LikedBy
        let nameStr = likerList?[indexPath.row].LikedBy ?? ""
        cell.imgViewProfile.addInitials(first: nameStr.characters.first?.description ?? "", second: "")
       
        return cell
    }
}
extension LikerListVC : ViewDelegate {
    
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

extension LikerListVC : AddPostDelegate {
    func LikerList(data: [lstgetLikesListViewModels]) {
        if data.count > 0 {
                    likerList = data
                    tblView.reloadData()
                }
    }
    
    func CommentData(data: [lstgetCommentViewList]) {
          
    }
    
    func displayData(data: [NewsListResultData]) {
        
    }
    
    func attachmentDeletedSuccessfully() {
    }
    
    func addedSuccessfully() {
        
    }
  
}
