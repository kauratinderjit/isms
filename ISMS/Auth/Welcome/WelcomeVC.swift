//
//  WelcomeVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 5/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class WelcomeVC: BaseUIViewController
{
    //MARK:-  IBOutlest
    
    @IBOutlet weak var btnProceed: UIButton!
    
    @IBOutlet weak var lblLoginAccount: UILabel!
    @IBOutlet weak var lblWelcome: UILabel!
    //MARK:- life cycle method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SetView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        HideNavigationBar(navigationController: self.navigationController!)
    }
    
    
    
    //MARK:- SetView
    func SetView(){
        lblWelcome.SetRalewayFontForLabel(textSize: KTextSize.KTwentyEight)
        lblLoginAccount.SetRalewayFontForLabel(textSize: KTextSize.KSixteen)
        btnProceed.SetButtonFont(textSize: KTextSize.KSixteen)
        cornerButton(btn: btnProceed,radius: KTextSize.KEight)
        setBackgroundImageOnParentView(imageName: kImages.kBackGroundImage)
    }
    //MARK:- Actions
    @IBAction func ProceedAction(_ sender: Any)
    {
        pushToNextVC(storyboardName: KStoryBoards.kMain, viewControllerName: KStoryBoards.KLoginIdentifiers.kLoginVC)
      
    }

}
