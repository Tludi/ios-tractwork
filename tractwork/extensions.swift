//
//  extensions.swift
//  tractwork
//
//  Created by manatee on 9/5/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
import RealmSwift

extension Array {
  // partition array by given amount
  func partitionBy(subSize: Int) -> [[Element]] {
    return 0.stride(to: self.count, by: subSize).map { startIndex in
      let endIndex = startIndex.advancedBy(subSize, limit: self.count)
      return Array(self[startIndex ..< endIndex])
    }
  }
}


extension Double {
  /// Rounds the double to decimal places value
  func roundToPlaces(places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return round(self * divisor) / divisor
  }
  
  func getHourAndMinuteOutput(total: Double) -> String {
    // split total time into whole and decimal to convert to minutes
    let total = modf(total)
    let hr = Int(total.0)
    let min = Int(total.1.roundToPlaces(2)*60)
    print("\(total) hours calculated")
    
    let totalTimeText = "\(hr):\(min)"
    return totalTimeText
  }
}


extension TodayViewController {
  
  func pullTimePunchTimes(timePunches: List<TimePunch>) -> [NSDate?] {
    let timePunches = timePunches
    var pulledTimes = [NSDate?]()
    for time in timePunches {
      pulledTimes.append(time.punchTime)
    }
    return pulledTimes // as NSDate Array
  }
  
  func convertNSDateToHourAndMin(timesToConvert: [NSDate?]) -> [Double] {
    var hoursMinutesArray = [Double]()
    let timesToConvert = timesToConvert
    for time in timesToConvert {
      let hour = Double(NSCalendar.currentCalendar().component(.Hour, fromDate: time!))
      let minute = Double(NSCalendar.currentCalendar().component(.Minute, fromDate: time!))/60
      let hoursMinutes = hour + minute
      hoursMinutesArray.append(hoursMinutes)
    }
    return hoursMinutesArray
  }
  
  
  func sortArraybyTwos(array0: [Double]) -> [[Double]] {
    var myArray = array0
    let now = NSDate()
    let hour = Double(NSCalendar.currentCalendar().component(.Hour, fromDate: now))
    let minute = Double(NSCalendar.currentCalendar().component(.Minute, fromDate: now))/60
    let currentTime = hour + minute    // Need to change to current time
//    let fillerPunch = Double(now.hour() + (now.minute()*0.001))
    print("\(currentTime) now")
    if myArray.count % 2 != 0 {
      myArray.append(currentTime)
    }
    let partitionedArray = myArray.partitionBy(2)
    print("partitioned array \(partitionedArray)")
    return partitionedArray
  }
  
  func calculateTotalTime(timePunches: List<TimePunch>, workday: Workday) {
    // Start Counter for total time for the day
    var totalCounter = 0.0
    // put the dayDate (NSDate?) for each day and put in array
    let pulledTimes = pullTimePunchTimes(timePunches) // [NSDate?]
    // Convert NSDate? array to Double (hr.min) array
    let convertedTimes = convertNSDateToHourAndMin(pulledTimes) // [Double]
    // partition Double array into pairs
    let partitionedTimes = sortArraybyTwos(convertedTimes) // [[Double]]
    // get difference in each in/out punches and add to total
    for bit in partitionedTimes {
      let difference = bit[1] - bit[0]
      totalCounter += difference
      print("totalcounter \(totalCounter)")
    }
    
    let realm = try! Realm()
    try! realm.write() {
      workday.totalHoursWorked = totalCounter
    }
    
    // split total time into whole and decimal to convert to minutes
//    let total = modf(totalCounter)
//    let hr = Int(total.0)
//    let min = Int(total.1.roundToPlaces(2)*60)
//    print("\(timePunches.count) from calculations")
//    print("\(total) hours calculated")
    
    totalTimeLabel.text = totalCounter.getHourAndMinuteOutput(totalCounter)
  }
}