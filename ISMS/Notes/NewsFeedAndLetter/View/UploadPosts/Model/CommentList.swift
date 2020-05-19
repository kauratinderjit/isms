//
//  NewsFeedList.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/11/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//



import ObjectMapper


class CommentList : Mappable{
        
        var message : String?
        var status : Bool?
        var statusCode :  Int?
        var resultData : lstgetCommentViewModel?
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


  struct lstgetCommentViewModel: Mappable {
      
    
       var Count : Int?
       var list : [lstgetCommentViewList]?
       
       

      init?(map: Map) {
          
      }
      
      mutating func mapping(map: Map) {
          
          Count <- map["Count"]
          list <- map["lstgetCommentViewModel"]
               
          
      }
      
  }
    
    struct lstgetCommentViewList: Mappable {
        
         var AttachmentUrl : String?
         var Comment : String?
         var CommentId : Int?
         var CommentedBy : String?
         var Count : Int?
         var CreatedDate : String?
         
         

        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            
            AttachmentUrl <- map["AttachmentUrl"]
            Comment <- map["Comment"]
            CommentId <- map["CommentId"]
            CommentedBy <- map["CommentedBy"]
            Count <- map["Count"]
            CreatedDate <- map["CreatedDate"]
                 
            
        }
        
    }
