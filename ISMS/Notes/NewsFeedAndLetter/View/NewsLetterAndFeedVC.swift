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
    
    
    //MARK:- lifecycle Methods
    override func viewDidLoad()
    {
    super.viewDidLoad()
       SetView()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getNewfeedData()
    }
    //MARK:- Actions
    
    @IBAction func actionAddPost(_ sender: UIButton) {
         let storyboard = UIStoryboard.init(name: KStoryBoards.kHomeWork, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AddNewsFeedPostsVC") as? AddNewsFeedPostsVC
                    let frontVC = revealViewController().frontViewController as? UINavigationController
                    frontVC?.pushViewController(vc!, animated: false)
                    revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    
    func getNewfeedData() {
        
    }
    
    
    @IBAction func actionWhatOnMind(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: KStoryBoards.kHomeWork, bundle: nil)
                     let vc = storyboard.instantiateViewController(withIdentifier: "AddNewsFeedPostsVC") as? AddNewsFeedPostsVC
                     let frontVC = revealViewController().frontViewController as? UINavigationController
                     frontVC?.pushViewController(vc!, animated: false)
                     revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    
    
    @IBAction func btnTabActions(_ sender: Any)
    {
        
    }
    //MARK:- Other functions
      func SetView()
    {
       tbleViewNewsFeed.dataSource = self
        tbleViewNewsFeed.delegate = self
        self.title = kNewsLetterAndFeedIdentifiers.kNewsLetterAndFeedTitle
        tbleViewNewsFeed.separatorStyle = .none
        tbleViewNewsFeed.tableFooterView = UIView()
         setBackButton()
        
    }

   

}
//MARK:- Table View Data Source
extension NewsLetterAndFeedVC : UITableViewDataSource,UITableViewDelegate{
    
    //Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
      
          let  cell = tableView.dequeueReusableCell(withIdentifier: kNewsLetterAndFeedIdentifiers.kEventTableCell, for: indexPath) as! EventTableCell
             return cell
        return UITableViewCell.init()
    }
    
    // Table Delegate methods
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 274
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
     return 274
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let storyboard = UIStoryboard.init(name: KStoryBoards.kExamResult, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: kExamResultIdentifiers.kExamResultVC)
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
extension NewsLetterAndFeedVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: "CellClass_UploadPosts", for: indexPath)as! CellClass_UploadPosts
       cellnew.btnPlay.tag = indexPath.row
        cellnew.btnPlay.frame = CGRect(x: cellnew.ivImg.frame.origin.x + cellnew.ivImg.frame.size.width / 2, y: cellnew.ivImg.frame.origin.y + cellnew.ivImg.frame.size.height / 2 - 30, width: 54, height: 54)
        return cellnew
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
       {
           let frame = collectionView.frame
        return CGSize(width: self.view.frame.size.width - 16, height: frame.size.height)
       }
    
    
}

extension NewsLetterAndFeedVC : UICollectionViewDelegateFlowLayout
{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        let frame = collectionView.frame
//        return CGSize(width: frame.size.width, height: frame.size.height)
//    }
    
  
}
