//
//  AssignSubjectsToClassModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/9/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
class AssignSubjectsToClassModel{
    var isSelected = 0
    var isAgainSelected = 0
    var classSubjectId : Int?
    var subjectId : Int?
    var subjectName : String?
    
    init(classSubjectId : Int?,subjectId : Int?,subjectName : String?) {
        self.classSubjectId = classSubjectId
        self.subjectId = subjectId
        self.subjectName = subjectName
    }
}
