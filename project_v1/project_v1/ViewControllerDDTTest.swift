//
//  ViewControllerDDTTest.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/4/17.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UserNotifications


class ViewControllerDDTTest: UIViewController {

    
    @IBOutlet weak var ButtonAnswer1: UIButton!
    
    @IBOutlet weak var ButtonAnswer2: UIButton!
    
    
    let questionList = [["questionNum": 1, "option1": "$54 today", "option2": "$55 in 117 days"],
                        ["questionNum": 2, "option1": "$55 today", "option2": "$75 in 61 days"],
                        ["questionNum": 3, "option1": "$19 today", "option2": "$25 in 53 days"],
                        ["questionNum": 4, "option1": "$31 today", "option2": "$85 in 7 days"],
                        ["questionNum": 5, "option1": "$14 today", "option2": "$25 in 19 days"],
                        ["questionNum": 6, "option1": "$47 today", "option2": "$50 in 160 days"],
                        ["questionNum": 7, "option1": "$15 today", "option2": "$35 in 13 days"],
                        ["questionNum": 8, "option1": "$25 today", "option2": "$60 in 14 days"],
                        ["questionNum": 9, "option1": "$78 today", "option2": "$80 in 162 days"],
                        ["questionNum": 10, "option1": "$40 today", "option2": "$55 in 62 days"],
                        ["questionNum": 11, "option1": "$11 today", "option2": "$30 in 7 days"],
                        ["questionNum": 12, "option1": "$67 today", "option2": "$75 in 119 days"],
                        ["questionNum": 13, "option1": "$34 today", "option2": "$35 in 186 days"],
                        ["questionNum": 14, "option1": "$27 today", "option2": "$50 in 21 days"],
                        ["questionNum": 15, "option1": "$69 today", "option2": "$85 in 91 days"],
                        ["questionNum": 16, "option1": "$49 today", "option2": "$60 in 89 days"],
                        ["questionNum": 17, "option1": "$80 today", "option2": "$85 in 157 days"],
                        ["questionNum": 18, "option1": "$24 today", "option2": "$35 in 29 days"],
                        ["questionNum": 19, "option1": "$33 today", "option2": "$80 in 14 days"],
                        ["questionNum": 20, "option1": "$28 today", "option2": "$30 in 179 days"],
                        ["questionNum": 21, "option1": "$34 today", "option2": "$50 in 30 days"],
                        ["questionNum": 22, "option1": "$25 today", "option2": "$30 in 80 days"],
                        ["questionNum": 23, "option1": "$41 today", "option2": "$75 in 20 days"],
                        ["questionNum": 24, "option1": "$54 today", "option2": "$60 in 111 days"],
                        ["questionNum": 25, "option1": "$54 today", "option2": "$80 in 30 days"],
                        ["questionNum": 26, "option1": "$22 today", "option2": "$25 in 136 days"],
                        ["questionNum": 27, "option1": "$20 today", "option2": "$55 in 7 days"],]
    
    
    var pickedAnswer = 1
    
    
    var answerList:[[Int]] = []
    
    
    let questionIndex = Array(0...26).shuffled()
    
    
    var questionNum = 0
    
    
    var dataToServer = ["answers": [[0,0]], "username": "string"] as [String : Any]
    
    
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nextQuestion()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        if sender.tag == 1 {
            pickedAnswer = 1
            answerList.append([questionIndex[questionNum], pickedAnswer])
        }
        else if sender.tag == 2 {
            pickedAnswer = 2
            answerList.append([questionIndex[questionNum], pickedAnswer])
        }
        
        questionNum = questionNum + 1
        
        if questionNum == 27 {
            
            dataToServer = ["answers": answerList, "username": defaults.dictionary(forKey: "currentUserInfo")?["username"] as Any] as [String : Any]
            
            print(dataToServer)
            
            //send data to server
            Alamofire.request("http://45.113.232.152:8080/ddt/save", method: .post, parameters: dataToServer, encoding: JSONEncoding.default).responseJSON { (response) in
                if response.result.isSuccess{
                    
                    print("Success")
                    let resultJSON : JSON = JSON(response.result.value!)
                    
                    print(resultJSON)
                    
                }
                else{
                    
                    print("Error \(String(describing: response.result.error))")
                }
                
            }
            
            self.defaults.set(true, forKey: "DDTFinished")
            
            self.pushNotification()
            
            
            self.finishedRemind()
            
        }
        
        nextQuestion()
        
    }
    
    
    func pushNotification(){
        
        if defaults.bool(forKey: "NBackFinished") == true && defaults.bool(forKey: "DDTFinished") == true && defaults.bool(forKey: "SSTFinished") == true {
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            
            content.title = "Reminder"
            content.body = "This is a reminder for you to do the N-Back test"
            content.sound = .default
            content.categoryIdentifier = "testFinished"
            //content.userInfo = ["value" : "Data with local notification."]
            
            let fireData = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(30.days))
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: fireData, repeats: false)
            
            let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
            
            center.add(request) { (error) in
                if error != nil{
                    print("Error local notification.")
                }
            }
            
            print("local notification success")
            
            
        } else {
            print("local notification not set")
        }
        
    }
    
    
    
    
    
    
    
    
    func nextQuestion(){
        
        if questionNum <= 26 {
            
            ButtonAnswer1.setTitle(questionList[questionIndex[questionNum]]["option1"] as? String, for: .normal)
            ButtonAnswer2.setTitle(questionList[questionIndex[questionNum]]["option2"] as? String, for: .normal)
        }
        else {
            
            //self.finishedRemind()
        }
        
    }
    
    
    func startOver() {
        
        self.performSegue(withIdentifier: "backToDDTMain", sender: self)
        
    }
    
    
    func finishedRemind(){
        
        let alert = UIAlertController(title: "Awesome", message: "You have finished all the questions!", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in
            
            self.startOver()
        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}
