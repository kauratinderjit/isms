//
//  SubjectWiseRatingVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/4/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit




class SubjectWiseRatingVC: BaseUIViewController {

    var viewModel : SubjectWiseRatingViewModel?
    var array = [1,2,3,4,5,6,7,8,9]
    var arrSubjectList = [SubjectWiseRatingResultData]()
    
    @IBOutlet var tableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = SubjectWiseRatingViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        tableView.reloadData()
        // Do any additional setup after loading the view.
        self.viewModel?.getSubjectWiseRating(enrollmentsId: 6, classId: 14)

        


    }
  
    
}
