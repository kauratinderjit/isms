//
//  SubjectChapterVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SubjectChapterVC: BaseUIViewController {
    //MARK:- Variables
    
    var ViewModel : SubjectChapterViewModel?
    var arrChapterList = [ChaptersData]()
    var selectedSubjectArrIndex : Int?
 
    var isUnauthorizedUser = false
    var isSubjectAddSuccessFully = false
    var isSubjectDelete = false
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    var subject_Id:Int?
    var setButton = ""
    var ChapterID = 0
  
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSubjectName: UILabel!
    //MARK:- View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        // subject_Id = 40
        self.ViewModel = SubjectChapterViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        
        self.title = KStoryBoards.KAddSubjectIdentifiers.kSubjectListTitle
        setBackButton()
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarSubjectPlaceHolder, navigationTitle: KStoryBoards.KAddSubjectIdentifiers.kSubjectListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
    
    
    }

    override func viewWillAppear(_ animated: Bool) {
       // subject_Id = 40
        if checkInternetConnection(){
            if let id = subject_Id {
                print("your clicked subject id : \(id)")
            self.ViewModel?.chapterList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    @IBAction func ActionCreateNewChapter(_ sender: Any) {
        self.setupCustomView()
        textFieldAlert.delegate = self
     
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
