//
//  ProgramCollectionViewCell.swift
//  EPG
//
//  Created by Jerald Abille on 3/22/18.
//  Copyright © 2018 Jerald Abille. All rights reserved.
//

import UIKit

protocol PeriodCollectionViewDelegate:class {
    func assignTeacherSubjectToPeriod(selectedIndex : Int)
}

class PeriodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblNoAssign: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var subjectlabel: UILabel!
    @IBOutlet weak var btnAssignTeacherSubject: UIButton!
    var delegate : PeriodCollectionViewDelegate?
    let theme = ThemeManager.shared.currentTheme
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = theme?.boarderColor.cgColor//UIColor.lightGray.cgColor
    }
    
    func configureWith(period: GetTimeTableModel.PeriodDetailModel, isFromAttendence: Bool) {
        self.titleLabel.text = ""
        self.teacherLabel.text = ""
        self.subjectlabel.text = ""
        if period.timeTableId == 0{
            if isFromAttendence == true{
                self.lblNoAssign.isHidden = false
                btnAssignTeacherSubject.isHidden = true
            }else{
                self.lblNoAssign.isHidden = true
                btnAssignTeacherSubject.isHidden = false
            }
            
        }else{
            self.lblNoAssign.isHidden = true
            btnAssignTeacherSubject.isHidden = true
        }
        
        if period.teacherName == ""{
            if isFromAttendence == true{
                self.lblNoAssign.isHidden = false
                btnAssignTeacherSubject.isHidden = true
            }else{
                self.lblNoAssign.isHidden = true
                btnAssignTeacherSubject.isHidden = false
            }
        }else{
            self.lblNoAssign.isHidden = true
            btnAssignTeacherSubject.isHidden = true
        }
        
        if period.substituteTeacherId == 0{
              self.teacherLabel.text = period.teacherName
        }else{
              self.teacherLabel.text = period.substituteTeacherName
        }
        self.titleLabel.text = period.periodName
        self.subjectlabel.text = period.subjectName
        self.teacherLabel.textColor = UIColor.darkGray
        self.subjectlabel.textColor = UIColor.darkGray
        
    }
    
    @IBAction func btnAssignTeacherSubjectAction(_ sender: Any) {
        delegate?.assignTeacherSubjectToPeriod(selectedIndex: (sender as AnyObject).tag)
    }
    
}
