//
//  TodayTableViewController.swift
//  tractwork
//
//  Created by manatee on 8/18/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift

class TodayViewController: UIViewController{
  
  let realm = try! Realm()
  let timePunches = try! Realm().objects(TimePunch)
  var currentStatus = false
  let date = NSDate()
  var todaysWorkday = Workday()
  
  
  let darkGreyNavColor = UIColor(red: 6.0/255.0, green: 60.0/255.0, blue: 54.0/255.0, alpha: 0.95)
  let lightGreyNavColor = UIColor(red: 136.0/255.0, green: 166.0/255.0, blue: 173.0/255.0, alpha: 0.95)
  let tableColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
  
  @IBOutlet weak var dayNameLabel: UILabel!
  @IBOutlet weak var dayNumberLabel: UILabel!
  
  // attributes for TimePunch
//  dynamic var id = ""
//  dynamic var punchTime = "time"
//  dynamic var status = false

  @IBAction func clearTimePunches(sender: UIBarButtonItem) {
    try! realm.write {
      realm.deleteAll()
    }
    timepunchTable.reloadData()
    print("\(timePunches.count) timePunches")
  }
  
  //*** Tables ***//
  @IBOutlet weak var timepunchTable: UITableView!
  @IBOutlet weak var weekTable: UITableView!
  
  
  
  //*** Labels ***//
  @IBOutlet weak var nsDateLabel: UILabel!
  @IBOutlet weak var testForWorkdayLabel: UILabel!
  
  //*** Button Outlets ***//
  @IBOutlet weak var timepunchButtonOutlet: UIButton!
  
  
  
  // *** Actions for touching in/out button
  @IBAction func timepunchButton(sender: UIButton) {
    let newTimePunch = TimePunch()
    let punchTime = NSDate()
    
    
    
    try! realm.write {
      currentStatus = !currentStatus
      newTimePunch.id = NSUUID().UUIDString
      newTimePunch.punchTime = "\(punchTime)"
      newTimePunch.status = currentStatus
      print(newTimePunch.punchTime)
      realm.add(newTimePunch)
    }
    print("\(timePunches.count) timePunches")
    timepunchTable.reloadData()
    todayActive()
  }
  
  
  @IBAction func checkWorkday(sender: UIBarButtonItem) {
    let workday = DA_workday()
    let todaysWorkday = workday.doesTodaysWorkdayExist()
    
    if todaysWorkday {
      testForWorkdayLabel.text = "Today has a workday"
    } else {
      testForWorkdayLabel.text = "Today is missing a workday"
    }
  }
  
  @IBAction func addWorkday(sender: UIBarButtonItem) {
    let workday = DA_workday()
    
    workday.createTodaysWorkday()
    
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
    let workday = DA_workday()
    if workday.doesTodaysWorkdayExist() {
      // if todays workday exists, get todays workday
      testForWorkdayLabel.text = "Workday Exists"
      let todaysWorkday = workday.retrieveTodaysWorkday()
      print(todaysWorkday.dayDate)
      print("Workday exists for today")
    } else {
      // if todays workday does not exist, create new workday
      testForWorkdayLabel.text = "Creating Workday for today"
      workday.createTodaysWorkday()
      print("Created Workday for today")
    }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    timepunchTable.registerNib(UINib(nibName: "TimePunchTableViewCell", bundle: nil), forCellReuseIdentifier: "timePunchCell")
    weekTable.registerNib(UINib(nibName: "WeekHoursTableViewCell", bundle: nil), forCellReuseIdentifier: "weekHoursCell")
    
    timepunchTable.backgroundColor = tableColor
    weekTable.backgroundColor = tableColor
    weekTable.hidden = true
    
    todayNavBox.backgroundColor = lightGreyNavColor
    todayButtonLabel.setTitleColor(darkGreyNavColor, forState: .Normal)
    
    let testDate = DA_Date()
    dayNameLabel.text = testDate.DayOfTheWeek()
    dayNumberLabel.text = testDate.NumberOfTheDay()
    nsDateLabel.textColor = UIColor.whiteColor()
    nsDateLabel.text = "\(DA_Date().date)"
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.translucent = true
    
    timepunchButtonOutlet.layer.cornerRadius = 75
      // Uncomment the following line to preserve selection between presentations
      // self.clearsSelectionOnViewWillAppear = false

      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
  

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timePunches.count
    }

  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      if tableView == timepunchTable {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("timePunchCell") as! TimePunchTableViewCell
        let timePunch = timePunches[indexPath.row]
//        let timePunchLabel = cell.contentView.viewWithTag(1) as! UILabel
//        let statusLabel = cell.contentView.viewWithTag(2) as! UILabel
        if timePunch.status {
          cell.statusLabel.text = "IN"
        } else {
          cell.statusLabel.text = "OUT"
        }
//        timePunchLabel.text = timePunch.punchTime
        cell.timePunchLabel.text = timePunch.punchTime

        return cell
      } else if tableView == weekTable {
        let cell = tableView.dequeueReusableCellWithIdentifier("weekHoursCell") as! WeekHoursTableViewCell
      
          cell.weekHoursLabel.text = "Week oot"
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
