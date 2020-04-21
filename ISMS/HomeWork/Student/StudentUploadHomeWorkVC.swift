//
//  StudentUploadHomeWorkVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/16/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentUploadHomeWorkVC: BaseUIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var lblPlaceHolderComment: UILabel!
    @IBOutlet weak var tblViewListing: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Upload Tasks"
        heightTableView.constant = 0
    }
    

    @IBAction func actionActionFiles(_ sender: UIButton) {
    }
    
    
    @IBAction func actionSubmit(_ sender: UIButton) {
    }
    
}
