//
//  HomeworkListVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/7/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class HomeworkListVC: BaseUIViewController {
    
    @IBOutlet weak var tblViewListing: UITableView!
    public var lstActionAccess : GetMenuFromRoleIdModel.ResultData?
    private var pickerView = UIPickerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    func setView() {
        tblViewListing.tableFooterView = UIView()
    }
    
    @IBAction func editAction(_ sender: UIButton) {
    }
    
    
    @IBAction func deleteAction(_ sender: UIButton) {
    }
    

}

extension HomeworkListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeWorkCell
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    
}
