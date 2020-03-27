//
//  CreateQuizVC.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class CreateQuizVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func ActionAddNewItem(_ sender: Any) {
    }
    
    
}
extension CreateQuizVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CreateQuizTableViewCell
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
}
