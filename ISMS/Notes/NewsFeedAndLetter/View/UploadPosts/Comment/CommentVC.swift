//
//  CommentVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/13/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage
import Foundation
class CommentVC: UIViewController {

    
     var arrNotesList = ["Topic 1","Topic 2","Topic 3","Topic 4","Topic 5","Topic 6","Topic 7",]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
extension CommentVC : UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;//Choose your custom row height
    }
    
}
extension CommentVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrNotesList.count > 0{
            tableView.separatorStyle = .singleLine
            return (arrNotesList.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesTableCell
        
        cell.setCellUI(data: arrNotesList, indexPath: indexPath)
        return cell
    }
}
