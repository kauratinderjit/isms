//
//  PaymentHistoryVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class PaymentHistoryVC: UIViewController {

    //MARK:- outlat and Variables
    @IBOutlet weak var tbleViewPaymentHis: UITableView!
    @IBOutlet weak var btnOrder: UIButton!
    @IBOutlet weak var btnRecharges: UIButton!
    
    //MARK:- lifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnTabAction(_ sender: Any) {
        
        if (sender as AnyObject).tag == 0
        {
            
        }
        else{
                        let storyboard = UIStoryboard.init(name: KStoryBoards.kNewsfeedAndLetter, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: kNewsLetterAndFeedIdentifiers.kNewsLetterAndFeedVC)
                      self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    //MARK:- Other Functions
    func SetView()
    {
        tbleViewPaymentHis.dataSource = self
      //  setLeftMenuButton()
        self.title = kPaymentIdentifiers.kPaymentTitle
        tbleViewPaymentHis.separatorStyle = .none
        tbleViewPaymentHis.tableFooterView = UIView()
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
extension PaymentHistoryVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: KPerformanceIdentifiers.kCellIdentifier, for: indexPath) as! PaymentHistoryCell
        cell.setUI()
        
        return cell
    }
}
