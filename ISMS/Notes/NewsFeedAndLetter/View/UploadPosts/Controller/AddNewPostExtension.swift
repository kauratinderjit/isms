//
//  AddNewPostExtension.swift
//  ISMS
//
//  Created by Mohit Sharma on 5/6/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import AVFoundation

extension AddNewsFeedPostsVC
{
    
    //MARK: ASKING FILE TYPES
    func askForPhotoType()
    {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: KAPPContentRelatedConstants.kAppTitle, message: "Choose upload image type", preferredStyle: .actionSheet)
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Choose from Gallery", style: .default) { action -> Void in
            
            
        }
        
        let scndAction: UIAlertAction = UIAlertAction(title: "Click now", style: .default) { action -> Void in
            
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(scndAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
        present(actionSheetController, animated: true)
        {
            print("option menu presented")
        }
    }
    
    func askForVideoType()
    {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: KAPPContentRelatedConstants.kAppTitle, message: "Choose upload video type", preferredStyle: .actionSheet)
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Choose from gallery", style: .default) { action -> Void in
            
            self.openVideoGallery()
        }
        
        let scndAction: UIAlertAction = UIAlertAction(title: "Record now", style: .default) { action -> Void in
            
            let storyboard = UIStoryboard.init(name: KStoryBoards.kHomeWork, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecordVideoVC") as! RecordVideoVC
            vc.delegateVideoRecorder = self
            self.present(vc, animated: true, completion: nil)
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(scndAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
        present(actionSheetController, animated: true)
        {
            print("option menu presented")
        }
    }

    
    //MARK: HANDLING VIDEO FETCHING FROM GALLERY
    func openVideoGallery()
    {
        self.OpenGalleryVideo(camera: false, imagePickerDelegate: self)

    
       // present(imagePickerController, animated: true, completion: nil)
    }
    func image_WithImage(image:UIImage, scaledToSize newSize:CGSize ) -> UIImage {

           UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
           image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.width))
           let newImage : UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext();
           return newImage;

       }
    
    
    func storeValues(path:URL, image: UIImage)
    {
       DispatchQueue.main.async
            {
                self.postArray = NSMutableArray()
                self.videoPath = path
                let dic = NSMutableDictionary()
                dic.setValue(path, forKey: "path")
                dic.setValue("video", forKey: "type")
                dic.setValue(image, forKey: "videothumb")
                self.postArray.add(dic)
                self.collctionViewPosts.reloadData()
                self.btnUpload.isHidden = false
                self.collctionViewPosts.restore()
        }
    }
    
}




extension AddNewsFeedPostsVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
         if collectionView == collctionViewPosts {
        return postArray.count
        }
            
         else if collectionView == collectionViewColors {
            
            return colorList.count
         }
         else{
             return tagArray.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == self.collectionView {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! tagCell
            cell.lblName.text = tagArray[indexPath.row].Name
            cell.btnDel.tag = indexPath.row
            
            return cell
        }
       else if collectionView == collectionViewColors {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath)as! ColorCell
            
            if indexPath.row == 0 {
                cell.lblColor.borderWidth = 1
                cell.lblColor.clipsToBounds = true
                cell.lblColor.borderColor = UIColor.init(red: 75/255, green: 190/255, blue: 248/255, alpha: 1)
            }
            else{
                cell.lblColor.borderWidth = 0
            }
            
            let hexStr = colorList[indexPath.row].hexString ?? ""
            if #available(iOS 11.0, *) {
                let color = UIColor(named: hexStr)
                 cell.lblColor.backgroundColor = color
            } else {
                // Fallback on earlier versions
            }
//            cell.lblColor.backgroundColor = color
           return cell
        }
        
       else {
        
        let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)as! CellClass_UploadPosts
        cellnew.btnDelete.frame = CGRect(x: self.view.frame.origin.x + self.view.frame.size.width - 73 , y: 0, width: 32, height: 32)
        cellnew.btnDelete.tag = indexPath.row
        cellnew.btnPlay.tag = indexPath.row
        
        let dic = self.postArray.object(at: indexPath.row) as? NSDictionary
        let type = dic?.value(forKey: "type")as? String ?? ""
        
        if (type == "video" || type == "audio" )
        {
            cellnew.btnPlay.isHidden = false
            
            if(self.playingAudioVideo == true)
            {
                cellnew.btnPlay.setBackgroundImage(UIImage(named: "pause"), for: .normal)
            }
            else
            {
                cellnew.btnPlay.setBackgroundImage(UIImage(named: "playVideo"), for: .normal)
            }
            if (type == "video"){
                if let name = dic?.value(forKey: "videothumb") as? UIImage {
                    cellnew.ivImg.image = name
                }
                else{
                     cellnew.ivImg.image = UIImage(named: "audiobg" )
                }
            }
            else{
                 cellnew.ivImg.image = UIImage(named: "audiobg" )
            }
        }
        else
        {
            let img = dic?.value(forKey: "path")as? URL
            
            do {
                if img != nil {
                              cellnew.ivImg.image = nil
                            let imageData = try Data(contentsOf: img!)
                    cellnew.ivImg.image = UIImage(data: imageData) ?? UIImage(named:"profile")!
                  cellnew.ivImg.contentMode = .scaleAspectFill
                    
                    if Device_type.IS_IPHONE_4_OR_LESS || Device_type.IS_IPHONE_5 || Device_type.IS_IPHONE_6  {
                        heightViewBG.constant = 250

                    }
                }
               } catch {
                   print("Error loading image : \(error)")
               }
            cellnew.btnPlay.isHidden = true
            txtView.backgroundColor  = UIColor.white
        }
        
        return cellnew
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        if collectionView == collectionViewColors {
            
            let hexStr = colorList[indexPath.row].hexString ?? ""
            if #available(iOS 11.0, *) {
                let color = UIColor(named: hexStr)
                  txtView.backgroundColor = color
            } else {
                // Fallback on earlier versions
            }
            selectedBackGroundColor = hexStr
//            txtView.backgroundColor = color
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == collctionViewPosts {
        return CGSize(width: (self.view.frame.size.width - 32), height: collectionView.frame.size.height)
        }
         else if collectionView == self.collectionView {
            return CGSize(width: 114, height: 25)
        }
            else if collectionView == collectionViewColors {
                        return CGSize(width: 25, height: 22)
                  }
         else {
            return CGSize()
        }
    }
    
    
    
}

extension AddNewsFeedPostsVC : UICollectionViewDelegateFlowLayout
{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        let frame = self.collctionViewPosts.frame
//        return CGSize(width: frame.size.width-20, height: frame.size.height-20)
//    }
}


extension AddNewsFeedPostsVC : getVideoPathProtocol,UITextViewDelegate
{
    func getFilePath(fileURL: URL)
    {
        
        do {
            let asset = AVURLAsset(url: fileURL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            thumbnailData = thumbnail.pngData()
            self.storeValues(path:fileURL,image: thumbnail)


        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
     
          
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "/n")
        {
            self.view.endEditing(true)
            return true
        }
        
        return true
    }
}

extension AddNewsFeedPostsVC : getAudioProtocol
{
    func getFilePathAudio(fileURL: URL)
    {
        DispatchQueue.main.async
                              {
                                  self.postArray = NSMutableArray()
                                  let dic = NSMutableDictionary()
                                  dic.setValue(fileURL, forKey: "path")
                                  dic.setValue("audio", forKey: "type")
                                  self.postArray.add(dic)
                                  self.collctionViewPosts.reloadData()
                                  self.btnUpload.isHidden = false
                                  self.collctionViewPosts.restore()
                          }
    }
    
   
}

