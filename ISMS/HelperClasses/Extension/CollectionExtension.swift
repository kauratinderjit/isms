//
//  CollectionExtension.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/11/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

/*
This method is used for array.Where it return nil the provided index is not exist in array. So it can handle the index out of range error.
 */
extension Collection where Indices.Iterator.Element == Index {
    
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
