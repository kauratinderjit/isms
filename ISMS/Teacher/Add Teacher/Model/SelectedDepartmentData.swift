//
//  SelectedDepartmentData.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/6/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

struct SelectedDepartmentDataModel{
    var departmentName : String?
    var departmentId : Int?
    var isSelected = 0
    
    init(departmentName : String?,departmentId:Int?) {
        self.departmentName = departmentName
        self.departmentId = departmentId
    }
}
