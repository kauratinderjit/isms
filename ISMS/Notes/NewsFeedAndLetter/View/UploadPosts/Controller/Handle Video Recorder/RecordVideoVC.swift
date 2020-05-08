//
//  RecordVideoVC.swift
//  iDryveApp
//
//  Created by Mac Mini 101 on 02/09/19.
//  Copyright © 2019 KBS. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol getVideoPathProtocol
{
    func getFilePath(fileURL:URL)
    
}




class RecordVideoVC: SwiftyCamViewController,SwiftyCamViewControllerDelegate
{

    @IBOutlet weak var captureButton    : SwiftyRecordButton!
    @IBOutlet weak var flipCameraButton : UIButton!
    @IBOutlet weak var flashButton      : UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var lbl_hint: UILabel!
    
    var lastVideo_URL = URL(string : "")
    var myTimer = Timer()
    var count  = 0
    var count_reverse  = 0
    var recording_running = false
    var bookingID = ""
    var delegateVideoRecorder: getVideoPathProtocol?
    var videoCanceled = false
    
    static let shared = RecordVideoVC()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        shouldPrompToAppSettings = true
        cameraDelegate = self
        maximumVideoDuration = 60.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        flashMode = .auto
        flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        captureButton.buttonEnabled = false
        pinchToZoom = true
        swipeToZoom = false
        swipeToZoomInverted = false
        
       // view.layer.borderColor = ExtensionModel.shared.set_theme_color().cgColor
        view.layer.borderWidth = 1.0
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 3
        view.layer.shadowColor = UIColor.darkGray.cgColor
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.Stop_recording),
            name: NSNotification.Name(rawValue: "stop_recording"),
            object: nil)
    }
    

    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        captureButton.delegate = self
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
           // self.captureButton.delegate!.buttonWasTapped()
           // self.recording_running = true
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
//        {
//            let btn = UIButton()
//            self.onFullAndPIP(btn)
//        }
        
    }
    
    @objc func Stop_recording()
    {
        self.captureButton.delegate!.buttonWasTapped()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4)
//        {
//            PIPKit.dismiss(animated: true)
//        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func startTimer()
    {
        self.count = self.count+1
        self.count_reverse = self.count_reverse+1
        self.lblTimer.text = "\(self.formatSecondsToString(TimeInterval(self.count_reverse)))"
        if (self.count >= 60)
        {
            self.REFRESH_TIMER()
        }
        
    }
    
    @IBAction func ACTION_MOVE_BACK(_ sender: Any)
    {
        if (self.recording_running == true)
        {
            let msg = "Are you sure you want to cancel this video?"
            let alertController = UIAlertController(title:"Reminder!", message: msg, preferredStyle:.alert)

            let Action = UIAlertAction.init(title: "YES", style: .default) { (UIAlertAction) in
                
                self.videoCanceled = true
                self.dismiss(animated: true, completion: nil)
            }
            
            let Action2 = UIAlertAction.init(title: "NO", style: .default) { (UIAlertAction) in
                
            }
            alertController.addAction(Action)
            alertController.addAction(Action2)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController)
    {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController)
    {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage)
    {
        let newVC = PhotoViewController(image: photo)
        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection)
    {
        self.recording_running = true
        print("Did Begin Recording")
        captureButton.growButton()
        hideButtons()
        self.REFRESH_TIMER()
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection)
    {
        self.recording_running = false
        print("Did finish Recording")
        captureButton.shrinkButton()
        showButtons()
        self.REFRESH_TIMER()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL)
    {
        print(url as Any)
        
        self.lastVideo_URL = url

//        let msg = "Do you want to save this video in gallery?"
//        let alertController = UIAlertController(title:"Reminder!", message: msg, preferredStyle:.alert)
//
//        let Action = UIAlertAction.init(title: "YES", style: .default) { (UIAlertAction) in
//
//           self.SAVE_VIDEO_TO_GALLERY(videoURL: url)
//        }
//        let Action2 = UIAlertAction.init(title: "NO", style: .cancel) { (UIAlertAction) in
//
//        }

//        alertController.addAction(Action2)
//        alertController.addAction(Action)
//        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.async
        {
            if (self.videoCanceled == false)
            {
               self.SAVE_VIDEO_TO_GALLERY(videoURL: url)
            }
        }
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint)
    {
        print("Did focus at point: \(point)")
        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController)
    {
        self.recording_running = false
        self.REFRESH_TIMER()
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat)
    {
        print("Zoom level did change. Level: \(zoom)")
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection)
    {
        print("Camera did change to \(camera.rawValue)")
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error)
    {
        self.recording_running = false
        print(error)
    }
    
    @IBAction func cameraSwitchTapped(_ sender: Any)
    {
        self.recording_running = false
        switchCamera()
    }
    
    @IBAction func toggleFlashTapped(_ sender: Any) {
        //flashEnabled = !flashEnabled
        toggleFlashAnimation()
    }
    
    
    func SAVE_VIDEO_TO_GALLERY(videoURL:URL)
    {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        }) { saved, error in
            if saved
            {
                
                DispatchQueue.main.async
                {
                    self.delegateVideoRecorder?.getFilePath(fileURL:videoURL)
                    self.dismiss(animated: true, completion: nil)
                }
                
                
                
              //  MBProgressHUD.hide(for: self.view, animated: true)
              //  let msg = "Video saved successfully"
              //  let alertController = UIAlertController(title:"Reminder!", message: msg, preferredStyle:.alert)

              //  let Action = UIAlertAction.init(title: "OK", style: .default) { (UIAlertAction) in
                    
                  //  self.delegateVideoRecorder?.getFilePath(fileURL:videoURL)
                    
               // }
                
               // alertController.addAction(Action)
               // self.present(alertController, animated: true, completion: nil)
            }
            else
            {
              // MBProgressHUD.hide(for: self.view, animated: true)
              // CommonVc.AllFunctions.showAlert(message: "Something went wrong, please try with another clip.", view: self, title: "Sorry!")
            }
        }
    }
    
    func formatSecondsToString(_ seconds: TimeInterval) -> String
    {
        if seconds.isNaN
        {
            return "0:00"
        }
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    func REFRESH_TIMER()
    {
        self.lblTimer.text = "0:00"
        self.count = 0
        self.count_reverse = 0
        self.myTimer.invalidate()
    }
    
    func HIDE_ALL_BUTTONS()
    {
        self.captureButton.isHidden = true
        self.flipCameraButton.isHidden = true
        self.flashButton.isHidden = true
        self.lblTimer.isHidden = true
        self.btn_cancel.isHidden = true
        self.lbl_hint.isHidden = true
    }
    
    func SHOW_ALL_BUTTONS()
    {
        self.captureButton.isHidden = false
        self.flipCameraButton.isHidden = false
        self.flashButton.isHidden = false
        self.lblTimer.isHidden = false
        self.btn_cancel.isHidden = false
        self.lbl_hint.isHidden = false
    }
    


}

// UI Animations
extension RecordVideoVC
{
    
    fileprivate func hideButtons()
    {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        }
    }
    
    fileprivate func showButtons()
    {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        }
    }
    
    fileprivate func focusAnimationAt(_ point: CGPoint)
    {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "radioSelected"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    
    fileprivate func toggleFlashAnimation()
    {
        //flashEnabled = !flashEnabled
        if flashMode == .auto{
            flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
        }else if flashMode == .on{
            flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
        }else if flashMode == .off{
            flashMode = .auto
            flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        }
    }
}
