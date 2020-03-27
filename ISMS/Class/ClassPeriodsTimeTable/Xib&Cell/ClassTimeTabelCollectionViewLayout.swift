//
//  EPGCollectionViewLayout.swift
//  EPG
//
//  Created by Jerald Abille on 3/22/18.
//  Copyright © 2018 Jerald Abille. All rights reserved.
//

import UIKit

class ClassTimeTableCollectionViewLayout: UICollectionViewLayout {
  let cellWidth = 120.0
  let cellHeight = 110.0
  var cellAttributesDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
  var contentSize = CGSize.zero
  var dataSourceDidUpdate = true

  var days: [GetTimeTableModel.DaysModel]?

  override var collectionViewContentSize: CGSize {
    return self.contentSize
  }

  override func prepare() {
    if !dataSourceDidUpdate {
      let xOffset = collectionView!.contentOffset.x
      let yOffset = collectionView!.contentOffset.y

      if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
        for section in 0...sectionCount - 1{
          if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
            // The first row.
            if section == 0 {
              for item in 0...rowCount - 1{
                let indexPath = IndexPath(item: item, section: section)
                if let attributes = cellAttributesDictionary[indexPath] {
                  var frame = attributes.frame
                  if item == 0 {
                    frame.origin.x = xOffset
                  }
                  
                  frame.origin.y = yOffset
                  attributes.frame = frame
                }
              }
            } else {
              let indexPath = IndexPath(item: 0, section: section)
              if let attributes = cellAttributesDictionary[indexPath] {
                var frame = attributes.frame
                frame.origin.x = xOffset
                attributes.frame = frame
              }
            }
          }
        }
      }
      return
    }

    dataSourceDidUpdate = false

    if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
      for section in 0...sectionCount - 1{
        //Get day from response
        var dayModel:GetTimeTableModel.DaysModel?
        if section > 0 {
          if let day = self.days?[section - 1] {
            dayModel = day
          }
        }
        if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
          for item in 0...rowCount - 1 {
            var periodModel: GetTimeTableModel.PeriodDetailModel?
          
            if section > 0 && item > 0 {
              if let _ = dayModel {
                if let period = dayModel?.periodDetailListModel?[item - 1] {
                  periodModel = period
                }
              }
            }

            let cellIndex = IndexPath(item: item, section: section)
            var xPos = Double(item) * cellWidth
            let yPos = Double(section) * cellHeight
              let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
            if let _ = dayModel{
                cellAttributes.frame = CGRect(x: xPos, y: yPos - 80, width: 40, height: cellHeight)
            }else  if let _ = periodModel  {
                xPos = Double(item) * cellWidth
                let width = cellWidth
                cellAttributes.frame = CGRect(x: xPos, y: yPos - 80, width: width, height: cellHeight)
            }else{
                if section == 0 && item == 0 {
                      cellAttributes.frame = CGRect(x: xPos, y: yPos, width: 40, height: cellHeight - 80)
                }else if section == 0 && item == 1 {
                     cellAttributes.frame = CGRect(x: xPos - 80, y: yPos, width: 120, height: cellHeight - 80)
                }else{
                       cellAttributes.frame = CGRect(x: xPos - 80 , y: yPos, width: 120, height: cellHeight - 80)
                }
            }
            
            if let _ = periodModel  {
                debugPrint("Periods in Section \(section) periodsCount \(item)")
                
                //Adjust the first item of the period cell width
                if item == 1{
                    xPos = (Double(0) * cellWidth) + 40
                }else{
                    //Adjust the other items width of the cell
                    xPos = Double(item) * cellWidth - 80
                }
                let width = cellWidth
                //Minus 80 from y position for remove gap
                cellAttributes.frame = CGRect(x: xPos, y: yPos - 80, width: width, height: cellHeight)
            }

            if section == 0 && item == 0 {
              cellAttributes.zIndex = 4
            } else if section == 0 {
              cellAttributes.zIndex = 3
            } else if item == 0 {
              cellAttributes.zIndex = 2
            } else {
              cellAttributes.zIndex = 1
            }

            cellAttributesDictionary[cellIndex] = cellAttributes
            debugPrint("Cell Index:- \(cellIndex)")
          }
        }
      }
    }

    let contentWidth = (Double(collectionView!.numberOfItems(inSection: 0)) * cellWidth) - 80
    let contentHeight = (Double(collectionView!.numberOfSections) * cellHeight) - 80
    self.contentSize = CGSize(width: contentWidth, height: contentHeight)
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attributesInRect = [UICollectionViewLayoutAttributes]()
    for cellAttributes in cellAttributesDictionary.values {
      if rect.intersects(cellAttributes.frame) {
        attributesInRect.append(cellAttributes)
      }
    }
    return attributesInRect
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if cellAttributesDictionary[indexPath] == nil{
        self.invalidateLayout()
        return cellAttributesDictionary[indexPath]
    }else{
        return cellAttributesDictionary[indexPath]!
    }
    
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
