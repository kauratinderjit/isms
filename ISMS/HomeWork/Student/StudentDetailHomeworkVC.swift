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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    @IBAction func actionbtnSubmit(_ sender: UIButton) {
        
    }
    
    @IBAction func actionBtnDownload(_ sender: UIButton) {
    }
    
}
