//
//  EventsPagerVC.swift
//  ISMS
//
//  Created by Mohit Sharma on 4/23/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class EventsPagerVC: BaseUIViewController
{

    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    var currentController = UIViewController()
    public var lstActionAccess : GetMenuFromRoleIdModel.ResultData?

    var eventListController = ExamScheduleVC()
    var celnderController = CalendarEventVC()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setBackButton()
        self.Events_Selected()

        // Do any additional setup after loading the view.
        
           let arrAccess = lstActionAccess?.lstActionAccess
            
            _ = arrAccess?.enumerated().map { (index,element) in
                
                if element.actionName == "Edit" {
                    self.navigationItem.rightBarButtonItem = btnAdd
                }
                
                else{
                    self.navigationItem.rightBarButtonItem = nil
                }
        }
    }
    
    
    
    @IBAction func addNewEvent(_ sender: Any)
    {
        let vc = UIStoryboard.init(name:"CalendarAndEvents", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func segmentControl(_ sender: UISegmentedControl)
    {
        if (sender.selectedSegmentIndex == 0)
        {
            self.Events_Selected()
        }
        else
        {
            self.Calender_Selected()
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
            
            mapViewController.view.frame.size.width = self.mainView.frame.size.width
            mapViewController.view.frame.size.height = self.mainView.frame.size.height
            // Add to containerview
            self.mainView.addSubview(mapViewController.view)
            self.addChild(mapViewController)
            mapViewController.didMove(toParent: self)
        }
        
        
        func Events_Selected()
        {
            self.currentController = UIStoryboard.init(name:"CalendarAndEvents", bundle: Bundle.main).instantiateViewController(withIdentifier: "ExamScheduleVC") as! ExamScheduleVC
            self.activeViewController = self.currentController
        }
        
        func Calender_Selected()
        {
            self.currentController = UIStoryboard.init(name:"CalendarAndEvents", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarEventVC") as! CalendarEventVC
            self.activeViewController = self.currentController
        }

}
