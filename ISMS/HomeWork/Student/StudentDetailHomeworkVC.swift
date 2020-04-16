//
//  StudentDetailHomeworkVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/16/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentDetailHomeworkVC: BaseUIViewController {
    
    
    @IBOutlet weak var txtfieldClass: UITextField!
    @IBOutlet weak var txtfieldSubject: UITextField!
    @IBOutlet weak var txtfieldTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtfieldSubmissionDate: UITextField!
    @IBOutlet weak var tblViewListing: UITableView!
    @IBOutlet weak var heightTblView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Homework Details"
        heightTblView.constant = 0
    }

    
    @IBAction func actionbtnSubmit(_ sender: UIButton) {
        
    }
    
    @IBAction func actionBtnDownload(_ sender: UIButton) {
    }
    
}
