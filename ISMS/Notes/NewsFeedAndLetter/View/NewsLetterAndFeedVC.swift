//
//  NewsLetterAndFeedVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import AVKit
import SDWebImage
import SwiftPhotoGallery

var boolOpenLargeView = false

class NewsLetterAndFeedVC: BaseUIViewController {
    
    //MARK:- Outlet and Variables
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tbleViewNewsFeed: UITableView!
    @IBOutlet weak var btnBulletin: UIButton!
    @IBOutlet weak var btnNewsletter: UIButton!
    @IBOutlet weak var btnEvents: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var btnProfile: UIButton!
    var viewModel : UploadPostViewModel?
    var newsData = [NewsListResultData]()
    var lstDocuments: [lstDocuments]?
     var taggedUsersData: [TaggedUsers]?
    var isScrolling : Bool?
    var pointNow:CGPoint!
    var skip = 0
    var pageSize = KIntegerConstants.kInt10
    var isFetching:Bool?
    var player = AVQueuePlayer()
    var imageNames = [String]()
    let dateFormatter = DateFormatter()
    var playAudioIndex : Int?
    var newsletterId = 0
    var refreshControl = UIRefreshControl()
    var likedDta : Int?
    var strText = ""
    var deletedRow : Int?
    var button = UIImageView()
    let formatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy, h:mm a"
                    return formatter
            }()
    var booltag = false
    
    //MARK:- lifecycle Methods
    override func viewDidLoad()
    {
    super.viewDidLoad()
     self.viewModel = UploadPostViewModel.init(delegate: self)
     self.viewModel?.attachView(viewDelegate: self)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tbleViewNewsFeed.addSubview(refreshControl)
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = false
        if #available(iOS 13.0, *) {
                 self.navigationController?.navigationBar.shadowImage = UIColor.placeholderText.as1ptImage()
             } else {
                 self.navigationController?.navigationBar.shadowImage = UIColor.lightGray.as1ptImage()
             }
        
        setBackButton()

    }
    
    @objc func refresh(_ sender: AnyObject) {
       if checkInternetConnection(){
        newsData.removeAll()
         getNewfeedData()
        }
       else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    override func viewDidDisappear(_  animated: Bool) {
          if boolOpenLargeView == false {
            newsData.removeAll()
            if tbleViewNewsFeed != nil {
                tbleViewNewsFeed.reloadData()
                self.navigationItem.rightBarButtonItem = nil
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tagArray.removeAll()
//        str_Role = ""
         boolImageSelected = false
        if checkInternetConnection(){
            if boolOpenLargeView == false {
                var clickbutton = UIButton()
                clickbutton = UIButton(frame: CGRect(x: 0,y: 0,width: 44, height: 44))
                button = UIImageView(frame: CGRect(x: 0,y: 0,width: 32, height: 32))
                clickbutton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                cornerView(radius: 16, view: button)
                button.addSubview(clickbutton)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
                skip = 0
                SetView()
                getNewfeedData()
                if tbleViewNewsFeed.numberOfRows(inSection: 0) != 0 {
                    tbleViewNewsFeed.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
            else{
              boolOpenLargeView = false
            }
        }
       else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    

     //MARK:- Actions
    
   @objc func buttonAction(sender: UIButton)
    {
              if checkInternetConnection(){
//               let storyBoard: UIStoryboard = UIStoryboard(name: "NewsFeedAndLetter", bundle: nil)
//                               let ProfileNewsFeedVC = storyBoard.instantiateViewController(withIdentifier: "ProfileNewsFeedVC") as! ProfileNewsFeedVC
//                 ProfileNewsFeedVC.viewprofile = "true"
//                ProfileNewsFeedVC.status = AppDefaults.shared.bio
//                ProfileNewsFeedVC.otherUserId = UserDefaultExtensionModel.shared.currentUserId
//                ProfileNewsFeedVC.img = AppDefaults.shared.userImage
//                ProfileNewsFeedVC.name = AppDefaults.shared.userFirstName + " " + AppDefaults.shared.userLastName
//                ProfileNewsFeedVC.modalPresentationStyle = .fullScreen
//                self.navigationController?.pushViewController(ProfileNewsFeedVC, animated: true)
//

                                         }
                   else{
                        self.showAlert(Message: Alerts.kNoInternetConnection)
                    }
    }
   
    
    @IBAction func actionAddPost(_ sender: UIButton) {
        if checkInternetConnection(){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Homework", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddNewsFeedPostsVC") as! AddNewsFeedPostsVC
                 newViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(newViewController, animated: true)
                   }
              else{
                   self.showAlert(Message: Alerts.kNoInternetConnection)
               }
    }
    
    func getNewfeedData() {
        skip = 0
        self.viewModel?.getData(Search: "",Skip: 0,PageSize: KIntegerConstants.kInt10,SortColumnDir : "",SortColumn: "",ParticularId: UserDefaultExtensionModel.shared.currentUserId)
    }
    
    
    @IBAction func actionWhatOnMind(_ sender: UIButton) {
        
        if checkInternetConnection(){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Homework", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddNewsFeedPostsVC") as! AddNewsFeedPostsVC
            newViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(newViewController, animated: true)

                                    }
              else{
                   self.showAlert(Message: Alerts.kNoInternetConnection)
               }
    }
    
    @IBAction func openProfile(_ sender: UIButton) {
    }
    
    @IBAction func btnTabActions(_ sender: UIButton)
    {}
    
    @IBAction func actionLike(_ sender: UIButton) {
          if checkInternetConnection(){
            
            var liked = false
            if newsData[sender.tag].LikedByMe == 0 {
                newsData[sender.tag].LikedByMe = 1
                liked = true
            }
            else {
                newsData[sender.tag].LikedByMe = 0
                 liked = false
            }
            likedDta = sender.tag
            self.viewModel?.likePost(PostId: newsData[sender.tag].NewsLetterId ?? 0, LikedBy: UserDefaultExtensionModel.shared.currentUserId, IsLiked: liked)
               }
        else{
             self.showAlert(Message: Alerts.kNoInternetConnection)
         }
        
    }
    
    @IBAction func actionComment(_ sender: UIButton) {
        if checkInternetConnection(){
            let storyBoard: UIStoryboard = UIStoryboard(name: KStoryBoards.kNewsfeedAndLetter, bundle: nil)
                       let newViewController = storyBoard.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
            newViewController.postID = newsData[sender.tag].NewsLetterId ?? 0
                       newViewController.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(newViewController, animated: true)
                                          }
                    else{
                         self.showAlert(Message: Alerts.kNoInternetConnection)
                     }
    }
    
    @IBAction func actionShare(_ sender: UIButton) {
        if checkInternetConnection(){
        
        let buttonPostion = sender.convert(sender.bounds.origin, to: tbleViewNewsFeed)
        
        if let indexPath = tbleViewNewsFeed.indexPathForRow(at: buttonPostion) {
            let rowIndex =  indexPath.row
            print(rowIndex)
            playAudioIndex = rowIndex
            if let dict = newsData[rowIndex].lstDocuments?[sender.tag] {
                if dict.typedoc == "Video" || dict.typedoc == "Audio"  || dict.typedoc == "Image" || dict.typedoc == "FeedThumbNil" {
                    
                    if dict.typedoc == "FeedThumbNil" {
                         if let dic = newsData[rowIndex].lstDocuments?[sender.tag + 1] {
                        let path = dic.URL ?? nil
                        let fileUrl = URL(string: path ?? "")
                        if(fileUrl != nil)
                        {
                            let text = newsData[rowIndex].Description
                            let myWebsite = fileUrl
                            let shareAll = [text ?? ""  , myWebsite!] as [Any]
                            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                            activityViewController.popoverPresentationController?.sourceView = self.view
                            self.present(activityViewController, animated: true, completion: nil)
                            
                        }
                        }
                    }
                    else if dict.typedoc == "Image"  {
                        
                        var strArr = [String]()
                        if let dict = newsData[rowIndex].lstDocuments {
                            
                            for (_,value) in dict.enumerated() {
                                let path = value.URL ?? nil
                                let url = path?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""

                                                   let fileUrl = URL(string: url)
                                                   if(fileUrl != nil)
                                                   {
                                                    strArr.append("\(String(describing: fileUrl!))")
                                }
                                }
                            }
                        
                        let text = newsData[rowIndex].Description
                        let myWebsite = strArr
                        let stringRepresentation = myWebsite.joined(separator:",")

                        let shareAll = [text ?? ""  , stringRepresentation] as [Any]
                        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.present(activityViewController, animated: true, completion: nil)
                        
                    
                    }
                    else{
                         if let dic = newsData[rowIndex].lstDocuments?[sender.tag] {
                        let path = dic.URL ?? nil
                        let fileUrl = URL(string: path ?? "")
                        if(fileUrl != nil)
                        {
                            let text = newsData[rowIndex].Description
                            let myWebsite = fileUrl
                            let shareAll = [text ?? ""  , myWebsite!] as [Any]
                            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                            activityViewController.popoverPresentationController?.sourceView = self.view
                            self.present(activityViewController, animated: true, completion: nil)
                            
                        }
                        }

                    }
                }
                
            }
                
            else{
                let text = newsData[rowIndex].Description
                let shareAll = [text ?? ""] as [Any]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
            
            }
                      else{
                           self.showAlert(Message: Alerts.kNoInternetConnection)
                       }
    }
    
    //MARK: Play button for videos and audios
    @IBAction func playButton(_ sender: UIButton) {
        
          if checkInternetConnection() {
      boolOpenLargeView = true
        let buttonPostion = sender.convert(sender.bounds.origin, to: tbleViewNewsFeed)

               if let indexPath = tbleViewNewsFeed.indexPathForRow(at: buttonPostion) {
                   let rowIndex =  indexPath.row
                   print(rowIndex)
                   playAudioIndex = rowIndex
                if let dict = newsData[rowIndex].lstDocuments?[sender.tag] {
                 if dict.typedoc == "Video"  {

                     let path = dict.URL ?? nil
                        let fileUrl = URL(string: path ?? "")
                               if(fileUrl != nil)
                               {
                                //***********
                                if let audioUrl = fileUrl {
                                    // create your document folder url
                                    let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                                    // your destination file url
                                    let destination = documentsUrl.appendingPathComponent(audioUrl.lastPathComponent)
                                    print(destination)
                                    // check if it exists before downloading it
                                    if FileManager().fileExists(atPath: destination.path) {
                                        print("The file already exists at path")
                                        
                                        guard URL.init(string: destination.path) != nil else {
                                            let player = AVPlayer(url: fileUrl!)
                                                 let vc = AVPlayerViewController()
                                                  vc.player = player
                                                  present(vc, animated: true)
                                               {
                                                 vc.player?.play()
                                                    }
                                        return
                                         }
                                        do {
                                            
                                            let player = AVPlayer(url: destination)
                                              let vc = AVPlayerViewController()
                                              vc.player = player
                                             present(vc, animated: true)
                                             {
                                                vc.player?.play()
                                               }
                                        }
                                        
                                     
                                    } else {
                                        //  if the file doesn't exist
                                        //  just download the data from your url
                                        self.showLoader()
                                        URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) in
                                            // after downloading your data you need to save it to your destination url
                                            guard
                                                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                                                let mimeType = response?.mimeType, mimeType.hasPrefix("video"),
                                                let location = location, error == nil
                                                else { return }
                                            do {
                                                try FileManager.default.moveItem(at: location, to: destination)
                                                DispatchQueue.main.async {
                                                    print("file saved")
                                                   self.hideLoader()
                                                    let player = AVPlayer(url: destination)
                                                     let vc = AVPlayerViewController()
                                                    vc.player = player
                                                    
                                                 self.present(vc, animated: true)
                                                       {
                                                   vc.player?.play()
                                                    }
                                                }
                                                                               
                                                
                                            } catch {
                                                 DispatchQueue.main.async {
                                                self.hideLoader()
                                                    let player = AVPlayer(url: fileUrl!)
                                                   let vc = AVPlayerViewController()
                                                  vc.player = player
                                                    self.present(vc, animated: true)
                                                 {
                                                   vc.player?.play()
                                                }
                                                print(error)
                                                }
                                            }
                                        }).resume()
                                    }
                                }
                                

                                  
                               }
                    }
                 else if dict.typedoc  == "Audio" {
                     let path = dict.URL ?? nil
                                          let fileUrl = URL(string: path ?? "")
                                                 if(fileUrl != nil)
                                                 {
                                                  let player = AVPlayer(url: fileUrl!)
                                                     let vc = AVPlayerViewController()
                                                    let myImageView = UIImageView()
                                                    myImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                                                    myImageView.image = UIImage(named:"audiobg")
                                                    myImageView.contentMode = .scaleAspectFit
                                                     vc.contentOverlayView?.addSubview(myImageView)
                                                     vc.player = player
                                                     present(vc, animated: true)
                                                     {
                                                         vc.player?.play()
                                                     }
                                                    
                                                 }
              
                    }
                    
                 else if  dict.typedoc == "FeedThumbNil" {
                 if let dict1 = newsData[rowIndex].lstDocuments?[sender.tag + 1] {
                    if let path = dict1.URL {
                                            let fileUrl = URL(string: path)
                                               if(fileUrl != nil)
                                                  {
                                                                        //***********
                                                                        if let audioUrl = fileUrl {
                                                                            // create your document folder url
                                                                            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                                                                            // your destination file url
                                                                            let destination = documentsUrl.appendingPathComponent(audioUrl.lastPathComponent)
                                                                            print(destination)
                                                                            // check if it exists before downloading it
                                                                            if FileManager().fileExists(atPath: destination.path) {
                                                                                print("The file already exists at path")
                                                                                
                                                                                guard URL.init(string: destination.path) != nil else {
                                                                                    let player = AVPlayer(url: fileUrl!)
                                                                                         let vc = AVPlayerViewController()
                                                                                          vc.player = player
                                                                                          present(vc, animated: true)
                                                                                       {
                                                                                         vc.player?.play()
                                                                                            }
                                                                                return
                                                                                 }
                                                                                do {
                                                                                    
                                                                                    let player = AVPlayer(url: destination)
                                                                                      let vc = AVPlayerViewController()
                                                                                      vc.player = player
                                                                                     present(vc, animated: true)
                                                                                     {
                                                                                        vc.player?.play()
                                                                                       }
                                                                                }
                                                                                
                                                                             
                                                                            } else {
                                                                                self.showLoader()
                                                                                //  if the file doesn't exist
                                                                                //  just download the data from your url
                                                                                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) in
                                                                                    // after downloading your data you need to save it to your destination url
                                                                                    guard
                                                                                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                                                                                        let mimeType = response?.mimeType, mimeType.hasPrefix("video"),
                                                                                        let location = location, error == nil
                                                                                        else { return }
                                                                                    do {
                                                                                        try FileManager.default.moveItem(at: location, to: destination)
                                                                                                  DispatchQueue.main.async {
                                                                                                 self.hideLoader()
                                                                                                    print("file saved")
                                                                                          let player = AVPlayer(url: destination)
                                                                                          let vc = AVPlayerViewController()
                                                                                         vc.player = player
                                                                                       self.present(vc, animated: true)
                                                                                          {
                                                                                          vc.player?.play()
                                                                                                 }
                                                                                           }
                                                                                    } catch {
                                                                                               DispatchQueue.main.async {
                                                                                          self.hideLoader()
                                                                                            let player = AVPlayer(url: fileUrl!)
                                                                                           let vc = AVPlayerViewController()
                                                                                          vc.player = player
                                                                                            self.present(vc, animated: true)
                                                                                         {
                                                                                           vc.player?.play()
                                                                                        }
                                                                                        print(error)
                                                                                        }

                                                                                    }
                                                                                }).resume()
                                                                            }
                                                                        }
                                                                        

                                                                          
                                                                       }
                    }
                    }
                    }
                }
            }
             }
                       else{
                            self.showAlert(Message: Alerts.kNoInternetConnection)
                        }
    }
    
    @IBAction func reportAction(_ sender: UIButton) {
        if checkInternetConnection(){
            
            if newsData[sender.tag].PostedById !=  UserDefaultExtensionModel.shared.currentUserId {
            initializeCustomYesNoAlert(self.view, isHideBlurView: true)
            self.yesNoAlertView.delegate = self
            newsletterId = newsData[sender.tag].NewsLetterId ?? 0
            yesNoAlertView.lblResponseDetailMessage.text = "Do you want to report this post?"
              }
              else{
                strText = "Delete"
                initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                           self.yesNoAlertView.delegate = self
                           newsletterId = newsData[sender.tag].NewsLetterId ?? 0
                          deletedRow = sender.tag
                         yesNoAlertView.lblResponseDetailMessage.text = "Do you want to delete this post?"
                
               }
        }
        else{
            self.showAlert(Message: Alerts.kNoInternetConnection)

        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
//         if checkInternetConnection(){
//        initializeCustomYesNoAlert(self.view, isHideBlurView: true)
//                self.yesNoAlertView.delegate = self
//                yesNoAlertView.lblResponseDetailMessage.text = Alerts.kLogOutAlert
//        }
//               else{
//                   self.showAlert(Message: Alerts.kNoInternetConnection)
//
//               }
        
        if self.checkInternetConnection() {
//            self.showLoader()
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserSearchVC") as! UserSearchVC
//            newViewController.modalPresentationStyle = .fullScreen
//            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
   
    
    //MARK: ScrollView Delegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleRect = CGRect(origin: self.tbleViewNewsFeed.contentOffset, size: self.tbleViewNewsFeed.bounds.size)
               let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
               let indexPath = self.tbleViewNewsFeed.indexPathForRow(at: visiblePoint)
               if indexPath != nil {
                   let cell = self.tbleViewNewsFeed.cellForRow(at: indexPath!) as? EventTableCell
                let offSet = cell?.customCollectionView.contentOffset.x
                let width = cell?.customCollectionView.frame.width
                let horizontalCenter = (width ?? 200) / 2
                if newsData.count > 0 {
                cell?.pageControl.numberOfPages = newsData[indexPath?.row ?? 0].lstDocuments?.count ?? 0
                cell?.pageControl.currentPage = Int((offSet ?? 100) + horizontalCenter) / Int(width ?? 500)
                }

        }
    }

    //MARK:- Other functions
      func SetView()
    {
        tbleViewNewsFeed.dataSource = self
        tbleViewNewsFeed.delegate = self
        self.title = kNewsLetterAndFeedIdentifiers.kNewsLetterAndFeedTitle
        tbleViewNewsFeed.separatorStyle = .none
        tbleViewNewsFeed.tableFooterView = UIView()
//        if  AppDefaults.shared.userImage != ""
//        {
//
//            let image = UIImage(data: try! Data(contentsOf: URL(string: AppDefaults.shared.userImage)! ))
//
//            let thumb1 = image?.resized(toWidth: 32.0)
//            self.button.image = thumb1
//            self.button.clipsToBounds = true
//            //  self.button.layer.masksToBounds = true
//
//
//        }
//        else {
//            button.image = UIImage(named: "profileImage")
//        }
    
    }
    
    @IBAction func likerList(_ sender: UIButton) {
       if checkInternetConnection(){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: KStoryBoards.kNewsfeedAndLetter, bundle: nil)
                   let newViewController = storyBoard.instantiateViewController(withIdentifier: "LikerListVC") as! LikerListVC
                   newViewController.modalPresentationStyle = .fullScreen
        newViewController.postId = newsData[sender.tag].NewsLetterId ?? 0
            self.navigationController?.pushViewController(newViewController, animated: true)


                                               }
                         else{
                              self.showAlert(Message: Alerts.kNoInternetConnection)
                          }
    }

    @IBAction func openOtherUserProfile(_ sender: UIButton) {
        if checkInternetConnection(){
//              let storyBoard: UIStoryboard = UIStoryboard(name: "NewsFeedAndLetter", bundle: nil)
//               let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileNewsFeedVC") as! ProfileNewsFeedVC
//                 newViewController.status = newsData[sender.tag].Bio ?? ""
//                    newViewController.otherUserId = newsData[sender.tag].PostedById ?? 0
//                      newViewController.viewprofile = "true"
//                      newViewController.emailOtheruser = newsData[sender.tag].Email ?? ""
//                      newViewController.img = newsData[sender.tag].PostedByImageUrl ?? ""
//                      newViewController.name = newsData[sender.tag].PostedBy ?? ""
//            if newsData[sender.tag].PostedById !=  UserDefaultExtensionModel.shared.currentUserId {
//                newViewController.role = "other"
//            }
//                       newViewController.modalPresentationStyle = .fullScreen
//                     self.navigationController?.pushViewController(newViewController, animated: true)
                  

                                        }
                  else{
                       self.showAlert(Message: Alerts.kNoInternetConnection)
                   }
        
    }
    
    @IBAction func actionCorr(_ sender: UIButton) {
         if checkInternetConnection(){
        
//            if newsData[sender.tag].TypeId == 1 {
//             let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CorridorConVC") as! CorridorConVC
//                userIdOther = newsData[sender.tag].PostedById ?? 0
//
//                if userIdOther != UserDefaultExtensionModel.shared.currentUserId {
//                     str_Role = "other"
//                }
//                else{
//                    str_Role = ""
//                }
//
//                 newViewController.modalPresentationStyle = .fullScreen
//                self.navigationController?.pushViewController(newViewController, animated: true) }
//            else{
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ThisThatVC") as! ThisThatVC
//                                       userIdOther = newsData[sender.tag].PostedById ?? 0
//                                  if userIdOther != UserDefaultExtensionModel.shared.currentUserId {
//                                                      str_Role = "other"
//                                                 }
//                                                 else{
//                                                     str_Role = ""
//                                                 }
//                                       newViewController.modalPresentationStyle = .fullScreen
//                              self.navigationController?.pushViewController(newViewController, animated: true)
//            }
//
            }
         else{
             self.showAlert(Message: Alerts.kNoInternetConnection)

         }
     }
    
        
}
//MARK:- Table View Data Source

extension NewsLetterAndFeedVC : UITableViewDataSource,UITableViewDelegate{
    
    //Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    
    
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          if self.newsData.count > 0
          {
          if self.newsData[indexPath.row] != nil {
            let dic = self.newsData[indexPath.row]
              if dic.TypeId != nil {
                 return 160
              }
              else{
                      return UITableView.automaticDimension

                }
            }
          }
           return UITableView.automaticDimension
      }

    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
      
        let  cell = tableView.dequeueReusableCell(withIdentifier: kNewsLetterAndFeedIdentifiers.kEventTableCell, for: indexPath) as! EventTableCell //delIcon
                
        cell.btnLikes.tag = indexPath.row
         cell.btnLikerList.tag = indexPath.row
         cell.btnComments.tag = indexPath.row
         cell.btnShare.tag = indexPath.row
        cell.btnReport.tag = indexPath.row
        cell.customCollectionView.tag = indexPath.row
        cell.collectionViewTag.tag = indexPath.row
         cell.btnProfile.tag = indexPath.row
        cell.btnCorr.tag = indexPath.row
        if newsData.count > 0 {
            
                if self.newsData[indexPath.row] != nil {
                    if let dic = self.newsData[indexPath.row] as? NewsListResultData {
              
            if self.newsData[indexPath.row].PostedById ==  UserDefaultExtensionModel.shared.currentUserId {
                       cell.imgReport.image =  UIImage(named: "delIcon")
                   }
            else{
                 cell.imgReport.image =  UIImage(named: "report")
            }
            cell.lblName.text = dic.PostedBy
            cell.lblDate.text = dic.strCreatedDate

        let noOfLikes   = "\(String(describing: dic.TotalLikes!))"
        cell.btnLikes.setTitle(noOfLikes, for: .normal)
        let noOfComments   = "\(String(describing: dic.TotalComments!))"
        cell.btnComments.setTitle(noOfComments, for: .normal)

            cell.lblDescription.text = dic.Description?.trimTrailingWhitespaces()
            
        if dic.LikedByMe == 1 {
            cell.likeImage.image = UIImage(named: "like")
        }
        else {
             cell.likeImage.image = UIImage(named: "unlike")
        }
                        
                        self.taggedUsersData = dic.TaggedUsers
                                  
                                   if  dic.TaggedUsers != nil {
                                  if  dic.TaggedUsers!.count == 0 {
                                      cell.topSpaceCollImages.constant = -27
                                   //   cell.heightCollectionViewTag.constant = 1
                                      }

                                     else {
                                      cell.topSpaceCollImages.constant = 1
                                 //    cell.heightCollectionViewTag.constant = 27
                                      }
                                  }
                                  else{
                                      cell.topSpaceCollImages.constant = -34
                                   // cell.heightCollectionViewTag.constant = 1
                                   
                                  }
                        cell.collectionViewTag.reloadData()

            
            self.lstDocuments  = dic.lstDocuments
            
            if self.lstDocuments?.count == 0 || self.lstDocuments == nil{
            cell.heightCollectionView.constant = 0
            let hexStr = dic.ColorCode ?? ""
            if hexStr == "" || hexStr == "#FFFFFF" {
                cell.lblDescription.textAlignment = .left
                cell.lblDescription.SetLabelFont(textSize: 15)
                cell.lblDescription.backgroundColor = UIColor.white
                cell.lblDescription.textColor = UIColor.black
            }
            else {
              cell.lblDescription.topInset = 10
              cell.lblDescription.bottomInset = 10
                cell.lblDescription.SetLabelFont(textSize: 17)

                if #available(iOS 11.0, *) {
                    let color = UIColor(named: hexStr)
                     cell.lblDescription.backgroundColor = color//
                } else {
                    // Fallback on earlier versions
                }
//            cell.lblDescription.backgroundColor = color//
            cell.lblDescription.textAlignment = .center
                cell.lblDescription.textColor = UIColor.black

            }
            }
           else{
            cell.lblDescription.backgroundColor = UIColor.white
             cell.heightCollectionView.constant = 270
            cell.lblDescription.textAlignment = .left
                cell.lblDescription.textColor = UIColor.black
            cell.lblDescription.SetLabelFont(textSize: 15)
            cell.customCollectionView.reloadData()
            }
                        
            
            
            
            if self.lstDocuments?[0].typedoc == "Image" {
                
                if self.lstDocuments?.count ?? 0 > 1 {
                cell.pageControl.isHidden = false
                 cell.pageControl.numberOfPages = self.newsData[indexPath.row].lstDocuments?.count ?? 0
                }
                else{
                  cell.pageControl.isHidden = true
                           }
            }
                
            else{
                cell.pageControl.isHidden = true

            }
            
           
            
           if  dic.PostedByImageUrl ?? "" != ""
                      {
                        let url = dic.PostedByImageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""

                        cell.imgViewProfile.sd_setImage(with: URL(string: url ), placeholderImage: UIImage(named: "profile"), options: SDWebImageOptions(rawValue: 0))
                          { (image, error, cacheType, imageURL) in
                              cell.imgViewProfile.image = image
                          }
                      }
                      else {
                          cell.imgViewProfile.image = UIImage(named: "profile")
                      }
                        
                        if dic.TypeId != nil {
                            cell.btnCorr.isHidden = false
                            cell.lblDescription.rightInset = 45
                            cell.viewBGG.isHidden = true
                            cell.heightBGGView.constant = 0

                       
                            
                        }
                        else {
                             cell.btnCorr.isHidden = true
                            cell.lblDescription.rightInset = 0
                            cell.viewBGG.isHidden = false
                              cell.heightBGGView.constant = 41

                        }
                }
        }
   
        
    }
        return cell
    }
}
//MARK:- Collection View Data Source
extension NewsLetterAndFeedVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
  
        let parentCollectionView = collectionView.superview?.superview?.superview as? EventTableCell
        
        if collectionView == parentCollectionView?.collectionViewTag {
            let count =  taggedUsersData?.count ?? 0
           
            return count
        }
        else{
        
        if lstDocuments?.count ?? 0 > 0 && lstDocuments != nil {
            var boolThum = false
            for (_, value) in (newsData[collectionView.tag].lstDocuments?.enumerated())! {
                  if  value.typedoc == "FeedThumbNil" {
                    boolThum = true
                }
            }
            
            if boolThum == true {
                 boolThum = false
                return 1
            }
            else{
             return lstDocuments?.count ?? 0
            }
            
        }
        else{
            return taggedUsersData?.count ?? 0
        }
        }
        
       return taggedUsersData?.count ?? 0
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let parentCollectionView = collectionView.superview?.superview?.superview as? EventTableCell
        
       if collectionView.isEqual(parentCollectionView?.customCollectionView )  {
          
                    let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: "CellClass_UploadPosts", for: indexPath)as! CellClass_UploadPosts
                    // cellnew.btnPlay = UIButton()
                    cellnew.btnPlay.frame = CGRect(x: self.view.frame.origin.x + self.view.frame.size.width / 2 - 30 , y: cellnew.ivImg.frame.origin.y + cellnew.ivImg.frame.size.height / 2 - 30, width: 54, height: 54)
                      cellnew.btnPlay.tag = indexPath.row

                    if let dic = newsData[collectionView.tag] as? NewsListResultData{
                        if newsData[collectionView.tag].lstDocuments?[indexPath.row] != nil {
                    if let typeDoc = newsData[collectionView.tag].lstDocuments?[indexPath.row].typedoc {
                        
                        if typeDoc == "Image" {
                            cellnew.lblCount.isHidden = true
                            if let aa = newsData[collectionView.tag].lstDocuments?.count {
                                if aa == 1 {
                                      cellnew.lblCount.text = "Photo Count: \(String(describing: aa))"
                                }
                                else {
                                      cellnew.lblCount.text = "Photos Count: \(String(describing: aa))"
                                }
                                 }
                           cellnew.btnPlay.isHidden = true
                            
                            if let imgProfileUrl = newsData[collectionView.tag].lstDocuments?[indexPath.row].URL {
                                let url = imgProfileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

                                cellnew.ivImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                cellnew.ivImg.sd_setImage(with: URL.init(string: url)) { (img, error, cacheType, url) in
                                    
                                    if error == nil{
                                        cellnew.ivImg.contentMode = .scaleToFill
                                        cellnew.ivImg.image = img
//                                      let size = CGSize(width: cellnew.ivImg.frame.size.width, height: 350)
//                                     cellnew.ivImg.image = self.imageWithImage(image: img!, scaledToSize: size)
                                    
                                    }else{
                                    }
                                }
                            }else{
                               
               }
                            }
                    
                        else if typeDoc == "Video" {
                            cellnew.lblCount.isHidden = true
                           cellnew.btnPlay.isHidden = false
                           cellnew.btnPlay.isUserInteractionEnabled = true
                            if newsData[collectionView.tag].lstDocuments?.count ?? 0 >= 2 {
                                     
                                        
                                for (_, value) in (newsData[collectionView.tag].lstDocuments?.enumerated())! {
                                    if  value.typedoc == "FeedThumbNil" {
                                        
                                        if let imgProfileUrl =   value.URL {
                                            cellnew.ivImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                            let url = imgProfileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                                            cellnew.ivImg.sd_setImage(with: URL.init(string: url)) { (img, error, cacheType, url) in
                                                                 
                                                                 if error == nil{
                                                                     print("error is NilLiteralConvertible")
                                                                    cellnew.ivImg.contentMode = .scaleAspectFill
                                                                      cellnew.ivImg.image = img
                                                                 }else{
                                                                    cellnew.ivImg.image = UIImage(named:"scenic")
                                                                 }
                                                             }
                                                         }else{
                                                        cellnew.ivImg.image = UIImage(named:"scenic")
                                            }
                                    }
                                
                                }
                                        
                        
                            }
                            else{
                                 cellnew.ivImg.image = UIImage(named:"scenic")
                            }
                           cellnew.ivImg.bringSubviewToFront(cellnew.btnPlay)
                    }
                    
                        else if typeDoc == "Audio"{
                            cellnew.lblCount.isHidden = true
                            cellnew.btnPlay.isHidden = false
                                          cellnew.btnPlay.isUserInteractionEnabled = true
                                          cellnew.ivImg.image = UIImage(named:"audiobg")
                                          cellnew.ivImg.bringSubviewToFront(cellnew.btnPlay)
                    }
                      else if typeDoc == "FeedThumbNil"{
                            cellnew.lblCount.isHidden = true
                                   cellnew.btnPlay.isHidden = false
                                   cellnew.btnPlay.isUserInteractionEnabled = true
                   if let dic = newsData[collectionView.tag] as? NewsListResultData {
                if newsData[collectionView.tag].lstDocuments != nil {
                                        for (_, value) in (newsData[collectionView.tag].lstDocuments?.enumerated())! {
                                            if  value.typedoc == "FeedThumbNil" {
                                                
                                                if let imgProfileUrl =   value.URL {
                                                    let url = imgProfileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

                                                                     cellnew.ivImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                                                     cellnew.ivImg.sd_setImage(with: URL.init(string: url)) { (img, error, cacheType, url) in
                                                                         
                                                                         if error == nil{
                                                                             print("error is NilLiteralConvertible")
                                                                            cellnew.ivImg.contentMode = .scaleAspectFill
                                                                           cellnew.ivImg.image = img

                                                                         }else{
                                                                            cellnew.ivImg.image = UIImage(named:"scenic")
                                                                         }
                                                                     }
                                                                 }else{
                                                                cellnew.ivImg.image = UIImage(named:"scenic")
                                                    }
                                            }
                                        
                                        }
                            }
                        }
                                   cellnew.ivImg.bringSubviewToFront(cellnew.btnPlay)
                        }
                    
                    if newsData[collectionView.tag].lstDocuments?[indexPath.row].IsPlaying == false{
                                   cellnew.btnPlay.setImage(UIImage(named: "playVideo"), for: .normal)
                               }
                               else {
                                   cellnew.btnPlay.setImage(UIImage(named: "pause"), for: .normal)
                               }
                    }
                    }
                    }
                    else{ //noimage
                                   
                                   cellnew.btnPlay.isHidden = true
                                cellnew.ivImg.image = UIImage(named:"noimage")
                           }
                    return cellnew
        }
        
        
          else {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! tagCell
          if (newsData[collectionView.tag].TaggedUsers?[indexPath.row]) != nil {
            cell.lblName.text = "@" + (newsData[collectionView.tag].TaggedUsers?[indexPath.row].Name ?? "")
              return cell
        }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
       {
    let parentCollectionView = collectionView.superview?.superview?.superview as? EventTableCell
        
        if collectionView.isEqual(parentCollectionView?.collectionViewTag)  {
            
            var text : String = ""
                    if (newsData[collectionView.tag].TaggedUsers?[indexPath.row]) != nil {
                       text = "@" + (newsData[collectionView.tag].TaggedUsers?[indexPath.row].Name ?? "") + "  "}
                    return text.size(withAttributes: nil)
            
            
            //return CGSize(width: 114, height: 30)
        }
        else{
             let frame = collectionView.frame
            return CGSize(width: self.view.frame.size.width - 16, height: frame.size.height)
        

        }
}
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let parentCollectionView = collectionView.superview?.superview?.superview as? EventTableCell

          if collectionView == parentCollectionView?.collectionViewTag {
                if checkInternetConnection(){
//                      let storyBoard: UIStoryboard = UIStoryboard(name: "NewsFeedAndLetter", bundle: nil)
//                       let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileNewsFeedVC") as! ProfileNewsFeedVC
//                    newViewController.status = newsData[collectionView.tag].TaggedUsers?[indexPath.row].Bio ?? ""
//                    newViewController.otherUserId = newsData[collectionView.tag].TaggedUsers?[indexPath.row].Id ?? 0
//                              newViewController.viewprofile = "true"
//                    newViewController.emailOtheruser = newsData[collectionView.tag].TaggedUsers?[indexPath.row].Email ?? ""
//                    newViewController.img = newsData[collectionView.tag].TaggedUsers?[indexPath.row].ImageUrl ?? ""
//                    newViewController.name = newsData[collectionView.tag].TaggedUsers?[indexPath.row].Name ?? ""
//                    if newsData[collectionView.tag].TaggedUsers?[indexPath.row].Id !=  UserDefaultExtensionModel.shared.currentUserId {
//                        newViewController.role = "other"
//                    }
//                               newViewController.modalPresentationStyle = .fullScreen
//                             self.navigationController?.pushViewController(newViewController, animated: true)
//

                                                }
                          else{
                               self.showAlert(Message: Alerts.kNoInternetConnection)
                           }
                
            }
            
        
          else{
             if checkInternetConnection(){
        imageNames.removeAll()
        if let imgProfileUrl = newsData[collectionView.tag].lstDocuments?[indexPath.row].URL {
            let url = imgProfileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

            if newsData[collectionView.tag].lstDocuments?[indexPath.row].typedoc == "Image" {
                if  url != "" {
                  self.ShowLoader()
                 imageNames.append(url)
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = false
      
        present(gallery, animated: true, completion: nil)
                }
            }
        }
        }
             else{
                self.showAlert(Message: Alerts.kNoInternetConnection)

            }
        }
    }
    
}
extension NewsLetterAndFeedVC : UICollectionViewDelegateFlowLayout{
    
}

extension NewsLetterAndFeedVC : ViewDelegate {
    
    func showAlert(alert: String) {
         initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }
    
    func showLoader() {
          self.ShowLoader()
    }
    
    func hideLoader() {
        self.HideLoader()
    }
    
}

extension NewsLetterAndFeedVC : AddPostDelegate {
    func addedSuccessfully(result: Int) {
        newsData[likedDta ?? 0].TotalLikes = result
               self.tbleViewNewsFeed.reloadData()
    }
    
    func CommentData(data: [lstgetCommentViewList]?) {}
    
    func LikerList(data: [lstgetLikesListViewModels]) {}
    
    func displayData(data: [NewsListResultData]) {
         isFetching = true
        self.refreshControl.endRefreshing()

        if data.count > 0 {
            newsData.append(contentsOf: data)
            if let token = UserDefaults.standard.string(forKey: "token") {
                       self.viewModel?.deviceTokenApi(DeviceType: "3",DeviceToken:  token,UserId:UserDefaultExtensionModel.shared.currentUserId) }
            tbleViewNewsFeed.reloadData()
        }
    }
    
    func attachmentDeletedSuccessfully() {
        if deletedRow != nil {
            let indexPath = IndexPath(item: deletedRow ?? 0, section: 0)
            print(indexPath)
            self.newsData.remove(at: indexPath.row)
            tbleViewNewsFeed.reloadData()
        }
    }
}


extension UITableView {
    
    func indexPathForView(_ view: UIView) -> IndexPath? {
         let center = view.center
         let viewCenter = self.convert(center, from: view.superview)
         let indexPath = self.indexPathForRow(at: viewCenter)
         return indexPath
     }

}
extension NewsLetterAndFeedVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
            
            if newsletterId != 0 {
               
                if strText == "Delete" {
                    strText = ""
                            self.viewModel?.deletePost(UserId: UserDefaultExtensionModel.shared.currentUserId, NewsLetterId: newsletterId)
                        }
                else{
                     self.viewModel?.reportApi(IssueReportedId: 0, ReportId: 1, NewsletterId: newsletterId , UserId: UserDefaultExtensionModel.shared.currentUserId)}
                 newsletterId = 0
            }
            else{
             self.viewModel?.logout(userId:  UserDefaultExtensionModel.shared.currentUserId, deviceType:3)
               // CommonFunctions.sharedmanagerCommon.setRootLogin()
            }
            
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}


extension NewsLetterAndFeedVC : SwiftPhotoGalleryDataSource,SwiftPhotoGalleryDelegate {
    
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return imageNames.count
    }

    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        
        if imageNames[forIndex] != ""
                   {
             let url = URL(string:imageNames[forIndex])
                    
                    if url != nil {
                  if let data = try? Data(contentsOf: url!)
                  {
                    let image: UIImage = UIImage(data: data) ?? UIImage(named: "profile")!
                      self.HideLoader()
                    return image
                    
                        }}
        }
                   else {
                        self.HideLoader()
                       return UIImage(named: "profile")
                   }
        self.HideLoader()
        return UIImage(named: "profile")
    }

    // MARK: SwiftPhotoGalleryDelegate Methods

    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }
}
//MARK:- Scroll View delegates
extension NewsLetterAndFeedVC : UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (tbleViewNewsFeed.contentOffset.y < pointNow.y)
        {
            CommonFunctions.sharedmanagerCommon.println(object: "Down scroll view")
            isScrolling = true
        }
        else if (tbleViewNewsFeed.contentOffset.y + tbleViewNewsFeed.frame.size.height >= tbleViewNewsFeed.contentSize.height)
        {
            isScrolling = true
            if (isFetching == true)
            {
                skip = skip + KIntegerConstants.kInt10
                print(skip)
                isFetching = false
                  self.viewModel?.getData(Search: "",Skip: skip,PageSize: pageSize,SortColumnDir : "",SortColumn: "",ParticularId: 0)

            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
}

extension NewsLetterAndFeedVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
        
       
    }
}
extension String {
    func trimTrailingWhitespaces() -> String {
        return self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
}


