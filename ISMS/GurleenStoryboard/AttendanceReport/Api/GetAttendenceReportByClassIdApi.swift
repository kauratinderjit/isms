//
//  GetAttendenceReportByClassIdApi.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/6/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

//MARK:- variables
class AttendanceReportApi
{
    static let sharedInstance = AttendanceReportApi()

//MARK:- Get School Information api
func GetAttendenceReportByClassIdApi(url : String, parameter : [String:Any]?, completionResponse:  @escaping (AttendanceReportModel) -> Void,completionnilResponse:  @escaping () -> Void,Error: @escaping (String?) -> Void)
{
    let urlComplete = BaseUrl.kBaseURL + url
    var accessTokken = ""
    if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
    {
        accessTokken = str
    }
    let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
    
    print(urlComplete)
    Alamofire.request(urlComplete, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
        .responseJSON { response in
            
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                print(data)
                if let responseData  = data as? [String : Any]
                {
                    self.AttendanceReportDataJSON(data: responseData, completionResponse: { (attendanceReportData) in
                        completionResponse(attendanceReportData)
                    }, completionError: { (error) in
                        Error(error)
                        print("All Country Mapper Error:- ")
                    })
                }
            }
            else
            {
                Error(response.error?.localizedDescription)
                return
            }
    }
}
    private func AttendanceReportDataJSON(data: [String : Any],completionResponse:  @escaping (AttendanceReportModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let attendanceReportData = AttendanceReportModel(JSON: data)
        if attendanceReportData != nil{
            completionResponse(attendanceReportData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
        
    }
}
