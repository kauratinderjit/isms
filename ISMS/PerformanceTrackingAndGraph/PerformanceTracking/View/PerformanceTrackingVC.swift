//
//  PerformanceTrackingVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class PerformanceTrackingVC: BaseUIViewController
{
    //MARK:- Outlet and Variables
    @IBOutlet weak var btnStudents: UIButton!
    @IBOutlet weak var btnTeachers: UIButton!
    @IBOutlet weak var txtSelectedSubject: UITextField!
    @IBOutlet weak var txtSelectedClass: UITextField!
    @IBOutlet weak var tableViewPerformance: UITableView!
    
    //MARK:- lifeCycleMethod
    override func viewDidLoad() {
        super.viewDidLoad()
        SetView()
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    }
   
    @IBAction func BtnStudentTeacherAction(_ sender: Any) {
        if (sender as AnyObject).tag == 0
        {
//            let storyboard = UIStoryboard.init(name: KStoryBoards.kPerformance, bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: KPerformanceIdentifiers.kPerformanceGraphVC)
//          self.navigationController?.pushViewController(vc, animated: false)
        }else
        {
            
        }
    }
    
    //MARK:- Other Functions
    func SetView()
    {
        UnHideNavigationBar(navigationController: self.navigationController)
        tableViewPerformance.dataSource = self
        //Set Search bar in navigation
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KPerformanceIdentifiers.kPerformanceTrackingTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self )
        setLeftMenuButton()

       // self.title = KPerformanceIdentifiers.kPerformanceTrackingTitle
        tableViewPerformance.separatorStyle = .none
        tableViewPerformance.tableFooterView = UIView()
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
extension PerformanceTrackingVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PerformanceTrackingTableCell
        cell.lblUserName.text = "John"
        cell.lblPercentage.text = "90%"
        return cell
    }
}

//MARK:- NavigationSearch Delegate
extension PerformanceTrackingVC : NavigationSearchBarDelegate{
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        
    }
    
    
}
