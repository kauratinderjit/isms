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
import Gallery
import Photos
import KMPlaceholderTextView

let Kmediachanges = "Are you sure you want change media? your previous records will be deleted!"
class AddNewsFeedPostsVC: UIViewController
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
        if (self.postArray.count > 0)
        {
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
        else
        {
            self.configPicker()
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
        Config.Camera.recordLocation = true
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 5
        
        let gallery = GalleryController()
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
}


extension AddNewsFeedPostsVC : GalleryControllerDelegate
{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image])
    {
        print(images)
        self.postArray = NSMutableArray()
        self.videoPath = nil
        
        for img in images
        {
            
            let fimage = self.getAssetThumbnail(asset: img.asset, size: 100.0)
            let dic = NSMutableDictionary()
            dic.setValue(fimage, forKey: "path")
            dic.setValue("image", forKey: "type")
            self.postArray.add(dic)
        }
        
        if (images.count > 0)
        {
            self.collctionViewPosts.reloadData()
            self.btnUpload.isHidden = false
            self.collctionViewPosts.restore()
        }
        self.dismiss(animated: true, completion:nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video)
    {
        print(video)
        self.dismiss(animated: true, completion:nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image])
    {
        print(images)
        self.dismiss(animated: true, completion:nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController)
    {
        self.dismiss(animated: true, completion:nil)
    }
    
    
    func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage
    {
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize(width: size * retinaScale, height: size * retinaScale)
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        let square = CGRect(x: 0, y: 0, width: CGFloat(cropSizeLength), height: CGFloat(cropSizeLength))
        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.normalizedCropRect = cropRect
        
        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
}

extension PHAsset
{

    var image : UIImage
    {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
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
    func attachmentDeletedSuccessfully() {
        
    }
    
    func addedSuccessfully() {
        
    }
  
}


