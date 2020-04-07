//
//  NotesListVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 27/3/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class NotesListVC: UIViewController {

    @IBOutlet weak var tableViewNotesList: UITableView!
    
    var arrNotesList = ["Topic 1","Topic 2","Topic 3","Topic 4","Topic 5","Topic 6","Topic 7",]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddNotes(_ sender: Any) {
        let vc = UIStoryboard.init(name:"Notes", bundle: Bundle.main).instantiateViewController(withIdentifier: "UploadNotesVC") as! UploadNotesVC
        self.navigationController?.pushViewController(vc, animated: true)
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

extension NotesListVC : UITableViewDelegate{
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? SubjectChapterVC {
//            vc.subject_Id = subjectId
//        }
//    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedRow = arrSubjectlist[indexPath.row]
//        subjectId = selectedRow.subjectId
//        self.performSegue(withIdentifier: "SubjectToChapter", sender: self)
//
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;//Choose your custom row height
    }
    
}
extension NotesListVC : UITableViewDataSource{
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
