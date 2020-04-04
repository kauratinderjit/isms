

import UIKit
   import Alamofire

class  EventScheduleApi {
   
        static let sharedManager =  EventScheduleApi()
    
        
        //MARK:- Teacher List Api
        func  EventScheduleData(url : String,parameters: [String : Any]?,completionResponse:  @escaping (EventScheduleListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
            
            let urlCmplete = BaseUrl.kBaseURL+url
            
            print("your complete url : \(urlCmplete)")
            print("your param here : \(parameters)")
            var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiMTBkYzU3YzQtYTZjMS00NGFkLTlmMGQtMmIyMTlkYjQ0M2YwIiwiZXhwIjoxNTc0NDg3Njg3LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.JSOPh3BygV5bDtqNyO0CCCWmBwftZMFB0AtlOkist0w"
            if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
            {
                accessTokken = str
            }
            
            let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
            
            
            Alamofire.request(urlCmplete, method: .post, parameters: parameters!, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                
                if response.result.isSuccess
                {
                    guard let data = response.value else { return }
                    
                    if let responseData  = data as? [String : Any]
                    {
                        print("you response syllabus coverage: \(responseData)")
                        
                        self.getEventScheduleJSON(data: responseData, completionResponse: { (responseModel) in
                            completionResponse(responseModel)
                        }, completionError: { (mapperError) in
                            completionnilResponse(mapperError)
                        })
                        
                    }else{
                        CommonFunctions.sharedmanagerCommon.println(object: "Get Teacher list Error:- \(data) ")
                    }
                    
                }
                else
                {
                    complitionError(response.error)
                    return
                }
            }
            
        }
        
        private func getEventScheduleJSON(data: [String : Any],completionResponse:  @escaping (EventScheduleListModel) -> Void,completionError: @escaping (String?) -> Void)  {
            
            let ListData = EventScheduleListModel(JSON: data)
            
            if ListData != nil{
                completionResponse(ListData!)
            }else{
                completionError(Alerts.kMapperModelError)
            }
        }
        
    
 
 
}
