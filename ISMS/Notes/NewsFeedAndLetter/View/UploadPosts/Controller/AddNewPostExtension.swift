//
//  AddNewPostExtension.swift
//  ISMS
//
//  Created by Mohit Sharma on 5/6/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation

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
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        imagePickerController.mediaTypes = ["public.movie"]
        
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        if let path = info[.mediaURL]
        {
            self.videoPath = path as? URL
            if (self.videoPath != nil)
            {
                let optnl = URL(string: "www.google.com")
                self.storeValues(path:self.videoPath ?? optnl!)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    func storeValues(path:URL)
    {
       DispatchQueue.main.async
            {
                self.postArray = NSMutableArray()
                self.videoPath = path
                
                let dic = NSMutableDictionary()
                dic.setValue(path, forKey: "path")
                dic.setValue("video", forKey: "type")
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
        return postArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)as! CellClass_UploadPosts
        
        cellnew.btnDelete.tag = indexPath.row
        cellnew.btnPlay.tag = indexPath.row
        
        let dic = self.postArray.object(at: indexPath.row)as? NSDictionary
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
            
            cellnew.ivImg.image = UIImage()
        }
        else
        {
            let img = dic?.value(forKey: "path")as? UIImage
            cellnew.btnPlay.isHidden = true
            cellnew.ivImg.image = img
        }
        
        return cellnew
    }
    
    
}

extension AddNewsFeedPostsVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let frame = self.collctionViewPosts.frame
        return CGSize(width: frame.size.width-20, height: frame.size.height-20)
    }
}


extension AddNewsFeedPostsVC : getVideoPathProtocol,UITextViewDelegate
{
    func getFilePath(fileURL: URL)
    {
        self.storeValues(path:fileURL)
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

