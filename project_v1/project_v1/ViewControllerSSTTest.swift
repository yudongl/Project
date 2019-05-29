//
//  ViewControllerSSTTest.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/4/28.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewControllerSSTTest: UIViewController {
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var buttonX: UIButton!
    
    @IBOutlet weak var buttonO: UIButton!
    
    @IBOutlet weak var textView1: UITextView!
    
    
    var missedNum = 0
    
    var practiceList = [Int]()
    
    let testList = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3]
    
    var stopSignalDelay = 250
    
    var length = 0
    
    var selectedAnswer = -1
    
    var timer : Timer? = nil
    
    var hitTime = 0
    
    var userRespondTime = 0
    
    var experimentBlockNum = 1
    
    var userRespondResult = [[String(), Int()]]
    
    let defaults = UserDefaults.standard
    
    var dataToServer = ["block" : 0, "incorrect" : 0, "missed" : 0, "percentage" : 0, "reactionTime" : 0, "trials" : 0, "username" : "string"] as [String : Any]
    
    var allDataToServer = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stopSignalTask()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func stopSignalTask(){
        
        practiceList = testList.shuffled()
        userRespondResult = []
        
        
        textView1.text = ""
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
    
    
    func nextStimuli(){
        
        
        selectedAnswer = -1
        
        self.image1.image = UIImage(named: "trans")
        textView1.text = ""
        
        Timer.after(1000.ms) {
            
            self.image1.image = UIImage(named: "wait")
            self.textView1.text = ""
            self.label2.text = ""
        }
        
        Timer.after(1250.ms) {
            
            self.hitTime = 0
            
            self.timer = Timer.every(1.ms, {
                self.hitTime = self.hitTime + 1
            })
            
            
            
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
    
    @IBAction func buttonXPressed(_ sender: Any) {
        
        self.timer?.invalidate()
        
        self.userRespondTime = self.hitTime
        
        //print(self.userRespondTime)
        selectedAnswer = 0
        
    }
    
    
    
    @IBAction func buttonOPressed(_ sender: Any) {
        
        self.timer?.invalidate()
        
        self.userRespondTime = self.hitTime
        
        //print(self.userRespondTime)
        selectedAnswer = 1
        
        
    }
    
    
    @IBAction func button2Pressed(_ sender: Any) {
        
        
        self.stopSignalTask()
        
    }
    
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
        
        successStopRate = Double(successStopNum)/Double(5)
        
        if hitNum != 0{
            avgReactionTime = Double(hitReactionTime)/Double(hitNum)
        }else{
            avgReactionTime = 0.0
        }
        
        textView1.text = "Results of Practice Block \n - Number of incorrect responses to go stimuli: \(incorrectNum) \n - Number of missed responses to go stimuli: \(missedNum) \n - Average reaction time to go stimuli: \(String(format: "%.2f", avgReactionTime)) \n - Percentage of correctly suppressed responses on stop trials: \(String(format: "%.2f", successStopRate))"
        
        dataToServer = ["block" : experimentBlockNum, "incorrect" : incorrectNum, "missed" : missedNum, "percentage" : successStopRate, "reactionTime" : avgReactionTime, "trials" : 20, "username" : defaults.dictionary(forKey: "currentUserInfo")?["username"] as Any] as [String : Any]
        
    }
    
    
    
    func goToNextTrail(){
        
        self.timer?.invalidate()
        
        self.userRespondResult.append([self.checkAnswer(), self.userRespondTime])
        
        if self.length < 19{
            
            if self.checkAnswer() == "miss" {
                
                self.missedNum = self.missedNum + 1
                
                //print(self.missedNum)
                //print(self.checkAnswer())
                
                if self.missedNum >= 3 {
                    
                    image1.image = UIImage(named: "trans")
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
            
            self.image1.image = UIImage(named: "trans")
            self.getFeedBack()
            
            //print(self.dataToServer)
            
            self.allDataToServer.append(self.dataToServer)
            
            //send data to server
//            Alamofire.request("http://45.113.232.152:8080/sst/save", method: .post, parameters: dataToServer, encoding: JSONEncoding.default).responseJSON { (response) in
//                if response.result.isSuccess{
//                    //print("Success")
//                    //let resultJSON : JSON = JSON(response.result.value!)
//                    //print(resultJSON)
//                }
//                else{
//                    print("Error \(String(describing: response.result.error))")
//                }
//            }
            
            
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
                
                //print(self.userRespondResult)
                
                print("You have finish the test")
                
            }else{
                self.experimentBlockNum = self.experimentBlockNum + 1
                
                //self.textView1.text = ""
                self.label2.text = "Go to next experiment block"
                self.button2.setTitle("Continue", for: .normal)
                self.button2.isEnabled = true
                
                //print(self.userRespondResult)
                
                print("Go to next block")
                
                
            }
        }
        
    }
    
    
}
