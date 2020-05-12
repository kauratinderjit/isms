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
    
    
    
    
    //MARK:- lifecycle Methods
    override func viewDidLoad()
    {
    super.viewDidLoad()
       SetView()
     self.viewModel = UploadPostViewModel.init(delegate: self)
            self.viewModel?.attachView(viewDelegate: self)
       //  var dict = [String: Any]()
//        dict["url"] = "https://stgsd.appsndevs.com/ISMSQA/Uploads/NewsLetterVideos/202005_11-181425cameraRecorder1_20200511180417465.mp4"
//        dict["type"] = "video"
//        newsData.add(dict)
//         var dict1 = [String: Any]()
//        dict1["url"] = "https://stgsd.appsndevs.com/ISMSQA/Uploads/NewsLetterAudios/11-05-2020-11-23-43_20200511111519964.m4a"
//        dict1["type"] = "audio"
//          newsData.add(dict1)
//        var dict2 = [String: Any]()
//           dict2["url"] = "https://stgsd.appsndevs.com/ISMSQA/Uploads/NewsLetterAudios/11-05-2020-11-23-43_20200511111519964.m4a"
//           dict2["type"] = "image"
//                 newsData.add(dict2)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getNewfeedData()
    }
    //MARK:- Actions
    
    @IBAction func actionAddPost(_ sender: UIButton) {
         let storyboard = UIStoryboard.init(name: KStoryBoards.kHomeWork, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AddNewsFeedPostsVC") as? AddNewsFeedPostsVC
                    let frontVC = revealViewController().frontViewController as? UINavigationController
                    frontVC?.pushViewController(vc!, animated: false)
                    revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    
    func getNewfeedData() {
        self.viewModel?.getData()
    }
    
    
    @IBAction func actionWhatOnMind(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: KStoryBoards.kHomeWork, bundle: nil)
                     let vc = storyboard.instantiateViewController(withIdentifier: "AddNewsFeedPostsVC") as? AddNewsFeedPostsVC
                     let frontVC = revealViewController().frontViewController as? UINavigationController
                     frontVC?.pushViewController(vc!, animated: false)
                     revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    
    
    @IBAction func btnTabActions(_ sender: UIButton)
    {
    
    }
    
    
    @IBAction func actionLike(_ sender: UIButton) {
    }
    
    @IBAction func actionComment(_ sender: UIButton) {
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
    
    
    @IBAction func playButton(_ sender: UIButton) {
                if let dict = lstDocuments?[sender.tag] {
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

                let path = dict.URL as? String ?? nil
                  let fileUrl = URL(string: path ?? "")
                   if(fileUrl != nil)
                                           {
                                     player.removeAllItems()
                                            player.insert(AVPlayerItem(url: fileUrl!), after: nil)
                                     player.play()

                                 }
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
                        cellnew.btnPlay.frame = CGRect(x: cellnew.ivImg.frame.origin.x + cellnew.ivImg.frame.size.width / 2 , y: cellnew.ivImg.frame.origin.y + cellnew.ivImg.frame.size.height / 2 - 30, width: 54, height: 54)
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
        
    }
  
}


