//
//  NBackReminderVC.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/5/30.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import UserNotifications

class NBackReminderVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func setNBackReminder(_ sender: Any) {
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        
        content.title = "Reminder"
        content.body = "This is a reminder for you to do the N-Back test"
        content.sound = .default
        //content.userInfo = ["value" : "Data with local notification."]
        content.categoryIdentifier = "nbackNextDay"
        
        let fireData = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(86400))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireData, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil{
                print("Error local notification.")
            }
        }
        
    }
    
    
    

}
