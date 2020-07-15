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
import DropDown
import Hakawai


class CommentVC: BaseUIViewController {

    var commentList : [lstgetCommentViewList]?
    @IBOutlet weak var tblView: UITableView!
    var arrNotesList = ["Topic 1","Topic 2","Topic 3","Topic 4","Topic 5","Topic 6","Topic 7",]
    var viewModel : UploadPostViewModel?
    var viewModelSearch:  QuestionAnswerViewModel?
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    var keyboardHeight : CGFloat?
    var postID: Int = 0
    var commentId = 0
    var postById = 0
    var result_Data : [getUserDetailResultData]?
    let dropDown = DropDown()
    var searchString : String = ""
    @IBOutlet weak var ViewTop: NSLayoutConstraint!
    private var plugin: HKWMentionsPlugin?
    var tagIds = [Int]()
    var strFinal = ""
    var strlblFinal = ""
    
    let formatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy, h:mm a"
                    return formatter
            }()
          
     let dateFormatter = DateFormatter()
    
    @IBOutlet weak var lbl: UILabel!
    
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
        self.viewModelSearch = QuestionAnswerViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        self.viewModel?.getComment(postId:postID)
        hideNavigationBackButton()
        BackButton()
        dropDown.anchorView = lbl
        
       // dropDown.frame = CGRect(x:txtViewComment.frame.origin.x ,y: 200, width: self.view.frame.width, height: 200)
  
    }
    
 
    
   func setDropDown() {
    
        var idArray = [Int]()
        if result_Data?.count ?? 0 > 0 {
            if let name = result_Data?.map( { ($0.UserName)} ) {
             dropDown.dataSource = name as! [String]
         }

         if let id = result_Data?.map( { $0.userId } ) {
             idArray = id as! [Int]
          }

        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        
            let eliString = self.txtViewComment.text.replacingOccurrences(of: self.searchString, with: "@", options: [.regularExpression, .caseInsensitive])
              
            self.tagIds.append(idArray[index])
            print(self.tagIds)
          self.txtViewComment.text = eliString
            
            self.strFinal = item.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
            
            self.txtViewComment.text = self.txtViewComment.text + self.strFinal + " "
            self.resolveHashTags(str: self.txtViewComment.text)
         self.dropDown.hide()
            }
         }
         else{
             self.showAlert(Message: "No user found")
         }

    }

    
    @IBAction func actionDel(_ sender: UIButton) {
        
        if commentList?.count ?? 0 > 0{
            let data = commentList?[(sender as AnyObject).tag]
            commentId = data?.CommentId ?? 0
            postById = data?.CommentedById ?? 0
                    initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                    yesNoAlertView.delegate = self
                    yesNoAlertView.lblResponseDetailMessage.text = "Do you really want to delete this comment?"
                   
               }
    }
    
    
    @IBAction func actionSendButton(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if checkInternetConnection(){
                                 
                                 if txtViewComment.text == "" {
                                  self.showAlert(Message: "Please enter something in comment box")
                                 }
                                 
                               
                                 else {
                                    
                                    UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: 7), animations: {
                                              self.ViewTop.constant = 0

                                       },completion: nil)
                                    
                                    self.viewModel?.sendComment(AllFiles: "", Comment: txtViewComment.text, CommentId: 0, CommentedBy: UserDefaultExtensionModel.shared.currentUserId, PostId: postID, tagIds: tagIds)
                                    
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
        func resolveHashTags(str: String){

        // turn string in to NSString
            let nsText:NSString = str as NSString

        // this needs to be an array of NSString.  String does not work.
        let words:[NSString] = nsText.components(separatedBy: " ") as [NSString]

        // you can't set the font size in the storyboard anymore, since it gets overridden here.
        let attrs = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)
        ]

        // you can staple URLs onto attributed strings
        let attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
        // tag each word if it has a hashtag
        for word in words {

            // found a word that is prepended by a hashtag!
            // homework for you: implement @mentions here too.
            let aa = "@" + strFinal
            if word.hasPrefix("@") && aa == word as String {

                
                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                let matchRange:NSRange = nsText.range(of: word as String)

                // convert the word from NSString to String
                // this allows us to call "dropFirst" to remove the hashtag
                var stringifiedWord:String = word as String

                // drop the hashtag
                stringifiedWord = String(stringifiedWord.dropFirst())

                // check to see if the hashtag has numbers.
                // ribl is "#1" shouldn't be considered a hashtag.
                let digits = NSCharacterSet.decimalDigits

                if stringifiedWord.rangeOfCharacter(from: digits) != nil    {
                    // hashtag contains a number, like "#1"
                    // so don't make it clickable
                } else {
                    // set a link for when the user clicks on this word.
                    // it's not enough to use the word "hash", but you need the url scheme syntax "hash://"
                    // note:  since it's a URL now, the color is set to the project's tint color
                    attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
                }

            }
        }

        // we're used to textView.text
        // but here we use textView.attributedText
        // again, this will also wipe out any fonts and colors from the storyboard,
        // so remember to re-add them in the attrs dictionary above
            self.txtViewComment.attributedText = attrString
    }
    
       func resolve_HashTags(str: String) -> NSMutableAttributedString {

        // turn string in to NSString
            let nsText:NSString = str as NSString

        // this needs to be an array of NSString.  String does not work.
        let words:[NSString] = nsText.components(separatedBy: " ") as [NSString]

        // you can't set the font size in the storyboard anymore, since it gets overridden here.
        let attrs = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)
        ]

        // you can staple URLs onto attributed strings
        let attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
        // tag each word if it has a hashtag
        for word in words {

            // found a word that is prepended by a hashtag!
            // homework for you: implement @mentions here too.
            if word.hasPrefix("@") && "@" + strlblFinal == word as String {

                
                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                let matchRange:NSRange = nsText.range(of: word as String)

                // convert the word from NSString to String
                // this allows us to call "dropFirst" to remove the hashtag
                var stringifiedWord:String = word as String

                // drop the hashtag
                stringifiedWord = String(stringifiedWord.dropFirst())

                // check to see if the hashtag has numbers.
                // ribl is "#1" shouldn't be considered a hashtag.
                let digits = NSCharacterSet.decimalDigits

                if stringifiedWord.rangeOfCharacter(from: digits) != nil    {
                    
                } else {
                   
                    attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
                }

            }
        }
        return attrString
    }

}


extension CommentVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            self.viewModel?.deleteComment(UserId: postById, PostId: postID, CommentId: commentId)
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
        let taggedUser = commentList?[indexPath.row].lstTaggedUser
        strlblFinal = taggedUser?[0].Name ?? ""
        strlblFinal = strlblFinal.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
      cell.lblComment.attributedText =  resolve_HashTags(str: cell.lblComment.text ?? "")
        cell.lblDate.text = commentList?[indexPath.row].strCreatedDate
        cell.btnDel.tag = indexPath.row
            
            if commentList?[indexPath.row].PostedBy ==  UserDefaultExtensionModel.shared.currentUserId {
            cell.btnDel.isHidden = false
            }
            else{
                
                if commentList?[indexPath.row].CommentedById == UserDefaultExtensionModel.shared.currentUserId {
                    cell.btnDel.isHidden = false
                }
                else{
                    cell.btnDel.isHidden = true
                }
            }
      
           if  commentList?[indexPath.row].ImageUrl  != "" {
                        let url = commentList?[indexPath.row].ImageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        cell.imgProfile.sd_setImage(with: URL(string: url ?? "" ), placeholderImage: UIImage(named: "profile"), options: SDWebImageOptions(rawValue: 0))
                          { (image, error, cacheType, imageURL) in
                              cell.imgProfile.image = image
                          }
                      }
                      else {
                          cell.imgProfile.image = UIImage(named: "profile")
                      }
        return cell
    }
}


extension CommentVC:UITextViewDelegate{

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n"
        {
            textView.resignFirstResponder()
        }

        if text == " "
            {
                dropDown.hide()
            }

        
        let nsString = textView.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: text)
        let arr = newString?.components(separatedBy: " ")
        let aa = arr?.last
        
       if  self.tagIds.count == 0 && aa?.contains("@") ?? true{
        //if aa?.contains("@") ?? true {
            guard let  finalText = aa?.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range: nil) else { return true }
            searchString =  aa ?? ""
            
             self.viewModelSearch?.searchResult(Search: finalText, skip: KIntegerConstants.kInt0, PageSize: 1000, SortColumnDir: "", SortColumn: "", ParticularId: UserDefaultExtensionModel.shared.currentUserId)
            
        }
            
            else{
                         dropDown.hide()
                           //self.showAlert(alert: "You can mention only single user.")
                  }
            
        
        if txtViewComment.text.contains("@") {
        if !txtViewComment.text.contains(strFinal) {
            self.tagIds.removeAll()
         
            let range = (txtViewComment.text as NSString).range(of: strFinal)
            let attrs = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)
            ]
            let attributedString = NSMutableAttributedString(string:txtViewComment.text,attributes: attrs)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: txtViewComment.text.characters.count))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
            txtViewComment.attributedText = attributedString

        }
        }
 //       }
//        else {
//         dropDown.hide()
//        }

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
    func addedSuccessfully(result: Int) {
        tagIds.removeAll()
         txtViewComment.textColor = UIColor.black
        txtViewComment.text = ""
               lblPlaceHolder.isHidden = false
               self.viewModel?.getComment(postId:postID)
    }
    
    func LikerList(data: [lstgetLikesListViewModels]) {
        
    }
    
    func CommentData(data: [lstgetCommentViewList]?) {
                 commentList = data
                 tblView.reloadData()
    }
    
 
    
    func displayData(data: [NewsListResultData]) {
        
    }
    
    func attachmentDeletedSuccessfully() {
         self.viewModel?.getComment(postId:postID)
    }
    
 
  
}

extension CommentVC : QuestionAnswerDelegate {
    
    func GetSearchResult(data: GetSearchResultModel) {
        
        if data.resultData?.count ?? 0 > 0 {
            result_Data = data.resultData!
            setDropDown()
        }
           
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




