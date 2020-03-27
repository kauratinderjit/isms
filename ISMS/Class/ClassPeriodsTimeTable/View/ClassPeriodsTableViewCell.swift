//
//  ClassPeriodsTableViewCell.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
protocol UpdateValueDelegate: class {
    func changeValue(selectedRow:String)
}
class ClassPeriodsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var periodsCollectionView: UICollectionView!
     weak  var delegate: UpdateValueDelegate?
    var arrPeriodsCollectionView : [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.periodsCollectionView.delegate = self
        self.periodsCollectionView.dataSource = self
    }

    //Setup Cell
    func cellSetUp(arrDays: [String]?,arrPeriods: [String]?,indexPath: IndexPath){
        if let day = arrDays?[indexPath.row]{
            lblDays.text = day
        }
        arrPeriodsCollectionView = arrPeriods
    }
    
}
//MARK:- UICollectionViewCell
extension ClassPeriodsTableViewCell : UICollectionViewDelegate{
    
}
//MARK:- UICollectionViewDataSource
extension ClassPeriodsTableViewCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrPeriodsCollectionView?.count ?? 0 > 0{
            return arrPeriodsCollectionView?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "periodsCell", for: indexPath) as! ClassPeriodsCollectionViewCell
        cell.lblPeriod.text = arrPeriodsCollectionView?[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedRow = arrPeriodsCollectionView?[indexPath.row] {
      //  selectedRow.
        
            self.delegate?.changeValue(selectedRow: selectedRow)
        }

    }
}
