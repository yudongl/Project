//
//  ViewControllerSSTTest.swift
//  project_v1
//  This file deals with the SST real experiment blocks functions
//  Created by Yudong Liu on 2019/4/28.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UserNotifications


class ViewControllerSSTTest: UIViewController {
    
    //show 'go to next experiment block'
    @IBOutlet weak var label2: UILabel!
    
    //SST trails images
    @IBOutlet weak var image1: UIImageView!
    
    //return to SST main menu
    @IBOutlet weak var button1: UIButton!
    
    //go to next experiment block
    @IBOutlet weak var button2: UIButton!
    
    //button X
    @IBOutlet weak var buttonX: UIButton!
    
    //button O
    @IBOutlet weak var buttonO: UIButton!
    
    //show the overall feedback after each block
    @IBOutlet weak var textView1: UITextView!
    
    
    //record missed number
    var missedNum = 0
    
    //shuffled trails
    var practiceList = [Int]()
    
    //SST trails
    let testList = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3]
    
    //define the stop signal delay
    var stopSignalDelay = 250
    
    //record answerlist length
    var length = 0
    
    //record user selected answer is X or O
    var selectedAnswer = -1
    
    //a timer to record user reaction time for each trail
    var timer : Timer? = nil
    
    //record user reaction time for each trail
    var hitTime = 0
    
    var userRespondTime = 0
    
    //record the experiment block number
    var experimentBlockNum = 1
    
    //save the result and user reaction time for each trail
    var userRespondResult = [[String(), Int()]]
    
    let defaults = UserDefaults.standard
    
    //record results that need to be send to the server
    var dataToServer = ["block" : 0, "incorrect" : 0, "missed" : 0, "percentage" : 0, "reactionTime" : 0, "trials" : 0, "username" : "string"] as [String : Any]
    
    var allDataToServer = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //start the SST test when open this view controller
        stopSignalTask()
        
    }
    

    
    //begining of the SST experiment test
    func stopSignalTask(){
        
        practiceList = testList.shuffled()
        userRespondResult = []
        
        //change UI elements
        textView1.text = ""
        textView1.textColor = UIColor.white
        textView1.textAlignment = .center
        textView1.text = "Experiment Block \(experimentBlockNum)"
        label2.text = ""
        image1.image = UIImage(named: "trans")
        button1.setTitle("", for: .normal)
        button1.isEnabled = false
        button2.setTitle("", for: .normal)
        button2.isEnabled = false
        buttonX.isEnabled = false
        buttonO.isEnabled = false
        
        length = 0
        
        Timer.after(750.ms) {
            self.nextStimuli()
        }
        
        
    }
    
    //control the time and process of a SST trail
    func nextStimuli(){
        
        
        selectedAnswer = -1
        
        self.image1.image = UIImage(named: "trans")
        textView1.text = ""
        
        //show blank page for 1000ms
        Timer.after(1000.ms) {
            
            self.image1.image = UIImage(named: "wait")
            self.textView1.text = ""
            self.label2.text = ""
        }
        
        //show wait signal for 250ms
        Timer.after(1250.ms) {
            
            self.hitTime = 0
            
            self.timer = Timer.every(1.ms, {
                self.hitTime = self.hitTime + 1
            })
            
            
            //four kinds of sst trails, X, O, stopX and stopO
            //0 = X, 1 = O, 2 = stopX, 3 = stopO
            
            if self.practiceList[self.length] == 0{
                
                self.image1.image = UIImage(named: "SSTX")
                self.label2.text = ""
                self.buttonX.isEnabled = true
                self.buttonO.isEnabled = true
                
                Timer.after(1000.ms, {

                    self.goToNextTrail()
                    
                })
                
                
                
            } else if self.practiceList[self.length] == 1{
                
                self.image1.image = UIImage(named: "SSTO")
                self.label2.text = ""
                self.buttonX.isEnabled = true
                self.buttonO.isEnabled = true
                
                Timer.after(1000.ms, {
                    //present feedback
                    self.goToNextTrail()
                   
                })
                
            } else if self.practiceList[self.length] == 2{
                
                self.image1.image = UIImage(named: "SSTX")
                self.label2.text = ""
                self.buttonX.isEnabled = true
                self.buttonO.isEnabled = true
                
                Timer.after(Double(self.stopSignalDelay).ms, {
                    
                    self.image1.image = UIImage(named: "stopX")
                    
                    Timer.after(1000.ms, {
                        //present feedback
                        
                        self.goToNextTrail()
                        
                    })
                    
                })
                
                
            } else if self.practiceList[self.length] == 3{
                
                self.image1.image = UIImage(named: "SSTO")
                self.label2.text = ""
                self.buttonX.isEnabled = true
                self.buttonO.isEnabled = true
                
                
                
                Timer.after(Double(self.stopSignalDelay).ms, {
                    
                    self.image1.image = UIImage(named: "stopO")
                    
                    Timer.after(1000.ms, {
                        //present feedback
                        
                        self.goToNextTrail()
                        
                    })
                })
            }
            
        }
        
    }
    
    //check the answer's status
    func checkAnswer() -> String{
        
        var value = ""
        
        if practiceList[length] == 0 || practiceList[length] == 1{
            
            if practiceList[length] == selectedAnswer{
                
                value = "hit"
                
            }else if practiceList[length] != selectedAnswer{
                
                if selectedAnswer == -1{
                    
                    value = "miss"
                }else{
                    
                    value =  "incorrect"
                }
            }
            
        }else if practiceList[length] == 2 || practiceList[length] == 3{
            
            if selectedAnswer == -1 {
                
                value =  "successful stop"
                
                if stopSignalDelay <= 900{
                    stopSignalDelay = stopSignalDelay + 50
                }
                
                
            }else{
                
                value =  "unsuccessful stop"
                
                if stopSignalDelay >= 50{
                    stopSignalDelay = stopSignalDelay - 50
                }
                
            }
            
        }else{
            value = "none"
        }
        
        return value
        
    }
    
    //record user selected answer when press button X
    @IBAction func buttonXPressed(_ sender: Any) {
        
        self.timer?.invalidate()
        
        self.userRespondTime = self.hitTime
        
        //print(self.userRespondTime)
        selectedAnswer = 0
        
    }
    
    
    //record user selected answer when press button O
    @IBAction func buttonOPressed(_ sender: Any) {
        
        self.timer?.invalidate()
        
        self.userRespondTime = self.hitTime
        
        //print(self.userRespondTime)
        selectedAnswer = 1
        
        
    }
    
    //go to next experiment block
    @IBAction func button2Pressed(_ sender: Any) {
        
        self.missedNum = 0
        self.stopSignalTask()
        
    }
    
    //provide feedback after each block and save the results to the dataToServer dictionary
    func getFeedBack(){
        
        var incorrectNum = 0
        
        var missedNum = 0
        
        var successStopNum = 0
        
        var successStopRate = 0.0
        
        var hitReactionTime = 0
        
        var hitNum = 0
        
        var avgReactionTime = 0.0
        
        var list1 = [String()]
        
        var list2 = [Int()]
        
        for results in userRespondResult{
            
            list1.append(results[0] as! String)
            list2.append(results[1] as! Int)
            
        }
        
        
        var i = 0
        
        while i <= 20 {
            
            if list1[i] == "miss" {
                missedNum = missedNum + 1
            }else if list1[i] == "incorrect"{
                incorrectNum = incorrectNum + 1
            }else if list1[i] == "successful stop"{
                successStopNum = successStopNum + 1
            }else if list1[i] == "hit"{
                hitNum = hitNum + 1
                hitReactionTime = hitReactionTime + list2[i]
            }
            
            i = i + 1
            
        }
        
        successStopRate = Double(successStopNum)/Double(5) * 100
        
        if hitNum != 0{
            avgReactionTime = Double(hitReactionTime)/Double(hitNum)
        }else{
            avgReactionTime = 0.0
        }
        
        //present the overall feedback for an experiment block
        textView1.textColor = UIColor.white
        textView1.textAlignment = .left
        textView1.text = "Result \n - Number of incorrect responses to go stimuli: \(incorrectNum) \n - Number of missed responses to go stimuli: \(missedNum) \n - Average reaction time to go stimuli: \(String(format: "%.2f", avgReactionTime)) \n - Percentage of correctly suppressed responses on stop trials: \(String(format: "%.2f", successStopRate))"
        
        //save the results data
        dataToServer = ["block" : experimentBlockNum, "incorrect" : incorrectNum, "missed" : missedNum, "percentage" : successStopRate, "reactionTime" : avgReactionTime, "trials" : 20, "username" : defaults.dictionary(forKey: "currentUserInfo")?["username"] as Any] as [String : Any]
        
    }
    
    
    //control the process to go to the next trail
    func goToNextTrail(){
        
        self.timer?.invalidate()
        
        self.userRespondResult.append([self.checkAnswer(), self.userRespondTime])
        
        //go to next trail
        if self.length < 19{
            
            if self.checkAnswer() == "miss" {
                
                self.missedNum = self.missedNum + 1
                
                //remind the user to press button X or O
                if self.missedNum >= 3 {
                    
                    image1.image = UIImage(named: "trans")
                    self.textView1.textColor = UIColor.red
                    self.textView1.textAlignment = .center
                    self.textView1.text = "You MUST respond to X/O go stimuli as fast as possible"
                    
                    Timer.after(1000.ms) {
                        self.nextStimuli()
                    }
                    
                }else{
                    
                    self.nextStimuli()
                    
                }
            }else{
                
                self.missedNum = 0
                self.nextStimuli()
                
            }
            
            self.length = self.length + 1
            
        }else{
            
            self.missedNum = 0
            
            self.image1.image = UIImage(named: "trans")
            self.getFeedBack()
            
            self.allDataToServer.append(self.dataToServer)
            
            //test finished
            if self.experimentBlockNum == 4{
                
                //self.textView1.text = ""
                self.label2.text = "You have finish the test"
                self.button1.setTitle("Back to the main menu", for: .normal)
                self.button1.isEnabled = true
                
                
                //send all data to server
                let parameter = ["records": self.allDataToServer]
                
                print(parameter)
                
                Alamofire.request("http://45.113.232.152:8080/sst/saveall", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
                    if response.result.isSuccess{
                        
                        print("Success")
                        let resultJSON : JSON = JSON(response.result.value!)
                        
                        print(resultJSON)
                        
                    }
                    else{
                        
                        print("Error \(String(describing: response.result.error))")
                    }
                    
                }
                
                print("You have finish the test")
                
                
                self.defaults.set(true, forKey: "SSTFinished")
                
                self.pushNotification()
                
                
            }else{
                self.experimentBlockNum = self.experimentBlockNum + 1
                
                //self.textView1.text = ""
                self.label2.text = "Go to next experiment block"
                self.button2.setTitle("Continue", for: .normal)
                self.button2.isEnabled = true
                
                print("Go to next block")
                
                
            }
        }
        
    }
    
    //push local notification to remind the user to do the test after a month
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
    
    
    
    
}
