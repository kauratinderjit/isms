//
//  MarkAttendenceVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 11/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

class ProgramViewModel {
  var program: Program
  var titleString: String
  var startTimeString: String
  var endTimeString: String
  var durationString: String

  var scheduleDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "HH:mm"
    return formatter
  }()

  var dateComponentsFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [ .hour, .minute ]
    formatter.unitsStyle = .short
    return formatter
  }()

  init(program: Program) {
    self.program = program
    self.titleString = program.title
    self.startTimeString = scheduleDateFormatter.string(from: program.startDate)
    self.endTimeString = scheduleDateFormatter.string(from: program.endDate)
    self.durationString = dateComponentsFormatter.string(from: program.duration)!
  }
}
