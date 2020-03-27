//
//  AddDepartmentVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 6/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class AddDepartmentVC: BaseUIViewController {
    
    //Mark:- Properties
    @IBOutlet weak var imgViewDepartment: UIImageView!
    @IBOutlet weak var btnAddimage: UIButton!
    @IBOutlet weak var viewBehindTitle: UIView!
    @IBOutlet weak var viewBehindDescription: UIView!
    @IBOutlet weak var viewBehindOthers: UIView!
    @IBOutlet weak var txtfieldTitle: UITextField!
    @IBOutlet weak var txtfieldOthers: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtViewDescription: KMPlaceholderTextView!
    //Mark:-Variables
    var viewModel : AddDepartmentViewModel?
    var selectedImageUrl : URL?
    var departmentId : Int = 0
    var departmentDetailFetchTimeImgUrl : URL?
    var isDepartmentAddUpdateSuccess = false
    var isUnauthorizedUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    //MARK:- Action
    @IBAction func btnAddDepartment(_ sender: UIButton) {
        btnAddUpdateDepartment()
    }
    
    
    @IBAction func btnAddImage(_ sender: UIButton) {
        initializeGalleryAlert(self.view, isHideBlurView: true)
        galleryAlertView.delegate = self
    }
    
    //MARK:- Set UI
    func setUI(){
        //Initiallize memory for viewModel
        self.viewModel = AddDepartmentViewModel.init(delegate : self as AddDepartmentDelegate)
        self.viewModel?.attachView(viewDelegate: self as ViewDelegate)
        //Hit Add/Detail Department Api
        departmentAddOrGetdetailApi()
        //Set placeholders
        txtfieldTitle.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kTitle)
        txtfieldOthers.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kOthers)
        txtViewDescription.SetTextFont(textSize:KTextSize.KSixteen)
        txtViewDescription.placeholder = KPlaceholder.kDescription
        txtViewDescription.placeholderColor = UIColor.darkGray
        //Set corner and shadow of the textfields
        addViewCornerShadow(radius: 8, view: txtfieldTitle)
        addViewCornerShadow(radius: 8, view: txtfieldOthers)
        addViewCornerShadow(radius: 8, view: txtViewDescription)
        btnSubmit.SetButtonFont(textSize: KTextSize.KSeventeen)
        //Set textfield padding
        txtfieldTitle.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtfieldOthers.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        //Set navigation back button
        setBackButton()
        //Set the circle image
        cornerImage(image: imgViewDepartment)
        cornerButton(btn: btnSubmit, radius: 8)
        //Unhide Navigation comtroller
        UnHideNavigationBar(navigationController: self.navigationController)
        viewEndEditing(view: self.view)
        
        guard let theme = ThemeManager.shared.currentTheme else {return}
        btnSubmit.backgroundColor = theme.uiButtonBackgroundColor
        btnSubmit.titleLabel?.textColor = theme.uiButtonTextColor
//        btnAddimage.tintColor = theme.uiButtonTintColor
        
    }

    //Get Department Detail And Add Department Api
    func departmentAddOrGetdetailApi(){
        if departmentId != 0{
            if checkInternetConnection(){
                self.viewModel?.getDepartmentDetail(departmentId: departmentId)
                self.title = KStoryBoards.KAddDepartMentIdentifiers.kUpdateDepartmentTitle
            }else{
                self.showAlert(alert: Alerts.kNoInternetConnection)
            }
        }else{
            self.title = KStoryBoards.KAddDepartMentIdentifiers.kAddDepartmentTitle
        }
    }
    
    //Button Add/Update department Api
    func btnAddUpdateDepartment(){
        if checkInternetConnection(){
            //For Add Department
            if departmentId == 0{
                self.viewModel?.addUpdateDepartment(departmentId: departmentId, title: txtfieldTitle.text, description: txtViewDescription.text, others: txtfieldOthers.text, imageUrl: selectedImageUrl)
            }
            //For Update Department
            if departmentId != 0{
                if selectedImageUrl != nil{
                    if (selectedImageUrl?.absoluteString.hasPrefix("http:"))!{
                        CommonFunctions.sharedmanagerCommon.println(object: "Image from detail department.")
                        selectedImageUrl = URL(string: "")
                    }
                }
                self.viewModel?.addUpdateDepartment(departmentId: departmentId, title: txtfieldTitle.text, description: txtViewDescription.text, others: txtfieldOthers.text, imageUrl: selectedImageUrl)
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
}
