//
//  DA_Workday.swift
//  tractwork
//
//  Created by manatee on 9/2/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
import RealmSwift
import AFDateHelper

class DA_Workday {
  let realm = try! Realm()
  let date = DA_Date()
  
  var id = "1"
  var dayDate: NSDate? = nil
  var project = "General Work"
  var totalHoursWorked = 8
  var worker = "milo"
  
  let allWorkdays = try! Realm().objects(Workday)
  
  func areThereAnyWorkdays() -> Bool {
    if allWorkdays.count == 0 {
      print("no workdays (areThereAnyWorkdays())")
      return false
    } else {
      print("workdays exist (areThereAnyWorkdays())")
      return true
    }
  }
  
  
  func retrieveTodaysWorkday() -> Workday {
    let todaysWorkday = DA_Workday()
    var workday = Workday()

    if areThereAnyWorkdays() {
      for i in 0 ..< allWorkdays.count {
        workday = allWorkdays[i]
        if workday.dayDate!.isToday() {
          print("Workday from DB - \(workday.id)")
          todaysWorkday.id = workday.id
          print("Workday copy to use - \(todaysWorkday.id)")
          todaysWorkday.dayDate = workday.dayDate
          
        } else {
          print("creating workday (retrieveTodaysWorkday())")
          todaysWorkday.createTodaysWorkday()
        }
      }
    } else {
      workday = todaysWorkday.createTodaysWorkday()
      print("created workday (retrieveTodaysWorkday())")
    }
    
    print("workday exists (retrieveTodaysWorkday())")
    return workday
  }
  
  
  func doesTodaysWorkdayExist() -> Bool {
    var response: Bool = false
    for i in 0 ..< allWorkdays.count {
      let workday = allWorkdays[i]
      if workday.dayDate == date.today() {
        response = true
      } else {
        response = false
      }
    }
    return response
  }
  
  
  
  func createTodaysWorkday() -> Workday {
    let newWorkday = Workday()
    let todaysWorkday = DA_Workday()
    newWorkday.id = NSUUID().UUIDString
    newWorkday.dayDate = NSDate()
    
    try! realm.write() {
      self.realm.add(newWorkday)
    }
    print("created workday (createTodaysWorkday()")
    print("\(allWorkdays.count) workdays" )
    todaysWorkday.id = newWorkday.id
    print("new Todays workday id \(todaysWorkday.id)")
    
    todaysWorkday.dayDate = newWorkday.dayDate
    return newWorkday
    
  }
}