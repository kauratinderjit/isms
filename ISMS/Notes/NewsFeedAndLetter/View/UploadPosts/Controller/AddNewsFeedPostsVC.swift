//
//  AddNewsFeedPostsVC.swift
//  ISMS
//
//  Created by Mohit Sharma on 5/6/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import AVKit
import KMPlaceholderTextView

let Kmediachanges = "Are you sure you want change media? your previous records will be deleted!"
class AddNewsFeedPostsVC: BaseUIViewController
{
    
    
    
    @IBOutlet var collctionViewPosts: UICollectionView!
    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var txtView: KMPlaceholderTextView!
    var imagePickerController = UIImagePickerController()
      var viewModel : UploadPostViewModel?
    
    // var postArray = [[String:Any]]()
    let cellID = "CellClass_UploadPosts"
    var videoPath : URL?
    
    var postArray = NSMutableArray()
    var playingAudioVideo = false
    //var localImages : [Image]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.btnUpload.isHidden = true
        self.collctionViewPosts.setEmptyMessage("Nothing to upload!")
        self.viewModel = UploadPostViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        // Do any additional setup after loading the view.
               self.txtView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
           }
           
          
    override func viewWillAppear(_ animated: Bool)
    {
     
        self.playingAudioVideo = false
            self.collctionViewPosts.reloadData()
    }
    
    @objc func tapDone(sender: Any) {
                  self.view.endEditing(true)
              }
    
    
    @IBAction func actionBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: CELL BUTTON ACTION DELETE POST
    @IBAction func cellActionDelete(_ sender: UIButton)
    {
        let dic = self.postArray.object(at: sender.tag)as? NSDictionary
        let type = dic?.value(forKey: "type")as? String ?? ""
        
        if (type == "video" || type == "audio" )
        {
            self.videoPath = nil
            self.postArray = NSMutableArray()
            self.collctionViewPosts.reloadData()
            self.btnUpload.isHidden = true
            self.collctionViewPosts.setEmptyMessage("Nothing to upload!")
        }
        else
        {
            let arr = self.postArray.mutableCopy() as! NSMutableArray
            arr.removeObject(at: sender.tag)
            self.postArray = arr.mutableCopy() as! NSMutableArray
            
            if (arr.count == 0)
            {
                self.btnUpload.isHidden = true
                self.collctionViewPosts.setEmptyMessage("Nothing to upload!")
            }
            
            self.collctionViewPosts.reloadData()
        }
    }
    
    //MARK: CELL BUTTON ACTION PLAY
    @IBAction func cellActionPlayPause(_ sender: UIButton)
    {
        let dic = self.postArray.object(at: sender.tag)as? NSDictionary
        let path = dic?.value(forKey: "path")as? URL ?? nil
        
        if(path != nil)
        {
            self.playingAudioVideo = true
            let player = AVPlayer(url: path!)
            let vc = AVPlayerViewController()
            if dic?.value(forKey: "type") as? String == "audio" {
            let myImageView = UIImageView()
            myImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
              myImageView.image = UIImage(named:"audiobg")
             myImageView.contentMode = .scaleAspectFit
                vc.contentOverlayView?.addSubview(myImageView)}
            vc.player = player
            present(vc, animated: true)
            {
                vc.player?.play()
            }
            self.collctionViewPosts.reloadData()
        }
    }
    
    
    
    //MARK: CHOOSE FILE TYPE
    @IBAction func actionChooseImages(_ sender: Any)
    {
        let countarr = NSMutableArray()
        
        for (_,value) in self.postArray.enumerated() {
            
            if let dic = value as? [String: Any]  {
                
                if dic["type"] as? String == "image" {
                countarr.add(value)
                }
            }
            
        }
        if countarr.count < 5 {
            
            if countarr.count == 0 && self.postArray.count > 0 {
                
                self.AlertMessageWithOkCancelAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: Kmediachanges, Target: self)
                { (actn) in
                    if (actn == "Yes")
                    {
                        self.videoPath = nil
                        self.postArray = NSMutableArray()
                        self.collctionViewPosts.reloadData()
                        self.configPicker()
                    }
                }

            }
            else{
                self.configPicker()

            }
            
            
        }
     
    }
    
    @IBAction func actionChooseVideo(_ sender: Any)
    {
        if (self.postArray.count > 0)
        {
            self.AlertMessageWithOkCancelAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: Kmediachanges, Target: self)
            { (actn) in
                if (actn == "Yes")
                {
                    self.videoPath = nil
                    self.postArray = NSMutableArray()
                    self.collctionViewPosts.reloadData()
                    self.askForVideoType()
                }
            }
        }
        else
        {
            self.askForVideoType()
        }
    }
    
    @IBAction func actionRecordAudio(_ sender: Any)
    {
        if (self.postArray.count > 0)
        {
            self.AlertMessageWithOkCancelAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: Kmediachanges, Target: self)
            { (actn) in
                if (actn == "Yes")
                {
                    self.videoPath = nil
                    self.postArray = NSMutableArray()
                    self.collctionViewPosts.reloadData()
                    
                }
            }
        }
        else
        {
            let vc = UIStoryboard.init(name:"Homework", bundle: Bundle.main).instantiateViewController(withIdentifier: "RecordAudioViewController") as! RecordAudioViewController
             vc.delegateAudioRecorder = self
             self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    
    @IBAction func actionUploadPosts(_ sender: Any)
    {
        if checkInternetConnection(){
                          
                          if txtView.text == "" {
                           self.showAlert(Message: "Please enter something in description")
                          }
                          
                        
                          else {
                          
                            self.viewModel?.addPost(Title: "", Description: txtView.text, DeleteIds: 0, Links: "", NewsLetterId: 0, ParticularId: UserDefaultExtensionModel.shared.userRoleParticularId, TypeId: 0, lstAssignHomeAttachmentMapping: postArray)
                          }
                          
                      }
                      
                       else{
                          self.showAlert(Message: Alerts.kNoInternetConnection)
                      }
        
        //atinder mam now your turn to upload data on server :)
      //  self.showAlert(Message: "Atinder mam uploading wala kaam aap kr dena")
    }
    
    
    
    func configPicker()
    {
        initializeGalleryAlert(self.view, isHideBlurView: true)
               galleryAlertView.delegate = self
    }
}

//MARK:- UIImagePickerView Delegate
extension AddNewsFeedPostsVC:UIImagePickerDelegate{
    func selectedImageUrl(url: URL) {
                          let dic = NSMutableDictionary()
                          dic.setValue(url, forKey: "path")
                          dic.setValue("image", forKey: "type")
                          self.postArray.add(dic)
                          self.collctionViewPosts.reloadData()
                          self.btnUpload.isHidden = false
    }
    func SelectedMedia(image: UIImage?, videoURL: URL?){
        
                               let dic = NSMutableDictionary()
                                 dic.setValue(videoURL, forKey: "path")
                                 dic.setValue("video", forKey: "type")
                                 self.postArray.add(dic)
                                 self.collctionViewPosts.reloadData()
                                 self.btnUpload.isHidden = false
        
    }
}

//MARK:- Custom Gallery Alert
extension AddNewsFeedPostsVC : GalleryAlertCustomViewDelegate{
    func galleryBtnAction() {
        self.OpenGalleryCamera(camera: false, imagePickerDelegate: self)
//        CommonFunctions.sharedmanagerCommon.println(object: "Gallery")
        galleryAlertView.removeFromSuperview()
        
    }
    func cameraButtonAction() {
        self.OpenGalleryCamera(camera: true, imagePickerDelegate: self)
//        CommonFunctions.sharedmanagerCommon.println(object: "Camera")
        galleryAlertView.removeFromSuperview()
    }
    func cancelButtonAction() {
        galleryAlertView.removeFromSuperview()
    }
}




extension AddNewsFeedPostsVC : ViewDelegate {
    
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

extension AddNewsFeedPostsVC : AddPostDelegate {
    func LikerList(data: [lstgetLikesListViewModels]) {
        
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


