//
//  TableViewCell_1.swift
//  CoredataTodoApp
//
//  Created by Janarthan Subburaj on 07/09/20.
//  Copyright © 2020 Janarthan Subburaj. All rights reserved.
//

import UIKit

class TableViewCell_1: UITableViewCell {

    
    @IBOutlet weak var imageViewcat: UIImageView!
    
    @IBOutlet weak var CellTaskName: UITextField!
    
    @IBOutlet weak var CellCurrDate: UITextField!
    
    @IBOutlet var circleimg: UIImageView!
  
    
    @IBOutlet var setReminder: UIButton!
    
    
    @IBAction func ReminderAction(_ sender: Any) {

        
        var dateComponents = DateComponents()
        dateComponents.hour = 14
        dateComponents.minute = 55
     
        setReminder.tintColor = UIColor.systemYellow
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Pls check the task alloted for the day"
        content.sound = .default
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }

        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // imageViewcat.layer.cornerRadius = 33
        CellTaskName.borderStyle = .none
        CellCurrDate.borderStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
