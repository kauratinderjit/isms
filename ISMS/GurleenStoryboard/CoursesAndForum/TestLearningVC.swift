//
//  TestLearningVC.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class TestLearningVC: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    var names = ["What nummber shoud be added to 3/8 to get -1/24?": ["4/8", "8/7", "4/3", "6/9"], "What nummber shoud be added to 5/8 to get -1/8?": ["4/8", "8/7", "4/3", "6/9"]]
    
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (key, value) in names {
            print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(objectArray[section].sectionObjects)
         return objectArray[section].sectionObjects.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TestLearningTableViewCell
        cell?.lblAnswers.text = objectArray[indexPath.section].sectionObjects[indexPath.row]
                   return cell!
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
        
    
        
        // MARK: - Table view data source
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
         let questionTopic =  objectArray[section].sectionName
    
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        view.backgroundColor = .groupTableViewBackground
        
        let label = UILabel(frame: CGRect(x: 8, y: 0, width: view.frame.width-16, height: view.frame.height))
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.7
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = questionTopic
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
