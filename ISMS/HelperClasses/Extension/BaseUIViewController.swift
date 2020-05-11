//
//  BaseUIViewController.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 6/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: Global Interface
protocol ViewDelegate:class
{
    func showAlert(alert: String)
    func showLoader()
    func hideLoader()
}
//MARK:- UIPicker Delegate
@objc protocol SharedUIPickerDelegate:class{
    func DoneBtnClicked()
    func GetTitleForRow(index:Int) -> String
    func SelectedRow(index:Int)
    @objc optional func cancelButtonClicked()
}
//MARK:- UIImage Picker Delegate
@objc protocol UIImagePickerDelegate:class{
    func SelectedMedia(image:UIImage?,videoURL:URL? )
    func selectedImageUrl(url: URL)
    @objc optional func cancelSelectionOfImg()
}
//MARK:- UIDate Picker Delegate
@objc protocol SharedUIDatePickerDelegate:class{
    func doneButtonClicked(datePicker: UIDatePicker)
    @objc optional func cancelButtonClicked()
}
//MARK:- Navigation SerachBar Delegates
protocol NavigationSearchBarDelegate:class {
    func textDidChange(searchBar: UISearchBar,searchText: String)
    func cancelButtonPress(uiSearchBar:UISearchBar)
}
//MARK: BaseUIViewController
class BaseUIViewController: UIViewController {
    //MARK:- Variables
    private var pickerDelegate:SharedUIPickerDelegate?
    private var datePickerDelegate:SharedUIDatePickerDelegate?
    private var imagePickerDelegate:UIImagePickerDelegate?
    private var navigationSearchBarDelegate:NavigationSearchBarDelegate?
    private var navigationTitle:String?
    private var datePickerView:UIDatePicker!
    private var searchBar = UISearchBar()
    private var viewDatePickerView:UIView!
    private var pickerView:UIPickerView!
    private var pickerCount:Int?
    private var view_pickerView:UIView!
    private var imagePicker = UIImagePickerController()
    
    let galleryAlertView = GalleryAlertCustomView.instanceFromNib()
    let okAlertView = OKAlertView.instanceFromNib()
    let yesNoAlertView = YesNoAlertView.instanceFromNib()
    let tblViewpopUp = CustomTableViewPopUp.instanceFromNib()
    let textFieldAlert = TextFieldAlert.instanceFromNib()
    var pickerType : UIDatePicker.Mode?
    var visualBlurView = UIVisualEffectView()
    var setPreviouslySelectedIndexInUIPicker = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func viewEndEditing(view: UIView){
        self.view.endEditing(true)
        
        
    }
    
    func dateFromISOString(string: String) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dt = dateFormatter.date(from: string)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "yyyy-MM-dd"
//        print("\(dateFormatter.string(from: dt!))")
        return dateFormatter.string(from: dt!)
        
    }
    
    func dateFromISOStringNew(string: String) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dt = dateFormatter.date(from: string)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        print("\(dateFormatter.string(from: dt!))")
        return dateFormatter.string(from: dt!)
        
    }
    
    
    
    //For Set the status bar content white
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK:- SetPickerView
    func SetpickerView(_ view : UIView) {
        //UIView
        self.view_pickerView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 400, width: UIScreen.main.bounds.width, height: 244))
        // UIPickerView
        self.pickerView = UIPickerView()
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 44, width: view_pickerView.frame.size.width, height: 244))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        
        // ToolBar
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 44))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnClick(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelBtnClick(sender:)))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        self.view_pickerView.addSubview(toolBar)
        self.view_pickerView.addSubview(pickerView)
        view.addSubview(self.view_pickerView)
        self.view_pickerView.isHidden = true
    }
    
    //for textview
    func animateTextView(textView: UITextView, up: Bool, movementDistance:CGFloat,scrollView:UIScrollView)
    {
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = 0
        }
        scrollView.contentOffset = CGPoint(x: 0, y: movement)
        
    }
    
    
    //PickerButton Action
    @objc func doneBtnClick(sender: Any){
        
        self.pickerDelegate?.DoneBtnClicked()
        self.view_pickerView.isHidden = true
        self.removeBlurEffect()
    }
    
    @objc func cancelBtnClick(sender: Any){
        self.view_pickerView.isHidden = true
        self.removeBlurEffect()
        pickerDelegate?.cancelButtonClicked?()
    }
    
    //updatePicker
    func UpdatePickerModel(count:Int,sharedPickerDelegate:SharedUIPickerDelegate, View: UIView){
        view.endEditing(true)
        createBlurEffectView()
        if viewDatePickerView != nil {
            self.viewDatePickerView.isHidden = true
        }
        self.view_pickerView.isHidden = false
        //gurleen
        //Commented below line
        
        self.pickerView.selectRow(0, inComponent:0, animated:true)
        self.pickerDelegate = sharedPickerDelegate
        self.pickerCount = count
        self.pickerView?.reloadAllComponents()
        
        View.insertSubview(view_pickerView, aboveSubview: visualBlurView)
        //View.bringSubviewToFront(pickerView)
        //setPreviouslySelectedIndexInUIPicker
    }
    //updatePicker
    func UpdatePickerModel4(count:Int,sharedPickerDelegate:SharedUIPickerDelegate, View: UIView , index : Int){
        view.endEditing(true)
        createBlurEffectView()
        if viewDatePickerView != nil {
            self.viewDatePickerView.isHidden = true
        }
        self.view_pickerView.isHidden = false
        //gurleen
        //Commented below line
        
        self.pickerView.selectRow(index, inComponent:0, animated:true)
        self.pickerDelegate = sharedPickerDelegate
        self.pickerCount = count
        self.pickerView?.reloadAllComponents()
        
        View.insertSubview(view_pickerView, aboveSubview: visualBlurView)
        //View.bringSubviewToFront(pickerView)
        //setPreviouslySelectedIndexInUIPicker
    }
    
     func styleTextField(textField: UITextField){
        textField.borderStyle = .none
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 5.0;
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowOpacity = 0.4
        textField.layer.shadowRadius = 5.0
    }
    
    func styleView(textField: UIView){
      //  textField.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        textField.layer.shadowRadius = 5
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowOpacity = 1
        textField.layer.shouldRasterize = true
      

    }
    
    func UpdatePickerModel2(count:Int,sharedPickerDelegate:SharedUIPickerDelegate, View: UIView, index : Int){
        view.endEditing(true)
        createBlurEffectView()
//        self.pickerView = UIPickerView()
        if viewDatePickerView != nil {
            self.viewDatePickerView.isHidden = true
        }
        self.view_pickerView.isHidden = false
        if index == 0{
            self.pickerView.selectRow(0, inComponent:0, animated:true)
        }else{
            self.pickerView.selectRow(index, inComponent:0, animated:true)
        }
        
        self.pickerDelegate = sharedPickerDelegate
        self.pickerCount = count
        self.pickerView?.reloadAllComponents()
        View.insertSubview(view_pickerView, aboveSubview: visualBlurView)
        
    }
    
    func showPickerView(selectedComponent: Int) {
        createBlurEffectView()
        if viewDatePickerView != nil {
            self.viewDatePickerView.isHidden = true
        }
        self.view_pickerView.isHidden = false
        self.pickerView.selectRow(selectedComponent, inComponent:0, animated:true)
    }
    //MARK:- Set UIDatePicker
    func setDatePickerView(_ view: UIView,type: UIDatePicker.Mode){
        view.endEditing(true)
        //UIView for date picker view
        self.viewDatePickerView = UIView(frame: CGRect(x: 0, y: view.frame.size.height - 250, width: view.frame.size.width, height: 244))
        // UIDatePickerView
        self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 44, width: viewDatePickerView.frame.size.width, height: 200))
        self.datePickerView.backgroundColor = UIColor.white
        pickerType = type
        if (type == .time){
            self.datePickerView.datePickerMode = .time
        }else{
            self.datePickerView.datePickerMode = .date

            
            if (AddHomeWorkVC.isFromHomeWorkDate == true)
            {
                self.datePickerView.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())

            }
            else{
                self.datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())

            }

        }
        // ToolBar for done and cancel
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: datePickerView.frame.width, height: 44))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.clickOnDoneBtn(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.clickOnCancelButton(sender:)))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        self.viewDatePickerView.addSubview(toolBar)
        self.viewDatePickerView.addSubview(datePickerView)
        view.addSubview(self.viewDatePickerView)
        self.viewDatePickerView.isHidden = true
        
    }
    
    //Show Date Picker for DOB
    
    func showDatePicker(datePickerDelegate: SharedUIDatePickerDelegate){
        view.endEditing(true)
        
        createBlurEffectView()
        
        self.datePickerDelegate = datePickerDelegate
        if(pickerType == .date){
            self.datePickerView.setDate(Date(), animated: true)
        }else{
            self.datePickerView.setDate(Date(), animated: true)
        }
        self.viewDatePickerView.isHidden = false
        self.view.insertSubview(viewDatePickerView, aboveSubview: visualBlurView)
    }
    //Click on done button for uidatepicker
    @objc func clickOnDoneBtn(sender: Any){
        self.viewDatePickerView.isHidden = true
        datePickerDelegate?.doneButtonClicked(datePicker: datePickerView)
        removeBlurEffect()
    }
    
    //Click on cancel button for uidatepicker
    @objc func clickOnCancelButton(sender: Any){
        self.viewDatePickerView.isHidden = true
        removeBlurEffect()
    }
    
    //MARK:- Custom Gallery Alert
    func initializeGalleryAlert(_ view: UIView,isHideBlurView : Bool){
        DispatchQueue.main.async {
            self.view.endEditing(true)
            guard let theme = ThemeManager.shared.currentTheme else{return}
            self.galleryAlertView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.galleryAlertView.btnCamera.backgroundColor = theme.uiButtonBackgroundColor
            self.galleryAlertView.btnCancel.backgroundColor = theme.uiButtonBackgroundColor
            self.galleryAlertView.btnGallery.backgroundColor = theme.uiButtonBackgroundColor
            self.galleryAlertView.lblAlertTitle.backgroundColor = theme.uiButtonBackgroundColor
            self.cornerView(radius: 8, view: self.galleryAlertView.contentView)
            self.galleryAlertView.backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
            view.addSubview(self.galleryAlertView)
            self.galleryAlertView.setNeedsLayout()
            // self.visualBlurView.isHidden = isHideBlurView
        }
    }
    //MARK:- Custom OK Alert
    func initializeCustomOkAlert(_ view: UIView,isHideBlurView : Bool){
        DispatchQueue.main.async {
            self.view.endEditing(true)
            guard let theme = ThemeManager.shared.currentTheme else{return}
            self.okAlertView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.okAlertView.btnOK.backgroundColor = theme.uiButtonBackgroundColor
            self.okAlertView.lblAlertTitle.backgroundColor = theme.uiButtonBackgroundColor
            self.cornerView(radius: 8, view: self.okAlertView.contentView)
            self.okAlertView.backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
            view.addSubview(self.okAlertView)
            self.okAlertView.setNeedsLayout()
            // self.visualBlurView.isHidden = isHideBlurView
        }
    }
    
    //MARK:- Custom Yes No Alert
    func initializeCustomYesNoAlert(_ view: UIView,isHideBlurView : Bool){
        DispatchQueue.main.async {
            self.view.endEditing(true)
            if let theme = ThemeManager.shared.currentTheme{
                self.yesNoAlertView.lblAlertTitle.backgroundColor = theme.uiButtonBackgroundColor
                self.yesNoAlertView.noBtn.backgroundColor = theme.uiButtonBackgroundColor
                self.yesNoAlertView.yesBtn.backgroundColor = theme.uiButtonBackgroundColor
            }
            self.yesNoAlertView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.cornerView(radius: 8, view: self.yesNoAlertView.contentView)
            self.yesNoAlertView.backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
            appDelegate.window?.addSubview(self.yesNoAlertView)
            self.yesNoAlertView.setNeedsLayout()
        }
    }
    
    //MARK:- Custom Table View PopUp
    func initializeCustomTableViewPopUp(_ view: UIView){
        DispatchQueue.main.async {
            self.view.endEditing(true)
            if let theme = ThemeManager.shared.currentTheme{
                self.tblViewpopUp.btnSubmit.backgroundColor = theme.uiButtonBackgroundColor
                self.tblViewpopUp.labelTableViewTitle.backgroundColor = theme.uiButtonBackgroundColor
            }
            self.tblViewpopUp.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.cornerView(radius: 8, view: self.tblViewpopUp.contentView)
            self.tblViewpopUp.isHidden = true
            self.tblViewpopUp.backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
            self.tblViewpopUp.bringSubviewToFront(view)
            view.addSubview(self.tblViewpopUp)
        }
    }
    
    
    func
        initializeCustomTextFieldView(_ view: UIView,isHideBlurView : Bool){
        DispatchQueue.main.async {
            self.textFieldAlert.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            print(UIScreen.main.bounds.width)
            if let theme = ThemeManager.shared.currentTheme{
                self.textFieldAlert.btnCancel.backgroundColor = theme.uiButtonBackgroundColor
                self.textFieldAlert.lblTitle.backgroundColor = theme.uiButtonBackgroundColor
                self.textFieldAlert.BtnTxt.backgroundColor = theme.uiButtonBackgroundColor
            }
            self.cornerView(radius: 8, view: self.textFieldAlert.contentView)
            self.textFieldAlert.backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
            view.addSubview(self.textFieldAlert)
            self.textFieldAlert.setNeedsLayout()
        }
    }
    
    //    //Add Tap Gesture for remove xib
    //    func addTapGestures(){
    //        //Looks for single or multiple taps.
    //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeFromParentView))
    //        self.parentContentView.addGestureRecognizer(tap)
    //    }
    //
    //    @objc func removeFromParentView(){
    //        self.removeFromSuperview()
    //    }
    func setupNavigationColor(){
        guard let currentTheme = ThemeManager.shared.currentTheme else {return}
        navigationController?.navigationBar.barTintColor = currentTheme.navigationBarTintColor
        navigationController?.navigationBar.tintColor = currentTheme.navigationTintColor
    }
    
    
    //Connect text Fields
    func connectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
    
    
    //Blur Effect View
    func createBlurEffectView(_ view: UIView){
        
    }
    
    //MARK:- Hide Back Button In Navigation Controller
    func hideNavigationBackButton(){
        navigationController?.navigationItem.setHidesBackButton(true, animated:true)
        navigationItem.hidesBackButton = true
    }
    
    //Mark:- Create Search Bar in Navigation
    func setSearchBarInNavigationController(placeholderText: String,navigationTitle: String,navigationController: UINavigationController?,navigationSearchBarDelegates: NavigationSearchBarDelegate){
        self.searchBar.sizeToFit()
        self.searchBar.layoutIfNeeded()
        self.searchBar.returnKeyType = .done
        self.searchBar.delegate = self
        self.searchBar.isHidden = true
        self.searchBar.barStyle = .black
        self.searchBar.tintColor = .black
        
//        if #available(iOS 11, *)
//        {
            var searchTextField: UITextField?
           if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                      searchTextField = searchField
            searchTextField?.textColor = .black
            searchTextField?.backgroundColor = .white
            searchTextField?.layer.borderWidth = 0.5
            searchTextField?.layer.borderColor = UIColor.lightGray.cgColor
            searchTextField?.cornerRadius = 8
                  }
//        }
//        else{
//            self.searchBar.backgroundColor = .white
//            self.searchBar.tintColor = .black
//            self.searchBar.layer.borderWidth = 0.5
//            self.searchBar.layer.borderColor = UIColor.lightGray.cgColor
//            self.searchBar.cornerRadius = 8
//        }
        
        self.searchBar.showsCancelButton.toggle()
        self.navigationTitle = navigationTitle
        self.navigationSearchBarDelegate = navigationSearchBarDelegates
        self.searchBar.placeholder = placeholderText
        self.searchBar.returnKeyType = .done
        createRightNavSearchBarButton()
    }
    
    //MARK:- Create right search button in navigation contorller
    func createRightNavSearchBarButton(){
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "searchGray"), style: .done, target: self, action: #selector(self.unHideSearchBar(_:)))
        //NAVAL
        
        rightBarButtonItem.tintColor = .darkGray
        //        rightBarButtonItem.setBackgroundImage(UIImage(named: "search"), for: .normal, barMetrics: .default)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    //Unhide SearchBar
    @objc func unHideSearchBar(_ sender:UIBarButtonItem){
        if view_pickerView != nil{
            self.view_pickerView.isHidden = true
        }
        self.searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchBar
        self.searchBar.isHidden = false
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func hideSearchBar(){
      self.searchBar.isHidden = true
    }
    //MARK:-OpenGallery and Camera
    func OpenGalleryCamera(camera:Bool,imagePickerDelegate:UIImagePickerDelegate){
        if(camera == true){
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true
                self.imagePickerDelegate = imagePickerDelegate
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
                  
            }
            else{
                let alert  = UIAlertController(title: KAlertTitle.kWarning, message: Alerts.kDontHaveCamera, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: KAlertTitle.kOk, style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.imagePickerDelegate = imagePickerDelegate
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK:- Set Navigation Bar Height after appearing search bar
    func setNavigationBarHeight(){
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
    }
    
    func createBlurEffectView(){
        let blurEffect = UIBlurEffect(style: .dark)
        visualBlurView.effect = blurEffect
        visualBlurView.alpha = 0.3
        visualBlurView.frame = view.bounds
        //        visualBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //blurview.isHidden = true
        view.addSubview(visualBlurView)
        
    }
    
    func removeBlurEffect() {
        visualBlurView.removeFromSuperview()
    }
    
}

//MARK: UIPickerViewDataSource,UIPickerViewDelegate
extension BaseUIViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerCount ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        CommonFunctions.sharedmanagerCommon.println(object: "Title Row:- \(row)")
        return self.pickerDelegate?.GetTitleForRow(index: row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        CommonFunctions.sharedmanagerCommon.println(object: "Selected Row:- \(row)")
        setPreviouslySelectedIndexInUIPicker = row
        self.pickerDelegate?.SelectedRow(index: row)
    }
}
extension BaseUIViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.imagePickerDelegate?.cancelSelectionOfImg?()
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        var isImage:Bool = false
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {return}
        print(mediaType)
        switch mediaType{
        case "public.image":
            isImage = true;
            break;
        case "public.video":
            isImage = false;
            break;
        default:
            break;
        }
        if(isImage == true){
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                if #available(iOS 11.0, *) {
                    //                    if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                    //                        let imgName = imgUrl.lastPathComponent
                    //                        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                    //                        let localPath = documentDirectory?.appending(imgName)
                    //
                    //                        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                    //                        let data = image.pngData()! as NSData
                    //                        data.write(toFile: localPath!, atomically: true)
                    //                        let photoURL = URL.init(fileURLWithPath: localPath!)
                    //                        CommonFunctions.sharedmanagerCommon.println(object: "\(photoURL)")
                    //                        imagePickerDelegate?.selectedImageUrl(url: imgUrl)
                    //                    }
                    
                    
                    if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                        
                        var urlImage:URL?
                        guard let chosenImage = info[.editedImage] as? UIImage else {
                            fatalError("\(info)")
                        }
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        // choose a name for your image
                        let fileName = "\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                        // create the destination file url to save your image
                        let fileURL = documentsDirectory.appendingPathComponent(fileName)
                        
                        if let data = chosenImage.jpegData(compressionQuality: 0.1),
                            !FileManager.default.fileExists(atPath: fileURL.path) {
                            do {
                                // writes the image data to disk
                                try data.write(to: fileURL)
                                
                                let url = fileURL
                                urlImage = url
                                
                            } catch {
                                
                            }
                        }
                        if let url = urlImage{
                            imagePickerDelegate?.selectedImageUrl(url: url)
                        }
                        
                        
                    }
                    dismiss(animated: true, completion: nil)
                    
                } else {
                    //                  Fallback on earlier versions
                    var urlImage:URL?
                    guard let chosenImage = info[.editedImage] as? UIImage else {
                        fatalError("\(info)")
                    }
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    // choose a name for your image
                    let fileName = "\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                    // create the destination file url to save your image
                    let fileURL = documentsDirectory.appendingPathComponent(fileName)
                    
                    if let data = chosenImage.jpegData(compressionQuality: 0.1),
                        !FileManager.default.fileExists(atPath: fileURL.path) {
                        do {
                            // writes the image data to disk
                            try data.write(to: fileURL)
                            let url = fileURL
                            urlImage = url
                        } catch {
                            CommonFunctions.sharedmanagerCommon.println(object: "Exception while writing the url image")
                        }
                    }
                    if let url = urlImage{
                        imagePickerDelegate?.selectedImageUrl(url: url)
                    }
                }
                
                imagePickerDelegate?.SelectedMedia(image: pickedImage,videoURL: nil)
            }
            dismiss(animated: true, completion: nil)
        }
        else{
            guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {return}
            
            do {
                let asset = AVURLAsset(url: videoURL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                imagePickerDelegate?.SelectedMedia(image: thumbnail,videoURL:videoURL )
            } catch let error {
                CommonFunctions.sharedmanagerCommon.println(object: "*** Error generating thumbnail: \(error.localizedDescription)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // When showing the ImagePicker update the status bar and nav bar properties.
        //UIApplication.shared.setStatusBarHidden(false, with: .none)
        //164 13 28
        navigationController.topViewController?.title = "Select photo iEMS"
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = KAPPContentRelatedConstants.kThemeColour
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController.navigationBar.barStyle = .default
        navigationController.setNavigationBarHidden(false, animated: animated)
    }
}

//MARK:- Search bar delegates
extension BaseUIViewController : UISearchBarDelegate{
    //Search bar text change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.navigationSearchBarDelegate?.textDidChange(searchBar: searchBar, searchText: searchText)
    }
    //Search Bar cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.isHidden = true
        if let navigationBar = self.navigationController?.navigationBar {
            let firstFrame = CGRect(x: 0, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            let titleLabel = UILabel(frame: firstFrame)
            titleLabel.text = self.navigationTitle
            titleLabel.font = UIFont(name: KAPPContentRelatedConstants.kAppGlobalFontName, size: 17)
            titleLabel.textColor = .black
            titleLabel.textAlignment = .center
            navigationItem.titleView = titleLabel
            navigationItem.titleView?.center = titleLabel.center
            navigationItem.titleView?.setNeedsLayout()
        }
        createRightNavSearchBarButton()
        self.navigationSearchBarDelegate?.cancelButtonPress(uiSearchBar: searchBar)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
