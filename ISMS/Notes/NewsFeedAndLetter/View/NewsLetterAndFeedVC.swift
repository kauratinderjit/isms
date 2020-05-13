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

class NewsLetterAndFeedVC: UIViewController {
    //MARK:- Outlat and Variables
    @IBOutlet weak var tbleViewNewsFeed: UITableView!
    @IBOutlet weak var btnBulletin: UIButton!
    @IBOutlet weak var btnNewsletter: UIButton!
    @IBOutlet weak var btnEvents: UIButton!
    var viewModel : UploadPostViewModel?
    var newsData : [NewsListResultData]?
    var lstDocuments: [lstDocuments]?
    var player = AVQueuePlayer()
    let formatter: DateFormatter = {
                 let formatter = DateFormatter()
                 formatter.dateFormat = "dd/MM/yyyy, h:mm a"
                 return formatter
         }()
       
    let dateFormatter = DateFormatter()
    var playAudioIndex : Int?
    
    
    
    //MARK:- lifecycle Methods
    override func viewDidLoad()
    {
    super.viewDidLoad()
       SetView()
     self.viewModel = UploadPostViewModel.init(delegate: self)
            self.viewModel?.attachView(viewDelegate: self)
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if checkInternetConnection(){
         getNewfeedData()
        }
       else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    //MARK:- Actions
    
    override func viewDidDisappear(_ animated: Bool) {
        stopAudio()
    }
    
    @IBAction func actionAddPost(_ sender: UIButton) {
        if checkInternetConnection(){
                let storyboard = UIStoryboard.init(name: KStoryBoards.kHomeWork, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddNewsFeedPostsVC") as? AddNewsFeedPostsVC
                let frontVC = revealViewController().frontViewController as? UINavigationController
                frontVC?.pushViewController(vc!, animated: false)
                 revealViewController().pushFrontViewController(frontVC, animated: true)
                                    }
              else{
                   self.showAlert(Message: Alerts.kNoInternetConnection)
               }
      
    }
    
    func getNewfeedData() {
        self.viewModel?.getData()
    }
    
    
    @IBAction func actionWhatOnMind(_ sender: UIButton) {
        
        if checkInternetConnection(){
                let storyboard = UIStoryboard.init(name: KStoryBoards.kHomeWork, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddNewsFeedPostsVC") as? AddNewsFeedPostsVC
                let frontVC = revealViewController().frontViewController as? UINavigationController
                frontVC?.pushViewController(vc!, animated: false)
                 revealViewController().pushFrontViewController(frontVC, animated: true)
                                    }
              else{
                   self.showAlert(Message: Alerts.kNoInternetConnection)
               }
    }
    
    
    @IBAction func btnTabActions(_ sender: UIButton)
    {
    
    }
    
    
    @IBAction func actionLike(_ sender: UIButton) {
          if checkInternetConnection(){
            
            var liked = false
            if newsData?[sender.tag].LikedByMe == 0 {
                liked = true
            }
            else {
                 liked = false
            }
            self.viewModel?.likePost(PostId: newsData?[sender.tag].NewsLetterId ?? 0, LikedBy: UserDefaultExtensionModel.shared.userRoleParticularId, IsLiked: liked)
               }
        else{
             self.showAlert(Message: Alerts.kNoInternetConnection)
         }
        
    }
    
    @IBAction func actionComment(_ sender: UIButton) {
        
        
        if checkInternetConnection(){
                      let storyboard = UIStoryboard.init(name: KStoryBoards.kHomeWork, bundle: nil)
                      let vc = storyboard.instantiateViewController(withIdentifier: "CommentVC") as? CommentVC
                      let frontVC = revealViewController().frontViewController as? UINavigationController
                      frontVC?.pushViewController(vc!, animated: false)
                       revealViewController().pushFrontViewController(frontVC, animated: true)
                                          }
                    else{
                         self.showAlert(Message: Alerts.kNoInternetConnection)
                     }
    }
    
    @IBAction func actionShare(_ sender: UIButton) {
        let text = "This is the post"
        let image = UIImage(named: "scenic")
        let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
        let shareAll = [text , image! , myWebsite!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: Play button for videos and audios
    @IBAction func playButton(_ sender: UIButton) {
        

        let buttonPostion = sender.convert(sender.bounds.origin, to: tbleViewNewsFeed)

               if let indexPath = tbleViewNewsFeed.indexPathForRow(at: buttonPostion) {
                   let rowIndex =  indexPath.row
                   print(rowIndex)
                   playAudioIndex = rowIndex
                if var dict = newsData?[rowIndex].lstDocuments?[sender.tag] {
                 if dict.typedoc == "Video" {

                     let path = dict.URL ?? nil
                        let fileUrl = URL(string: path ?? "")
                               if(fileUrl != nil)
                               {
                                let player = AVPlayer(url: fileUrl!)
                                   let vc = AVPlayerViewController()
                                   vc.player = player
                                   present(vc, animated: true)
                                   {
                                       vc.player?.play()
                                   }
                                  
                               }
                    }
                 else if dict.typedoc  == "Audio" {
                     
                    if dict.IsPlaying == false {

                        let path = dict.URL ?? nil
                       let fileUrl = URL(string: path ?? "")
                        if(fileUrl != nil)
                                                {
                                            player.removeAllItems()
                                           player.insert(AVPlayerItem(url: fileUrl!), after: nil)
                                           player.play()
                                           sender.setImage(UIImage(named: "pause"), for: .normal)
                                                    newsData?[rowIndex].lstDocuments?[sender.tag].IsPlaying = true
                                                   
                                                    // Add Observer
                                                      player.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
                                                      player.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
                                                      player.currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
                                                    
                                                    
                                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                                                            
                                     NotificationCenter.default.addObserver(self, selector: #selector(self.handleAudioInterruption), name: AVAudioSession.interruptionNotification, object: nil)
                                                      
                                                      
                                                      do {
                                                          try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.mixWithOthers)
                                                          
                                                          do {
                                                              try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                                                          } catch let error as NSError {
                                                              print(error.localizedDescription)
                                                          }
                                                      } catch let error as NSError {
                                                          print(error.localizedDescription)
                                                      }
                                                    
                                   tbleViewNewsFeed.reloadData()
                                      }
                    }
                    
                    else {
                        
//                       let arrays =  newsData?.filter({ (element) -> Bool in
//                        let doc = element.lstDocuments?.filter({ (element) -> Bool in
//
////                            if element.IsPlaying == true {
////                              //  element.IsPlaying = false
////                                guard let index = array.index(where: {$0.title == "slow"}) else { return }
////                                print("item", index)
////                            }
////
//
//                        })
//
//                        })
                        
                                              stopAudio()
                                              NotificationCenter.default.removeObserver(self)
                                             
                                              newsData?[rowIndex].lstDocuments?[sender.tag].IsPlaying = false
                                              player.pause()
                                              player.replaceCurrentItem(with: nil)
                                              tbleViewNewsFeed.reloadData()
                                           
                                       }
                                       
                    }
                
                }
               }
        
                
    }
    
    //MARK:Audio Methods
    
    @objc func handleAudioInterruption(notification: NSNotification) {
        if notification.name != AVAudioSession.interruptionNotification || notification.userInfo == nil {
            return
        }
        
        if let typeKey = notification.userInfo? [AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeKey) {
            switch type {
            case .began:
                print("began")
                break
                
            case .ended:
                print("ended")
                break
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "playbackBufferEmpty" {
            print("Show loader")
            
        } else if keyPath == "playbackLikelyToKeepUp" {
            print("Hide loader 1")
           hideLoader()
            
        } else if keyPath == "playbackBufferFull" {
            print("Hide loader 2")
           hideLoader()
        }
    }
    
    func stopAudio() {
        
        player.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: nil)
        player.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: nil)
        player.currentItem?.removeObserver(self, forKeyPath: "playbackBufferFull", context: nil)
        
        if (player.rate != 0 && player.error == nil) {
              player.pause()
              player.removeAllItems()
        }
    }
    
    //MARK: - Audio Player Handles
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        print("Audio End")
        
        stopAudio()
        NotificationCenter.default.removeObserver(self)
        newsData?[playAudioIndex ?? 0].lstDocuments?[0].IsPlaying = false
            tbleViewNewsFeed.reloadData()
            
            
        }
  

    
    //MARK:- Other functions
      func SetView()
    {
       tbleViewNewsFeed.dataSource = self
        tbleViewNewsFeed.delegate = self
        self.title = kNewsLetterAndFeedIdentifiers.kNewsLetterAndFeedTitle
        tbleViewNewsFeed.separatorStyle = .none
        tbleViewNewsFeed.tableFooterView = UIView()
         setBackButton()
        
    }

   

}
//MARK:- Table View Data Source
extension NewsLetterAndFeedVC : UITableViewDataSource,UITableViewDelegate{
    
    //Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
      
        let  cell = tableView.dequeueReusableCell(withIdentifier: kNewsLetterAndFeedIdentifiers.kEventTableCell, for: indexPath) as! EventTableCell
        cell.btnLikes.tag = indexPath.row
         cell.btnComments.tag = indexPath.row
         cell.btnShare.tag = indexPath.row
        if let dic = newsData?[indexPath.row] {
       // cell.imgViewProfile.image = dic?.
            cell.lblName.text = dic.PostedBy
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        if let dateFinal =  dateFormatter.date(from: dic.PostedDate ?? "") {
                            let dd = formatter.string(from: dateFinal)
                            cell.lblDate.text = dd
                        }
        let noOfLikes   = "\(String(describing: dic.TotalLikes!))"
        cell.btnLikes.setTitle(noOfLikes, for: .normal)
        let noOfComments   = "\(String(describing: dic.TotalComments!))"
        cell.btnComments.setTitle(noOfComments, for: .normal)
        if dic.LikedByMe == 1{
            cell.likeImage.image = UIImage(named: "like")
        }
        else {
             cell.likeImage.image = UIImage(named: "unlike")
        }
            
            lstDocuments  = dic.lstDocuments
            cell.customCollectionView.reloadData()
            
           
            
       
        }
        return cell
    }
    
    // Table Delegate methods
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 274
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
     return 274
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let storyboard = UIStoryboard.init(name: KStoryBoards.kExamResult, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: kExamResultIdentifiers.kExamResultVC)
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
extension NewsLetterAndFeedVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return lstDocuments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: "CellClass_UploadPosts", for: indexPath)as! CellClass_UploadPosts
        // cellnew.btnPlay = UIButton()
                        cellnew.btnPlay.frame = CGRect(x: cellnew.ivImg.frame.origin.x + cellnew.ivImg.frame.size.width / 2 - 30 , y: cellnew.ivImg.frame.origin.y + cellnew.ivImg.frame.size.height / 2 - 30, width: 54, height: 54)
                        cellnew.btnPlay.tag = indexPath.row
                       

       if let typeDoc = lstDocuments?[indexPath.row].typedoc {
            
            if typeDoc == "Image" {
               cellnew.btnPlay.isHidden = true
                if let imgProfileUrl = lstDocuments?[indexPath.row].URL {
                    cellnew.ivImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cellnew.ivImg.sd_setImage(with: URL.init(string: imgProfileUrl)) { (img, error, cacheType, url) in
                        
                        if error == nil{
                            print("error is NilLiteralConvertible")
                            cellnew.ivImg.contentMode = .scaleAspectFill
                            cellnew.ivImg.image = img
                        }else{
                        }
                    }
                }else{
   }
                }
                
            
        
            else if typeDoc == "Video" {
               cellnew.btnPlay.isHidden = false
               cellnew.btnPlay.isUserInteractionEnabled = true
               cellnew.ivImg.image = UIImage(named:"scenic")
               cellnew.ivImg.bringSubviewToFront(cellnew.btnPlay)
        }
        
            else{
                
                cellnew.btnPlay.isHidden = false
                              cellnew.btnPlay.isUserInteractionEnabled = true
                              cellnew.ivImg.image = UIImage(named:"audiobg")
                              cellnew.ivImg.bringSubviewToFront(cellnew.btnPlay)
        }
        
        
        if lstDocuments?[indexPath.row].IsPlaying == false{
                       cellnew.btnPlay.setImage(UIImage(named: "playVideo"), for: .normal)
                   }
                   else {
                       cellnew.btnPlay.setImage(UIImage(named: "pause"), for: .normal)
                   }
        }
       
      
        return cellnew
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
       {
           let frame = collectionView.frame
        return CGSize(width: self.view.frame.size.width - 16, height: frame.size.height)
       }
    
    
}

extension NewsLetterAndFeedVC : UICollectionViewDelegateFlowLayout
{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        let frame = collectionView.frame
//        return CGSize(width: frame.size.width, height: frame.size.height)
//    }
    
  
}
extension NewsLetterAndFeedVC : ViewDelegate {
    
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

extension NewsLetterAndFeedVC : AddPostDelegate {
    func displayData(data: [NewsListResultData]) {
        if data.count > 0 {
            newsData = data
            tbleViewNewsFeed.reloadData()
        }
    }
    
    func attachmentDeletedSuccessfully() {
        
    }
    
    func addedSuccessfully() {
      getNewfeedData()
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
