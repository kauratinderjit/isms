//
//  MenuViewModel.swift
//  ISMS
//
//  Created by Poonam  on 27/07/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation

protocol MenuViewModelDelegate:class
{
    func didSuccessLogout(data: logoutModel)
//    func didSuccessMenuAccordingRole(data: GetMenuFromRoleIdModel)
}


class MenuViewModel{
 
    //HomeViewModel delegate
    weak var delegate : MenuViewModelDelegate?
    
    //Home View
    weak var MenuView : ViewDelegate?

    
    //Initialize the Presenter class
    init(delegate:MenuViewModelDelegate) {
        self.delegate = delegate
    }
    
    //Attaching Home view
    func attachView(view: ViewDelegate) {
        MenuView = view
    }
    
    
    //Detaching Home view
    func detachView() {
        MenuView = nil
    }
    
    //MARK:- Get Role Id's using userId
      func logOut(userID: Int){
          self.MenuView?.showLoader()
          LoginApi.sharedmanagerAuth.getUserRoleIds(url: "api/User/Logout?" + "userId=\(userID)&deviceType=3", parameters: nil, completionResponse: { (userRoleIdModel) in
              self.MenuView?.hideLoader()
              switch userRoleIdModel.statusCode{
              case KStatusCode.kStatusCode200:
                self.delegate?.didSuccessLogout(data: userRoleIdModel)
              case KStatusCode.kStatusCode401:
                  self.MenuView?.showAlert(alert: userRoleIdModel.message ?? "Something went wrong")
                 
              default:
                  self.MenuView?.showAlert(alert: userRoleIdModel.message ?? "Something went wrong")
                  CommonFunctions.sharedmanagerCommon.println(object: "Get Role Id APi status change")
              }
            
          }, completionnilResponse: { (nilResponseError) in
              self.MenuView?.hideLoader()
                  self.MenuView?.showAlert(alert: nilResponseError ?? "Something went wrong")
                  CommonFunctions.sharedmanagerCommon.println(object: "Get Role Id APi Nil response")
          }) { (error) in
              self.MenuView?.hideLoader()
                  self.MenuView?.showAlert(alert: error?.localizedDescription ?? "Something went wrong")
                  CommonFunctions.sharedmanagerCommon.println(object: "Get Role Id APi error response")
          }
      }
    
}
