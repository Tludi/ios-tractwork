//
//  Realm_Models.swift
//  Tractwork - Time Tracking
//
//  Created by manatee on 8/18/16.
//  Copyright (c) 2016 diligentagility. All rights reserved.
//
//  Realm Database models
//
//*** Objects ***//
//***************//
//  * Workday
//  * TimePunch
//  * Project


import Foundation
import RealmSwift
import AFDateHelper

class Workday: Object {
  dynamic var id = ""
  dynamic var dayDate = String()
  dynamic var project = "general work"
  dynamic var totalHoursWorked = 8
  dynamic var worker = "milo"
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  let timePunches = List<TimePunch>()
  let projects = List<Project>()
  
}



class TimePunch: Object {
  dynamic var id = ""
  dynamic var punchTime: NSDate? = nil
  dynamic var status = false
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  
  var timePunchWorkday = LinkingObjects(fromType: Workday.self, property: "timePunches")
}



class Project: Object {
  dynamic var id = ""
  dynamic var projectName = "general work"
  dynamic var projectExternalID = "project ID"
  dynamic var locationAddress = "1234 happy drive"
  dynamic var locationCity = "Portland"
  dynamic var locationState = "Oregon"
  dynamic var locationZIP = "12345"
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  var workdayProject = LinkingObjects(fromType: Workday.self, property: "projects")
  
}
