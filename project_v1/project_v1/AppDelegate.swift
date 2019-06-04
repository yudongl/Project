//
//  AppDelegate.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/4/17.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted{
                print("User gave permission to loacal notifications.")
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.badge,.sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        if response.notification.request.content.categoryIdentifier == "nbackNextDay"{
            
            print("nback next day reminder")
            
        }else if response.notification.request.content.categoryIdentifier == "testFinished" {
            self.defaults.set(false, forKey: "NBackFinished")
            self.defaults.set(false, forKey: "DDTFinished")
            self.defaults.set(false, forKey: "SSTFinished")
            
            print("monthly reminder")
            
            self.dailyReminder()
            
        }else if response.notification.request.content.categoryIdentifier == "dailyReminder" {
            
            self.dailyReminder()
            
        }
        
        completionHandler()
        
    }
    
    
    func dailyReminder(){
        
        if defaults.bool(forKey: "NBackFinished") == false || defaults.bool(forKey: "DDTFinished") == false || defaults.bool(forKey: "SSTFinished") == false {
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            
            content.title = "Reminder"
            content.body = "Have you done all the three test this month?"
            content.sound = .default
            //content.userInfo = ["value" : "Data with local notification."]
            content.categoryIdentifier = "dailyReminder"
            
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
    
    
    

}

