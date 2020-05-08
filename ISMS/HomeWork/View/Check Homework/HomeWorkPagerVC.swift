//
//  HomeWorkPagerVC.swift
//  ISMS
//
//  Created by Mohit Sharma on 4/26/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class HomeWorkPagerVC: UIViewController
{
    
    @IBOutlet var baseView: UIView!
    
    var HomeworkListController = HomeworkListVC()
    var CheckHomeworkController = CheckHomeworkVC()
    var currentController = UIViewController()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setBackButton()
        self.title = "Assign Homework"

        self.HomeWorkList_Selected()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func segmentAction(_ sender: UISegmentedControl)
    {
        if (sender.selectedSegmentIndex == 0)
        {
            self.HomeWorkList_Selected()
        }
        else
        {
            self.showAlert(Message: "Coming Soon")
            // self.CheckHomeWork_Selected()
        }
    }
    
    
    //MARK: <-HANDLING OF SELECTED TABS AND CHILD VIEW CONTROLLERS ->
    private var activeViewController: UIViewController?
    {
        didSet
        {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?)
    {
        if let inActiveVC = inactiveViewController
        {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMove(toParent: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParent()
        }
    }
    
    private func updateActiveViewController()
    {
        
        let mapViewController = self.currentController
        mapViewController.willMove(toParent: self)
        
        mapViewController.view.frame.size.width = self.baseView.frame.size.width
        mapViewController.view.frame.size.height = self.baseView.frame.size.height
        // Add to containerview
        self.baseView.addSubview(mapViewController.view)
        self.addChild(mapViewController)
        mapViewController.didMove(toParent: self)
    }
    
    
    func HomeWorkList_Selected()
    {
        self.currentController = UIStoryboard.init(name:"Homework", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeworkListVC") as! HomeworkListVC
        self.activeViewController = self.currentController
    }
    
    func CheckHomeWork_Selected()
    {
        self.currentController = UIStoryboard.init(name:"Homework", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckHomeworkVC") as! CheckHomeworkVC
        self.activeViewController = self.currentController
    }

}
