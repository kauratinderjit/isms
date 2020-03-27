//
//  SendMessageVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 11/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SendMessageVC: UIViewController {

    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var nameArr : [String] = ["Mikey Mouse","Tom","Jerry","Cat","Shinchan"]
    var id : [String] = ["Mikey@gmail.com","Tom@gmail.com","Jerry@gmail.com","Cat@gmail.com","Shinchan@gmail.com"]
     var department : [String] = ["HOD","Teacher","Student","HOD","Teacher"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func actionBtn1(_ sender: Any) {
    }
    
    @IBAction func actionBtn2(_ sender: Any) {
    }
    
}
extension SendMessageVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;//Choose your custom row height
    }
    
}
extension SendMessageVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! SendMessageCell
        cell.lblName.text = nameArr[indexPath.row]
        cell.lblDepartment.text = department[indexPath.row]
        cell.lblID.text = id[indexPath.row]
        return cell
    }
}
