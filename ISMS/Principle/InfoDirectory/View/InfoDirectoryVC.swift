//
//  InfoDirectoryVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 11/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class InfoDirectoryVC: UIViewController {

    @IBOutlet weak var tableViewInfoDire: UITableView!
    
    var selectBtn : Int = 0
    var nameStudentArr : [String] = ["Mikey Mouse","Tom","Jerry","Cat","Shinchan"]
    var ClassArr : [String] = ["Class: A","Class: B","Class: C","Class: D","Class: E"]
    
    var nameStaffArr : [String] = ["Riya","Priya","abhilasha","kirti","siya"]
    var nameParentArr : [String] = ["Rahul","Preeti","Nisha","Ruhi","Ruh"]
 
    @IBOutlet weak var btnStudent: UIButton!
    
    @IBOutlet weak var btnStaff: UIButton!
    @IBOutlet weak var btnParent: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInfoDire.delegate = self
        tableViewInfoDire.dataSource = self
        tableViewInfoDire.tableFooterView = UIView()
        btnStaff.backgroundColor = UIColor.colorFromHexString("A40D1C")
        btnParent.backgroundColor = UIColor.colorFromHexString("A40D1C")
        btnStudent.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
    }
    
    @IBAction func StudentList(_ sender: Any) {
        btnStaff.backgroundColor = UIColor.colorFromHexString("A40D1C")
        btnParent.backgroundColor = UIColor.colorFromHexString("A40D1C")
          btnStudent.backgroundColor = UIColor.red
        selectBtn = 0
        tableViewInfoDire.reloadData()
    }
    
 
    @IBAction func StaffList(_ sender: Any) {
        btnStaff.backgroundColor = UIColor.red
        btnParent.backgroundColor = UIColor.colorFromHexString("A40D1C")
        btnStudent.backgroundColor = UIColor.colorFromHexString("A40D1C")
        selectBtn = 1
        tableViewInfoDire.reloadData()
    }
    
    @IBAction func parentList(_ sender: Any) {
        btnStaff.backgroundColor = UIColor.colorFromHexString("A40D1C")
        btnParent.backgroundColor = UIColor.red
        btnStudent.backgroundColor = UIColor.colorFromHexString("A40D1C")
        selectBtn = 2
        tableViewInfoDire.reloadData()
    }
}
extension InfoDirectoryVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80;//Choose your custom row height
    }
    
}
extension InfoDirectoryVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameStudentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoDirectoryCell
        if selectBtn == 0{
             cell.lblName.text = nameStudentArr[indexPath.row]
             cell.lblClass.text = ClassArr[indexPath.row]
        }else   if selectBtn == 1{
            cell.lblName.text = nameStaffArr[indexPath.row]
             cell.lblClass.text = ClassArr[indexPath.row]
        }else {
             cell.lblName.text = nameParentArr[indexPath.row]
            
        }
        return cell
    }
}
