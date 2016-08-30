//
//  DateFormatting.swift
//  tractwork
//
//  Created by manatee on 8/25/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
import RealmSwift

class DA_Date {
  
  let date = NSDate()
  let dateFormatter = NSDateFormatter()
  
  
  
  func DayOfTheWeek() -> String {
//    let testName = "ootday"
    
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.stringFromDate(date)
  }
  
  func today() -> String {
    dateFormatter.dateFormat = "MMM dd yyyy"
    return dateFormatter.stringFromDate(date)
  }
  
  func NumberOfTheDay() -> String {
    
    dateFormatter.dateFormat = "dd"
    return dateFormatter.stringFromDate(date)
  }
  
}


class DA_workday {
  let realm = try! Realm()
  let date = DA_Date().today()
  
  let allWorkdays = try! Realm().objects(Workday)
  
  func areThereAnyWorkdays() -> Bool {
    if allWorkdays.count == 0 {
      return false
    } else {
      return true
    }
  }
  
  func doesTodaysWorkdayExist() -> Bool {
    var response: Bool = false
    for i in 0 ..< allWorkdays.count {
      let workday = allWorkdays[i]
      if workday.dayDate == date {
        response = true
      } else {
        response = false
      }
    }
    return response
  }
  
  func retrieveTodaysWorkday() -> Workday {
    var todaysWorkday = Workday()
    for i in 0 ..< allWorkdays.count {
      let workday = allWorkdays[i]
      if workday.dayDate == date {
        todaysWorkday = workday
      } else {
        todaysWorkday = allWorkdays.last!
      }
    }
    return todaysWorkday
  }
  
  
  func createTodaysWorkday() {
    let newWorkday = Workday()
    newWorkday.id = NSUUID().UUIDString
    newWorkday.dayDate = DA_Date().today()
    
    try! realm.write() {
      self.realm.add(newWorkday)
    }
    print("created workday")
    print(allWorkdays.count)
  }
}
