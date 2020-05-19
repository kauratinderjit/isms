//
//  LikerListModel.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/19/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//



import ObjectMapper


class LikerListModel : Mappable{
        
        var message : String?
        var status : Bool?
        var statusCode :  Int?
        var resultData : lstgetLikeModel?
        var resourceType : String?
        
    
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
            status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
            statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
            resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
            resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
        }
        
    }


  struct lstgetLikeModel: Mappable {
      
    
       var Count : Int?
       var list : [lstgetLikesListViewModels]?
       
       

      init?(map: Map) {
          
      }
      
      mutating func mapping(map: Map) {
          
          Count <- map["TotalCount"]
          list <- map["lstgetLikesListViewModels"]
               
          
      }
      
  }
    
    struct lstgetLikesListViewModels: Mappable {

         var TotalCount : Int?
         var LikedBy : String?
         var LikeId : Int?
         var CreatedDate : String?
         
         

        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            
            TotalCount <- map["TotalCount"]
            LikedBy <- map["LikedBy"]
            LikeId <- map["LikeId"]
            CreatedDate <- map["CreatedDate"]
           
            
        }
        
    }

