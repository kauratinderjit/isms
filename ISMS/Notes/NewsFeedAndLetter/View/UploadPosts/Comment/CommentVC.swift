//
//  CommentVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/13/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage
import Foundation
class CommentVC: BaseUIViewController {

    var commentList : [lstgetCommentViewList]?
    @IBOutlet weak var tblView: UITableView!
    var arrNotesList = ["Topic 1","Topic 2","Topic 3","Topic 4","Topic 5","Topic 6","Topic 7",]
    var viewModel : UploadPostViewModel?
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    var keyboardHeight : CGFloat?
    var postID: Int = 0
    var commentId = 0
    
    @IBOutlet weak var ViewTop: NSLayoutConstraint!
    
    
    let formatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy, h:mm a"
                    return formatter
            }()
          
     let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"
        tblView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        self.viewModel = UploadPostViewModel.init(delegate: self)
               self.viewModel?.attachView(viewDelegate: self)
        self.viewModel?.getComment(postId:postID)
    }
    
    @IBAction func actionDel(_ sender: UIButton) {
        
        if commentList?.count ?? 0 > 0{
            let data = commentList?[(sender as AnyObject).tag]
            commentId = data?.CommentId ?? 0
                    initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                    yesNoAlertView.delegate = self
                    yesNoAlertView.lblResponseDetailMessage.text = "Do you really want to delete this comment?"
                   
               }
    }
    
    
    @IBAction func actionSendButton(_ sender: UIButton) {
        
        if checkInternetConnection(){
                                 
                                 if txtViewComment.text == "" {
                                  self.showAlert(Message: "Please enter something in comment box")
                                 }
                                 
                               
                                 else {
                                    self.view.endEditing(true)
                                    UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: 7), animations: {
                                              self.ViewTop.constant = 0

                                       },completion: nil)
                                    self.viewModel?.sendComment(AllFiles: "", Comment: txtViewComment.text, CommentId: 0, CommentedBy: UserDefaultExtensionModel.shared.userRoleParticularId, PostId: postID)


                                 }
                                 
                             }
                             
                              else{
                                 self.showAlert(Message: Alerts.kNoInternetConnection)
                             }
               
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    

}


extension CommentVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            self.viewModel?.deleteComment(UserId: UserDefaultExtensionModel.shared.userRoleParticularId, PostId: postID, CommentId: commentId)
                yesNoAlertView.removeFromSuperview()
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
            yesNoAlertView.removeFromSuperview()
        }
        yesNoAlertView.removeFromSuperview()
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}
extension CommentVC : UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
   
    
}
extension CommentVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if commentList?.count ?? 0 > 0{
            tableView.separatorStyle = .singleLine
            return (commentList?.count ?? 0)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableViewCell
        cell.lblName.text = commentList?[indexPath.row].CommentedBy
        cell.lblComment.text = commentList?[indexPath.row].Comment
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        if let dateFinal =  dateFormatter.date(from: commentList?[indexPath.row].CreatedDate ?? "") {
                            let dd = formatter.string(from: dateFinal)
                            cell.lblDate.text = dd
                        }
      //  cell.setCellUI(data: arrNotesList, indexPath: indexPath)
        return cell
    }
}


extension CommentVC:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lblPlaceHolder.isHidden = true
            //self.animateTextView(textView: textView, up: true, movementDistance: 200, scrollView:self.viewBg)
        UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: 7), animations: {
            self.ViewTop.constant = self.keyboardHeight ?? 0.0 + 45

     },completion: nil)
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let str = textView.text.trimmingCharacters(in: .whitespaces)
        
        if str == ""
        {
            self.txtViewComment.text = ""
            lblPlaceHolder.isHidden = false
            
        }
        else{
            txtViewComment.text = textView.text
        }
        
UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: 7), animations: {
                                             self.ViewTop.constant = 0

                                      },completion: nil)

   }
    
}

extension CommentVC : ViewDelegate {
    
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

extension CommentVC : AddPostDelegate {
    func LikerList(data: [lstgetLikesListViewModels]) {
        
    }
    
    func CommentData(data: [lstgetCommentViewList]) {
           if data.count > 0 {
                 commentList = data
                 tblView.reloadData()
             }
    }
    
 
    
    func displayData(data: [NewsListResultData]) {
        
    }
    
    func attachmentDeletedSuccessfully() {
         self.viewModel?.getComment(postId:postID)
    }
    
    func addedSuccessfully() {
        txtViewComment.text = ""
        lblPlaceHolder.isHidden = false
        self.viewModel?.getComment(postId:postID)
        
    }
  
}
