//
//  LikerListVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/19/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class LikerListVC: BaseUIViewController {
    
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
        
        hideNavigationBackButton()
        BackButton()
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
        cell.imgViewProfile.addInitials(first: nameStr.first?.description ?? "", second: "")
       
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
    func addedSuccessfully(result: Int) {
        
    }
    
    func CommentData(data: [lstgetCommentViewList]?) {
        
    }
    
    func LikerList(data: [lstgetLikesListViewModels]) {
        if data.count > 0 {
                    likerList = data
                    tblView.reloadData()
                }
    }
    
    
    
    func displayData(data: [NewsListResultData]) {
        
    }
    
    func attachmentDeletedSuccessfully() {
    }
    
    
  
}
public extension UIImageView {
    
    func addInitials(first: String, second: String) {
        let initials = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        initials.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        initials.textAlignment = .center
        initials.text = first + " " + second
        initials.textColor = .white
        initials.backgroundColor = .random
     
        self.addSubview(initials)
   
}
}
