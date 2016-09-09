//
//  TimePunchTableViewCell.swift
//  tractwork
//
//  Created by manatee on 8/29/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit

class TimePunchTableViewCell: UITableViewCell {

  @IBOutlet weak var timePunchLabel: UILabel!
  
  @IBOutlet weak var statusLabel: UILabel!
  
  @IBOutlet weak var statusColorImage: UIImageView!
  
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
  override func drawRect(rect: CGRect) {
    let path = UIBezierPath()
    
    path.moveToPoint(CGPoint(x: 122, y: 0))
    path.addLineToPoint(CGPoint(x: 122, y: 44))
    path.lineWidth = 2.0
    path.closePath()
    UIColor.grayColor().set()
    path.stroke()
    path.fill()
  }
    
}
