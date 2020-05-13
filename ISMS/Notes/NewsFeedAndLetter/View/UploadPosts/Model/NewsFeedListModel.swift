//
//  NewsFeedList.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/11/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//



import ObjectMapper


class NewsFeedListModel : Mappable{
        
        var message : String?
        var status : Bool?
        var statusCode :  Int?
        var resultData : [NewsListResultData]?
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
    
    struct NewsListResultData: Mappable {
        
        var Comments : String?
        var Description : String?
        var Documents : String?
        var IsLikedByMe : Int?
        var LikedBy : String?
        var LikedByMe : Int?
        var Links : String?
        var NewsLetterId : Int?
        var PostedBy : String?
        var PostedById : Int?
        var PostedDate : String?
        var Title : String?
        var TotalComments : Int?
        var TotalLikes : Int?
        var lstComments: [lstComments]?
         var lstDocuments: [lstDocuments]?
         var lstLikes: [lstLikes]?
         

        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
       
            Comments <- map["Comments"]
            Description <- map["Description"]
            Documents <- map["Documents"]
            IsLikedByMe <- map["IsLikedByMe"]
            LikedBy <- map["LikedBy"]
            LikedByMe <- map["LikedByMe"]
            Links <- map["Links"]
            NewsLetterId <- map["NewsLetterId"]
            PostedBy <- map["PostedBy"]
            PostedById <- map["PostedById"]
             PostedDate <- map["PostedDate"]
            Title <- map["Title"]
            TotalComments <- map["TotalComments"]
            TotalLikes <- map["TotalLikes"]
            lstComments <- map["lstComments"]
            lstDocuments <- map["lstDocuments"]
            lstLikes <- map["lstLikes"]
            
        }
        
    }

struct lstComments: Mappable {
     
     var Comment : String?
     var CommentId : Int?
     var CommentedBy : String?
     var CommentedById : Int?
     var CommentedDate : String?
      var URL : String?
     
    
     init?(map: Map) {
     }
     
     mutating func mapping(map: Map) {
    
        Comment <- map["Comment"]
        CommentId <- map["CommentId"]
        CommentedBy <- map["CommentedBy"]
        CommentedById <- map["CommentedById"]
        CommentedDate <- map["CommentedDate"]
        URL <- map["URL"]
     }
     
 }
    


struct lstDocuments: Mappable {
    //atinder
    var DocumentId : Int?
    var typedoc : String?
    var URL : String?
    var IsPlaying = false
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
   
       DocumentId <- map["DocumentId"]
        typedoc <- map["Type"]
        URL <- map["URL"]

    }
    
}
struct lstLikes: Mappable {
    //atinder
    var name : String?
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
   
       name <- map[""]
      
    }
    
}
