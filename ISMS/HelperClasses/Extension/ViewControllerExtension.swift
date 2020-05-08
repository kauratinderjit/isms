//
//  BaseUIViewController.swift
//  Organics Bazaar
//
//  Created by Atinder Kaur on 5/03/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import SystemConfiguration
import NVActivityIndicatorView
import AVFoundation
import AVKit


extension UIViewController
{

    
    
    
    // This method is used to corner the buttons e.g. Save, Submit etc.
    func cornerButton(btn : UIButton,radius:Int) {
        btn.layer.cornerRadius = CGFloat(radius)
        btn.clipsToBounds = true
    }
    
    //corner the View
    func  cornerView(radius:Int,view:UIView )
    {
        view.layer.cornerRadius = CGFloat(radius)
        view.layer.masksToBounds = false
        view.clipsToBounds = true
    }
   
    //Create Shadow and radius of the view 
    func addViewCornerShadow(radius: Int,view:UIView){
        let opacity = 0.2
        view.layer.masksToBounds = false;
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.cornerRadius = 8;
        view.layer.shadowRadius = 8;
        view.layer.shadowOpacity = Float(opacity);
    }
    
    
    
    //Create Shadow and radius of the view
    func addbtnShadow(radius: Int,btn:UIButton,shadowColor:UIColor){
          let opacity = 0.2
          btn.layer.masksToBounds = false;
          btn.layer.shadowOffset = CGSize(width: 2, height: 2)
          btn.layer.shadowColor = shadowColor.cgColor
          btn.layer.cornerRadius = CGFloat(radius)
          btn.layer.shadowRadius = 8;
          btn.layer.shadowOpacity = Float(opacity);
      }
    
    //Add Multiple View to Array for Corner Radius And Shadow
    func createMultipleViewsCornerShadow(views: [UIView],radius: Int){
        let opacity = 0.6
        _ = views.map({ (view) in
            view.layer.masksToBounds = false;
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.cornerRadius = 8;
            view.layer.shadowRadius = 8;
            view.layer.shadowOpacity = Float(opacity);
        })
    }
    
    
    
    
    //Shadow to view
    func addShadow(view:UIView)
    {
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
                   view.layer.shadowColor = UIColor.black.cgColor
                   view.layer.shadowRadius = 5
                   view.layer.shadowOpacity = 0.40
                   view.layer.masksToBounds = false;
                   view.clipsToBounds = false;
    }
    
    //Boarder for view
    func BorderForView(width:Float,view:UIView,color: UIColor )
    {
        view.layer.borderWidth = CGFloat(width);
        view.layer.borderColor = color.cgColor;
    }
    func cornerImage(image : UIImageView)
    {
        image.layer.masksToBounds = false
        image.layer.cornerRadius = image.frame.width/2
        image.clipsToBounds = true
    }
    
    func StartIndicator(message: String)
    {
        if(!CommonFunctions.isAnimating)
        {
            CommonFunctions.isAnimating = true
            let size = CGSize(width: 30, height: 30)
            
          //  startAnimating(size, message: message, type: .ballBeat, fadeInAnimation: nil)
            DispatchQueue.main.async {
                NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
            }
        }
        //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
        //                       NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
        //                   }
    }
  func StopIndicator()
     {
         CommonFunctions.isAnimating = false
         DispatchQueue.main.async()
             {
             //    self.stopAnimating(nil)
         }
     }
    
    // Hide Navigation Bar
    func HideNavigationBar(navigationController: UINavigationController){
         navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    //UnHide Navigation Bar
    func UnHideNavigationBar(navigationController: UINavigationController?){
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isHidden = false
    }
    
    //Customize the Font of Navigation Bar
    func CustomizeFontNavaigationBar(navigationController: UINavigationController){
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Semibold", size: 20)!,.foregroundColor: UIColor.white]
    }
    //MARK:- Alert with OK Action
    
 func AlertMessageWithOkAction(titleStr:String, messageStr:String,Target : UIViewController, completionResponse:@escaping () -> Void) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            completionResponse()
        }
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func AlertMessageWithOkCancelAction(titleStr:String, messageStr:String,Target : UIViewController, completionResponse:@escaping (String) -> Void) {
           let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
           let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
               UIAlertAction in
               completionResponse("Yes")
           }
           let CancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
               UIAlertAction in
               completionResponse("No")
           }
           // Add the actions
           alert.addAction(okAction)
           alert.addAction(CancelAction)
           self.present(alert, animated: true, completion: nil)
       }
    //Show Alert with message
    func showAlert(Message:String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: KAPPContentRelatedConstants.kAppTitle, message: Message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: KAlertTitle.kOk, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //Show and Hide Loader
    func ShowLoader(){
       MBProgressHUD.showAdded(to: appDelegate.window, animated: true)
    }
    
    func HideLoader(){
        MBProgressHUD.hide(for: appDelegate.window, animated: true)
//        MBProgressHUD.
        MBProgressHUD.hideAllHUDs(for: appDelegate.window, animated: true)
    }
    
    //Navigate to Next VC using navigation controller
    func pushToNextVC(storyboardName: String,viewControllerName: String){
        
        let vc = UIStoryboard.init(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: viewControllerName)
        self.navigationController?.pushViewController(vc, animated: true)
   
    }
  
    //MARK:- Create Back Button in navigation Bar
    //NAVAL
    func setBackButton()
    {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: kImages.KBackIcon), for: .normal)
        backButton.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        backButton.tintColor = .gray
        backButton.backgroundColor = .clear
        let barItemBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem  = barItemBackButton
    }
    
    //Navigation back button action
    @objc func backBtnAction()
    {
        navigationController?.popViewController(animated: false)
    }
    
    //Set label inside table view
    func tblViewCenterLabel(tblView: UITableView,lblText: String,hide: Bool){
        
        let label = UILabel()
        label.frame = CGRect(x:(UIScreen.main.bounds.width/2) - 50,y: (UIScreen.main.bounds.height/2) - 20 ,width: 100,height: 40)
        label.text = lblText
        label.font = label.font.withSize(24)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center

        if hide == true{
            tblView.backgroundView = nil
        }else{
            tblView.backgroundView = label
            tblView.separatorStyle = .none
        }
        
    }
    
    
    //Set Background Image as parent screen bounds
    func setBackgroundImageOnParentView(imageName: String){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    //to show the toast
    func showToast(message : String)
    {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 8.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        ///AppDelegate.window?.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    //Set label when data is not available
    func setLabelWhenDataisNotAvailable(messageLabel: UILabel?,isHidden: Bool){
        
        messageLabel?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height/2, width: 250, height: 60)
        messageLabel?.text = "No data found."
        messageLabel?.numberOfLines = 0;
        messageLabel?.textAlignment = .center;
        messageLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)!
        messageLabel?.sizeToFit()
        messageLabel?.layer.zPosition = 1
        if let msg_Lbl = messageLabel{
            if isHidden == true{
                msg_Lbl.isHidden = isHidden
            }else{
                msg_Lbl.isHidden = isHidden
            }
            self.view.addSubview(msg_Lbl)
        }
    }
    
    //Set the label height according to it's content
    func calculateHeightForLabel(label:UILabel,text:String, font:UIFont, width:CGFloat) -> CGFloat{
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    //Hide Back Button Of Navigation default
    func hideNavigationDefaultBackButton(){
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    //MARK:- PASSWORD VALIDATION
    func isValidPassword(_ Text:String) -> Bool {
        let name_reg = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{3,}"
        let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
        if name_test.evaluate(with: Text)
        {
            return name_test.evaluate(with: Text)
        }
        else
        {
            return false
        }
    }
    
    func checkInternetConnection() -> Bool {
        // To check internet connection.
        var isInternetActive: Bool!
        var internetConnectionReach: Reachability!
        internetConnectionReach = Reachability.reachabilityForInternetConnection()
        var netStatus: Reachability.NetworkStatus!
        netStatus = internetConnectionReach.currentReachabilityStatus
        if(netStatus == Reachability.NetworkStatus.notReachable) {
            isInternetActive = false;
            return isInternetActive
        }
        else {
            isInternetActive = true
            return isInternetActive
        }
    }
    
    /*
    Set Navigation Left Menu Button
    */
    func setLeftMenuButton(){
        //create a new button
        let button = UIButton(type: .custom)
        //set image for button
        button.setImage(UIImage.init(named: "menuIcon"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(openSideBar), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.tintColor = .gray
        button.backgroundColor = .clear
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func openSideBar(){
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    func resignAllTextfields(txtFieldArr: [UITextField]){
        _ = txtFieldArr.map({ (textField) in
            textField.resignFirstResponder()
        })
    }
    
    
}
