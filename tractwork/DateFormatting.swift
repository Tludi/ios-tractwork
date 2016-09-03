//
//  DateFormatting.swift
//  tractwork
//
//  Created by manatee on 8/25/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
//import RealmSwift

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
  
  func PunchTime(punchDate:NSDate) -> String {
    dateFormatter.dateFormat = "h:mm a"
    return dateFormatter.stringFromDate(punchDate)
  }
  
}



