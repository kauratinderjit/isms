//
//  ManageUserVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 11/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ManageUserVC: UIViewController {
    
    //MARK:- Outlet and variables
    @IBOutlet weak var tbleViewManageUser: UITableView!
    
    //MARK:- lifecycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- Actions
    @IBAction func tabAction(_ sender: Any) {
    }
    @IBAction func btnAddAction(_ sender: Any) {
    }
    
    //MARK:- Other Functions
    func SetView()
    {
        tbleViewManageUser.dataSource = self
        self.title = kPaymentIdentifiers.kPaymentTitle
        tbleViewManageUser.separatorStyle = .none
        tbleViewManageUser.tableFooterView = UIView()
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

//MARK:- Table View Data Source
extension ManageUserVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSuperAdminIdentifier.kManageUserCell, for: indexPath) as! ManageUserTableCell
        cell.SetUI()
        return cell
    }
}
