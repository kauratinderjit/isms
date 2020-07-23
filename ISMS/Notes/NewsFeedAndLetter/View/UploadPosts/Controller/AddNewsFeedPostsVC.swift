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
import SDWebImage
import BSImagePicker
import Photos
import ImageCropper
var tagArray = [LocalPostModel]()
var  imageGarrFromAddFeed : Bool = false

let Kmediachanges = "Are you sure you want to discard the selected media and choose a new one?"
class AddNewsFeedPostsVC: BaseUIViewController
{
    var image_Picker = ImagePickerController()
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet var collctionViewPosts: UICollectionView!
    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var txtView: KMPlaceholderTextView!
    var imagePickerController = UIImagePickerController()
    var viewModel : UploadPostViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    let cellID = "CellClass_UploadPosts"
    var videoPath : URL?
    @IBOutlet weak var heightTagView: NSLayoutConstraint!
    @IBOutlet weak var scroll_View: UIScrollView!
    
    @IBOutlet weak var collectionViewColors: UICollectionView!
    var postArray = NSMutableArray()
    var playingAudioVideo = false
    var thumbnailData : Data?
    var colorList = [ColorModel]()
    //Crop Image
    private var image: UIImage?
    @IBOutlet weak var heightViewBG: NSLayoutConstraint!
    var selectedBackGroundColor = "#FFFFFF"
   
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collctionViewPosts.setEmptyMessage("No attachment to upload!")
        self.viewModel = UploadPostViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        // Do any additional setup after loading the view.
               self.txtView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
//        if  AppDefaults.shared.userImage != ""
//        {
//            profileImg.sd_setImage(with: URL(string: AppDefaults.shared.userImage ), placeholderImage: UIImage(named: "profile"), options: SDWebImageOptions(rawValue: 0))
//            { (image, error, cacheType, imageURL) in
//                self.profileImg.image = image
//            }
//        }
//        else {
//            profileImg.image = UIImage(named: "profile")
//        }
//
        if UserDefaultExtensionModel.shared.UserName != "" {
            lblName.text = UserDefaultExtensionModel.shared.UserName
        }
        hideNavigationBackButton()
        setBackButton()
        setColor()
        btnUpload.clipsToBounds = true
        
        
    }
    
    
    func setColor() {
      
        let strColorArr = ["#FFFFFF", "#ffe4b5", "#c1cdc1","#ffe4e1", "#d3d3d3", "#6495ed", "#48d1cc", "#5f9ea0", "#2e8b57", "#3cb371", "#bdb76b","#f0e68c", "#eedd82", "#b8860b","#cd5c5c", "#f4a460", "#ff8c00", "#ff69b4", " #9370db", "#E81606" ]
        
        for str in strColorArr {
            var locDic = ColorModel()
            locDic.hexString = str
            locDic.IsSelected = false
            colorList.append(locDic)
        }
        collectionViewColors.clipsToBounds = true
        collectionViewColors.reloadData()
    }
           
          
    override func viewWillAppear(_ animated: Bool)
    {
        boolImageSelected = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
       self.navigationItem.title = "Add Post"
        self.playingAudioVideo = false
            self.collctionViewPosts.reloadData()
        
        if tagArray.count > 0 {
            heightTagView.constant = 29
            self.collectionView.reloadData()
        }
        else{
            heightTagView.constant = 0
        }
        
        if Device_type.IS_IPHONE_6 || Device_type.IS_IPHONE_5 {
            scroll_View.contentSize = CGSize(width: scroll_View.frame.size.width, height: scroll_View.frame.size.height + 200)
        }
       
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
            self.btnUpload.isHidden = false
            self.collctionViewPosts.setEmptyMessage("No attachment to upload!")
        }
        else
        {
            let arr = self.postArray.mutableCopy() as! NSMutableArray
            arr.removeObject(at: sender.tag)
            self.postArray = arr.mutableCopy() as! NSMutableArray
            
            if (arr.count == 0)
            {
                self.btnUpload.isHidden = false
                self.collctionViewPosts.setEmptyMessage("No attachment to upload!")
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
         self.view.endEditing(true)
        let countarr = NSMutableArray()
        
        for (_,value) in self.postArray.enumerated() {
            
            if let dic = value as? [String: Any]  {
                
                if dic["type"] as? String == "image" {
                 countarr.add(value)
                }
            }
            
        }
        if countarr.count < 5 {
            
//            if countarr.count < 5  && countarr.count != 0 {
//
//               self.AlertMessageWithOkCancelAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: Kmediachanges, Target: self)
//                        { (actn) in
//                            if (actn == "Yes")
//                            {
//                                self.videoPath = nil
//                                self.postArray = NSMutableArray()
//                                self.collctionViewPosts.reloadData()
//                                self.configPicker()
//                                return
//                            }
//                        }
//            }
             
           if countarr.count == 0 && self.postArray.count > 0 {
                
                self.AlertMessageWithOkCancelAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: Kmediachanges, Target: self)
                { (actn) in
                    if (actn == "Yes")
                    {
                        self.videoPath = nil
                        self.thumbnailData = nil
                        self.postArray.removeAllObjects()
                        self.collctionViewPosts.reloadData()
                        self.configPicker()
                    }
                }
                
                

            }
            else{
                self.configPicker()

            }
            
            
        }
        else{
            self.showAlert(alert: "Max 5 photos can selected for a single post.")
        }
     
    }
    
    @IBAction func actionChooseVideo(_ sender: Any)
    {
         self.view.endEditing(true)
        if (self.postArray.count > 0)
        {
            self.AlertMessageWithOkCancelAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: Kmediachanges, Target: self)
            { (actn) in
                if (actn == "Yes")
                {
                    self.videoPath = nil
                    self.thumbnailData = nil
                    self.postArray.removeAllObjects()
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
         self.view.endEditing(true)
        if (self.postArray.count > 0)
        {
            self.AlertMessageWithOkCancelAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: Kmediachanges, Target: self)
            { (actn) in
                if (actn == "Yes")
                {
                    self.thumbnailData = nil
                    self.videoPath = nil
                    self.postArray.removeAllObjects()
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
         self.view.endEditing(true)
        if checkInternetConnection(){
                          
                          if txtView.text == "" {
                           self.showAlert(Message: "Please enter something in description")
                          }
                          
                        
                          else {
                            self.showLoader()
                            btnUpload.isUserInteractionEnabled = false
                            self.viewModel?.addPost(Title: "", Description: txtView.text, DeleteIds: 0, Links: "", NewsLetterId: 0, ParticularId: UserDefaultExtensionModel.shared.currentUserId, TypeId: 0, lstAssignHomeAttachmentMapping: postArray,thumbnail: thumbnailData, ColorCode: selectedBackGroundColor)
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
        imageGarrFromAddFeed = true
         initializeGalleryAlert(self.view, isHideBlurView: true)
         galleryAlertView.delegate = self
    }
    
    
    
    @IBAction func tagUser(_ sender: UIButton) {
        if self.checkInternetConnection() {
            tagArray.removeAll()
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Homework", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "searchUserByTagVC") as! searchUserByTagVC
//            newViewController.modalPresentationStyle = .fullScreen
//            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    

    @IBAction func actionDeleteTag(_ sender: UIButton) {
        
        tagArray.remove(at: sender.tag)
        collectionView.reloadData()
        
    }
    
}

//MARK:- UIImagePickerView Delegate
extension AddNewsFeedPostsVC:UIImagePickerDelegate{
    func selectedImageUrl(url: URL) {
        boolImageSelected = false
                          let dic = NSMutableDictionary()
                          dic.setValue(url, forKey: "path")
                          dic.setValue("image", forKey: "type")
                          self.postArray.add(dic)
                          self.collctionViewPosts.reloadData()
                          self.btnUpload.isHidden = false
    }
    func SelectedMedia(image: UIImage?, videoURL: URL?){
        
        if videoURL != nil {
            boolImageSelected = false
            thumbnailData = image!.pngData()
            
                                let dic = NSMutableDictionary()
                                 dic.setValue(videoURL, forKey: "path")
                                 dic.setValue("video", forKey: "type")
                                 dic.setValue(image, forKey: "videothumb")
                                 self.postArray.add(dic)
                                 self.collctionViewPosts.reloadData()
                                 self.btnUpload.isHidden = false
        }
        
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
        btnUpload.isUserInteractionEnabled = true
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




extension AddNewsFeedPostsVC : AddPostDelegate {
    func addedSuccessfully(result: Int) {
        
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = "Post added successfully"
        
    }
    
    func CommentData(data: [lstgetCommentViewList]?) {
        
    }
    
    func LikerList(data: [lstgetLikesListViewModels]) {
        
    }
    
    
    
    func displayData(data: [NewsListResultData]) {
        
    }
    
    func attachmentDeletedSuccessfully() {
        
    }
}

extension AddNewsFeedPostsVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if okAlertView.lblResponseDetailMessage.text == "Post added successfully" {
        self.navigationController?.popViewController(animated: true)}
    }
}
//MARK: - UIImagePickerControllerDelegate

