//
//  NewsLetterAndFeedVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class NewsLetterAndFeedVC: UIViewController {
    //MARK:- Outlat and Variables
    @IBOutlet weak var tbleViewNewsFeed: UITableView!
    @IBOutlet weak var btnBulletin: UIButton!
    @IBOutlet weak var btnNewsletter: UIButton!
    @IBOutlet weak var btnEvents: UIButton!
    var isEvent = true,isNewsLetter,isBulletin:Bool!
    
    //MARK:- lifecycle Methods
    override func viewDidLoad()
    {
    super.viewDidLoad()
       SetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK:- Actions
    @IBAction func btnTabActions(_ sender: Any)
    {
        switch (sender as AnyObject).tag
        {
        case 0:
            btnEvents.backgroundColor = UIColor(red: 134/255, green: 11/255, blue: 27/255, alpha: 1)
             btnNewsletter.backgroundColor = UIColor(red: 160/255, green: 10/255, blue: 32/255, alpha: 1)
             btnBulletin.backgroundColor = UIColor(red: 160/255, green: 10/255, blue: 32/255, alpha: 1)
            isEvent = true
            isBulletin = false
            isNewsLetter = false
            tbleViewNewsFeed.reloadData()
            break
        case 1:
            btnNewsletter.backgroundColor = UIColor(red: 134/255, green: 11/255, blue: 27/255, alpha: 1)
            btnEvents.backgroundColor = UIColor(red: 160/255, green: 10/255, blue: 32/255, alpha: 1)
            btnBulletin.backgroundColor = UIColor(red: 160/255, green: 10/255, blue: 32/255, alpha: 1)
            isEvent = false
            isBulletin = false
            isNewsLetter = true
             tbleViewNewsFeed.reloadData()
            break
        case 2:
            btnBulletin.backgroundColor = UIColor(red: 134/255, green: 11/255, blue: 27/255, alpha: 1)
            btnNewsletter.backgroundColor = UIColor(red: 160/255, green: 10/255, blue: 32/255, alpha: 1)
            btnEvents.backgroundColor = UIColor(red: 160/255, green: 10/255, blue: 32/255, alpha: 1)
            isEvent = false
            isBulletin = true
            isNewsLetter = false
             tbleViewNewsFeed.reloadData()
            break
        default:
            break
        }
    }
    //MARK:- Other functions
      func SetView()
    {
       tbleViewNewsFeed.dataSource = self
        tbleViewNewsFeed.delegate = self
        self.title = kNewsLetterAndFeedIdentifiers.kNewsLetterAndFeedTitle
        tbleViewNewsFeed.separatorStyle = .none
        tbleViewNewsFeed.tableFooterView = UIView()
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
extension NewsLetterAndFeedVC : UITableViewDataSource,UITableViewDelegate{
    
    //Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isEvent == true
        {
          let  cell = tableView.dequeueReusableCell(withIdentifier: kNewsLetterAndFeedIdentifiers.kEventTableCell, for: indexPath) as! EventTableCell
            cell.setUI()
             return cell
        }
        else if isNewsLetter == true
        {
          let  cell = tableView.dequeueReusableCell(withIdentifier: kNewsLetterAndFeedIdentifiers.kNewsLetterTableCell, for: indexPath) as! NewsLetterTableCell
             return cell
        }
        else
        {
          let  cell = tableView.dequeueReusableCell(withIdentifier: kNewsLetterAndFeedIdentifiers.kBulletinTableCell, for: indexPath) as! BulletinsTableCell
            cell.SetUI()
             return cell
        }
        return UITableViewCell.init()
    }
    
    // Table Delegate methods
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
       
            if isEvent == true{
                height = 196
            }
            else if isNewsLetter == true {
                height = 55
            }
            else
            {
                height = 87
            }
        return height
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     //  return UITableView.automaticDimension
        var height:CGFloat = CGFloat()
        if isEvent == true{
            height = 196
        }
        else if isNewsLetter == true {
            height = 55
        }
        else
        {
            height = 87
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard.init(name: KStoryBoards.kExamResult, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: kExamResultIdentifiers.kExamResultVC)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
