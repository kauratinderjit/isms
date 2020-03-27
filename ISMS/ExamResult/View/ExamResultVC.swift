//
//  ExamResultVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ExamResultVC: UIViewController {
    //MARK:- Outlet and Variables
    @IBOutlet weak var tbleViewExamResult: UITableView!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtDepartment: UITextField!
    
    //MARK:- lifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- BtnActions
    @IBAction func btnSelectDepartment(_ sender: Any) {
    }
    @IBAction func btnSelectedYear(_ sender: Any) {
    }
    
    //MARK:- Other functions
    func SetView()
    {
        tbleViewExamResult.dataSource = self
        tbleViewExamResult.delegate = self
        self.title = kExamResultIdentifiers.kExamResultTitle
        tbleViewExamResult.separatorStyle = .none
        tbleViewExamResult.tableFooterView = UIView()
        //Initiallize the presenter class using delegates
        
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
extension ExamResultVC : UITableViewDataSource,UITableViewDelegate{
    
    //TableDataSource method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let  cell = tableView.dequeueReusableCell(withIdentifier: kExamResultIdentifiers.kExamResultCell, for: indexPath) as! ExamResultTableCell
        cell.examResultDelegate = self
        cell.SetUI(index:indexPath.row)
            return cell
    }
    
    //TableDelegate
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
               return 55
            }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
         return UITableView.automaticDimension
    }
    
}

extension ExamResultVC : ExamResultDelegate
{
    func downLoadResult(index: Int) {
        print("file Downloaded")
    }
    
    
}
