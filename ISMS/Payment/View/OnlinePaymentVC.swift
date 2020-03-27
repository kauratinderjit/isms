//
//  OnlinePaymentVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class OnlinePaymentVC: UIViewController {

    //MARK:- outlet
    @IBOutlet weak var tblOnlinePayment: UITableView!
    
    //MARK:- lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetView()
    }
    
    //MARK:- Other Functions
    func SetView()
    {
        tblOnlinePayment.dataSource = self
       // setLeftMenuButton()
        self.title = kPaymentIdentifiers.kPaymentTitle
        tblOnlinePayment.separatorStyle = .none
        tblOnlinePayment.tableFooterView = UIView()
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
extension OnlinePaymentVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: KPerformanceIdentifiers.kCellIdentifier, for: indexPath) as! OnlinePaymentCell
       
        return cell
    }
 }
