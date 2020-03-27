//
//  TeacherSubjectWiseRatingVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation



class TeacherSubjectWiseRatingVC: BaseUIViewController {
    
    var viewModel : TeacherSubjectWiseRatingViewModel?
    var array = [1,2,3,4,5,6,7,8,9]
    var arrSubjectList = [TeacherSubjectWiseRatingResultData]()
    @IBOutlet var tableView: UITableView!
  //  var classId : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TeacherSubjectWiseRatingViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        tableView.reloadData()
        // Do any additional setup after loading the view
        self.viewModel?.getSubjectWiseRating(enrollmentsId: 46, classId: 33)
    }
    
    

}
