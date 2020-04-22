//
//  SubjectTopicVC.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SubjectTopicVC: BaseUIViewController {
    //MARK:- Variables
    
     var isUnauthorizedUser = false
    var ViewModel : SubjectChapterTopicViewModel?
    var arrSubjectlist = [GetTopicResultData]()
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    var ChapterID : Int?
    var isSubjectAddSuccessFully = false
    var setButton = ""
    var topicID = 0
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK:- View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        self.ViewModel = SubjectChapterTopicViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        
        if let ChapterId = ChapterID {
        self.ViewModel?.TopicList(search: "", skip: 0, pageSize: 10, sortColumnDir: "", sortColumn: "", particularID: ChapterId)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func ActionAddTopic(_ sender: Any) {
        self.setupCustomView()
        textFieldAlert.delegate = self
    }
}
