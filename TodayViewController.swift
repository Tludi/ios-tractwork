//
//  TodayTableViewController.swift
//  tractwork
//
//  Created by manatee on 8/18/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift
import AFDateHelper

class TodayViewController: UIViewController{
  
  var currentStatus = false
  
  // DA Objects
  var workdayCount = 0
  let todaysDate = DA_Date()
  var todaysWorkday = Workday()
  var testDate = NSDate()
  
  // Realm Database queries
//  let realm = try! Realm()
//  let timePunches = try! Realm().objects(TimePunch)
//  var weekDays = try! Realm().objects(Workday) // need to limit for this week
  
  
  
  
  let darkGreyNavColor = UIColor(red: 6.0/255.0, green: 60.0/255.0, blue: 54.0/255.0, alpha: 0.95)
  let lightGreyNavColor = UIColor(red: 136.0/255.0, green: 166.0/255.0, blue: 173.0/255.0, alpha: 0.95)
  let tableColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
  
  @IBOutlet weak var dayNameLabel: UILabel!
  @IBOutlet weak var dayNumberLabel: UILabel!
  

  @IBAction func clearTimePunches(sender: UIBarButtonItem) {
    let realm = try! Realm()
    let timePunches = try! Realm().objects(TimePunch)
    try! realm.write {
      realm.delete(timePunches)
    }
    timepunchTable.reloadData()
    counter = 0
    totalTimeLabel.text = "\(counter):00"
  }
  
  @IBAction func clearWorkDays(sender: UIBarButtonItem) {
    let realm = try! Realm()
    let workdays = try! Realm().objects(Workday)
    try! realm.write {
      realm.delete(workdays)
    }
    weekTable.reloadData()
  }
  
  
  
  //*** Tables ***//
  @IBOutlet weak var timepunchTable: UITableView!
  @IBOutlet weak var weekTable: UITableView!
  
  
  
  //*** Labels ***//
  @IBOutlet weak var nsDateLabel: UILabel!
  @IBOutlet weak var testForWorkdayLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  
  //*** Button Outlets ***//
  @IBOutlet weak var timepunchButtonOutlet: UIButton!
  
  
  
  // *** Actions for touching in/out button
  var counter = 0
  @IBAction func timepunchButton(sender: UIButton) {
    
    let newTimePunch = TimePunch()
    let todaysTimePunches = todaysWorkday.timePunches
    let realm = try! Realm()
    
    try! realm.write {
      currentStatus = !currentStatus
      newTimePunch.id = NSUUID().UUIDString
      newTimePunch.punchTime = NSDate()
      newTimePunch.status = currentStatus
      
      todaysTimePunches.append(newTimePunch)
      
    }
    print("\(todaysTimePunches.count) timePunches")
    timepunchTable.reloadData()
    todayActive()
//    counter += 1
//    totalTimeLabel.text = "\(counter):00"
    calculateTotalTime(todaysTimePunches, workday: todaysWorkday)
  }
  
  
//  func calculateTotalTime(todaysTimePunches: List<TimePunch>) {
//    print("\(todaysTimePunches.count) from calculations")
//    
//    counter += 1
//    totalTimeLabel.text = "\(counter):00"
//  }
  
  
  
  
  
  
  // *** Need to install ability to show past days
  // *** Not working yet
  @IBAction func backWorkdayButton(sender: UIButton) {
    workdayCount += 1
  }
  
  // do not need anymore
  @IBAction func checkWorkday(sender: UIBarButtonItem) {
//    let workday = DA_Workday()
//    let todaysWorkday = workday.doesTodaysWorkdayExist()
//    
//    if todaysWorkday {
//      testForWorkdayLabel.text = "Today has a workday"
//    } else {
//      testForWorkdayLabel.text = "Today is missing a workday"
//    }
  }
  
  // do not need anymore
  @IBAction func addWorkday(sender: UIBarButtonItem) {
//    let workday = DA_Workday()
//    
//    workday.createTodaysWorkday()
//    
  }
  
  
  //*** Table Nav Bar ***//
  
  @IBOutlet weak var todayNavBox: UIView!
  @IBOutlet weak var todayButtonLabel: UIButton!
  @IBAction func showTodayButton(sender: UIButton) {
    todayActive()
  }
  
  func todayActive() {
    todayNavBox.backgroundColor = lightGreyNavColor
    todayButtonLabel.setTitleColor(darkGreyNavColor, forState: .Normal)
    weekNavBox.backgroundColor = darkGreyNavColor
    weekButtonLabel.setTitleColor(lightGreyNavColor, forState: .Normal)
    fourWeekNavBox.backgroundColor = darkGreyNavColor
    fourWeekButtonLabel.setTitleColor(lightGreyNavColor, forState: .Normal)
    
    timepunchTable.hidden = false
    weekTable.hidden = true
    totalTimeLabel.hidden = false
    timepunchTable.reloadData()
  }
  
  
  @IBOutlet weak var weekNavBox: UIView!
  @IBOutlet weak var weekButtonLabel: UIButton!
  @IBAction func showWeekButton(sender: UIButton) {
    todayNavBox.backgroundColor = darkGreyNavColor
    todayButtonLabel.setTitleColor(lightGreyNavColor, forState: .Normal)
    weekNavBox.backgroundColor = lightGreyNavColor
    weekButtonLabel.setTitleColor(darkGreyNavColor, forState: .Normal)
    fourWeekNavBox.backgroundColor = darkGreyNavColor
    fourWeekButtonLabel.setTitleColor(lightGreyNavColor, forState: .Normal)
    timepunchTable.hidden = true
    weekTable.hidden = false
    totalTimeLabel.hidden = true
    weekTable.reloadData()
  }
  
  
  @IBOutlet weak var fourWeekNavBox: UIView!
  @IBOutlet weak var fourWeekButtonLabel: UIButton!
  @IBAction func showFourWeekButton(sender: UIButton) {
    todayNavBox.backgroundColor = darkGreyNavColor
    todayButtonLabel.setTitleColor(lightGreyNavColor, forState: .Normal)
    weekNavBox.backgroundColor = darkGreyNavColor
    weekButtonLabel.setTitleColor(lightGreyNavColor, forState: .Normal)
    fourWeekNavBox.backgroundColor = lightGreyNavColor
    fourWeekButtonLabel.setTitleColor(darkGreyNavColor, forState: .Normal)

  }
  
  
  //**** process view  ****//
  
  override func viewWillAppear(animated: Bool) {
    // retrieve or create todays workday
    let workday = DA_Workday()
    todaysWorkday = workday.retrieveTodaysWorkday()
    print(todaysWorkday.dayDate)
    print("\(todaysWorkday.timePunches.count) timePunches for today")
    let timePunches = todaysWorkday.timePunches
    if timePunches.count == 0 {
      currentStatus = false
    }
    totalTimeLabel.text = todaysWorkday.totalHoursWorked.getHourAndMinuteOutput(todaysWorkday.totalHoursWorked)
    print("testing date \(testDate.toString(format: .Custom("dd MMM yyyy HH:mm:ss")))")
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let timePunches = try! Realm().objects(TimePunch)
    print("\(timePunches.count) timepunches in database")
    
    timepunchTable.registerNib(UINib(nibName: "TimePunchTableViewCell", bundle: nil), forCellReuseIdentifier: "timePunchCell")
    weekTable.registerNib(UINib(nibName: "WeekHoursTableViewCell", bundle: nil), forCellReuseIdentifier: "weekHoursCell")
    
    //*** set initial colors for tables ***//
    timepunchTable.backgroundColor = tableColor
    weekTable.backgroundColor = tableColor
    weekTable.hidden = true
    
    todayNavBox.backgroundColor = lightGreyNavColor
    todayButtonLabel.setTitleColor(darkGreyNavColor, forState: .Normal)
    
    dayNameLabel.text = todaysDate.DayOfTheWeek()
    dayNumberLabel.text = todaysDate.NumberOfTheDay()
    nsDateLabel.textColor = UIColor.whiteColor()
    nsDateLabel.text = "\(todaysDate.date)"
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.translucent = true
    
    timepunchButtonOutlet.layer.cornerRadius = 75
  }

  

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let weekDays = try! Realm().objects(Workday) // need to limit for this week
      
      if tableView == timepunchTable {
        let todaysTimePunches = todaysWorkday.timePunches
        return todaysTimePunches.count
      } else if tableView == weekTable {
        return weekDays.count
      } else {
        return 2
      }
    }

  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let todaysTimePunches = todaysWorkday.timePunches
      let weekDays = try! Realm().objects(Workday) // need to limit for this week
      
      if tableView == timepunchTable {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("timePunchCell") as! TimePunchTableViewCell

        let timePunch = todaysTimePunches[indexPath.row]

        if timePunch.status {
          cell.statusLabel.text = "IN"
          cell.statusColorImage.image = UIImage(named: "smGreenCircle")
        } else {
          cell.statusLabel.text = "OUT"
          cell.statusColorImage.image = UIImage(named: "smRedCircle")
        }
//        timePunchLabel.text = timePunch.punchTime
        cell.timePunchLabel.text = "\(timePunch.punchTime!.toString(format: .Custom("hh:mm:ss")))"
//        cell.timePunchLabel.text = "Hello"

        return cell
        
        
        //*** Week Tab  ***//
      } else if tableView == weekTable {
        let cell = tableView.dequeueReusableCellWithIdentifier("weekHoursCell") as! WeekHoursTableViewCell
//        print ("pressed week")
//        print(weekDays.count)
        let workday = weekDays[indexPath.row]
        cell.weekHoursLabel.text = workday.dayDate!.toString(format: .Custom("dd MMM YYYY"))
        cell.totalHoursLabel.text = workday.totalHoursWorked.getHourAndMinuteOutput(workday.totalHoursWorked)
        cell.dayNameLabel.text = workday.dayDate?.toString(format: .Custom("EEEE"))
        return cell
        
      } else {
        let cell = tableView.dequeueReusableCellWithIdentifier("notUsed")
        return cell!
      }
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
