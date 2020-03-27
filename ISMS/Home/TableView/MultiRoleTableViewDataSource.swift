//
//  MultiRoleTableViewDataSource.swift
//  ISMS
//
//  Created by Taranjeet Singh on 11/11/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

protocol UserRoleTableViewDelegate:class{
    func selectRoleButton(_ selectedData: UserRoleIdModel.ResultData?)
}

class MultiRoleTableViewDataSource : NSObject {
    var multiRoleArray : UserRoleIdModel?
    var delegate : UserRoleTableViewDelegate?
}

extension MultiRoleTableViewDataSource : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multiRoleArray?.resultData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserRoleTableCell else { return UITableViewCell() }
        let roleData = multiRoleArray?.resultData?[indexPath.row]
        cell.allUserRoles = roleData
        cell.selectUserRoleCellBlock = {[weak self]  in
            self?.delegate?.selectRoleButton(roleData)
        }
        return cell
    }
    
    
}

extension MultiRoleTableViewDataSource : UITableViewDelegate{
    
    
    
}
