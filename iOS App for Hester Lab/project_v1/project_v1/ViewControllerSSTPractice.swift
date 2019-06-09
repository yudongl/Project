//
//  ViewControllerSSTPractice.swift
//  project_v1
//  This file deals with the SST practice block functions
//  Created by Yudong Liu on 2019/4/28.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit

class ViewControllerSSTPractice: UIViewController {
    
    //give user instruction below each trail
    @IBOutlet weak var label2: UILabel!
    
    //show SST trails
    @IBOutlet weak var image1: UIImageView!
    
    //continue to the experiment block
    @IBOutlet weak var button1: UIButton!
    
    //button X
    @IBOutlet weak var buttonX: UIButton!
    
    //button O
    @IBOutlet weak var buttonO: UIButton!

    //show each trail's feedback and overall feedback for the practice block
    @IBOutlet weak var textView1: UITextView!
    
    //10 trails for practice block
    let practiceList = [0, 0, 0, 0, 1, 1, 1, 1, 2, 3].shuffled()
    
    //record the stop signal delay
    var stopSignalDelay = 250
    
    //record the current position of the practice block
    var length = 0
    
    //record user selected answer, 0 means X, 1 means O
    var selectedAnswer = -1
    
    //a timer to record user reaction time for each trail
    var timer : Timer? = nil
    
    //record user reaction time
    var hitTime = 0
    
    var userRespondTime = 0
    
    //record missed trails number
    var missedNum = 0
    
    var userRespondResult = [["", 0]]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start stop signal practice block
        stopSignalTask()
    }
    
    
    //begining of the SST
    func stopSignalTask(){
        
        userRespondResult = []
        missedNum = 0
        
        //set UI elements
        textView1.textAlignment = .center
        textView1.textColor = UIColor.white
        textView1.text = "Practice Block"
        label2.text = ""
        image1.image = UIImage(named: "trans")
        button1.setTitle("", for: .normal)
        button1.isEnabled = false
        buttonX.isEnabled = false
        buttonO.isEnabled = false
        
        Timer.after(750.ms) {
            self.nextStimuli()
        }
        
        
    }
    
    
    
    //time control and process for the next trail
    func nextStimuli(){
        
        selectedAnswer = -1
        textView1.textAlignment = .center
        textView1.textColor = UIColor.white
        textView1.text = "(wait)"
        
        Timer.after(1000.ms) {
            
            self.image1.image = UIImage(named: "wait")
            self.textView1.text = ""
            self.label2.text = "(get ready)"
        }
        
        Timer.after(1250.ms) {
            
            self.hitTime = 0
            
            self.timer = Timer.every(1.ms, {
                self.hitTime = self.hitTime + 1
            })
            
            
            if self.practiceList[self.length] == 0{
                
                self.image1.image = UIImage(named: "SSTX")
                self.label2.text = "(Press X as fast as possible)"
                self.buttonX.isEnabled = true
                self.buttonO.isEnabled = true
                
                Timer.after(1000.ms, {
                    
                    //present feedback for each trail
                    
                    self.timer?.invalidate()
                    
                    self.image1.image = UIImage(named: "trans")
                    
                    self.getEveryTrailFeedback()
                    
                    self.userRespondResult.append([self.checkAnswer(), self.userRespondTime])
                    
                    self.label2.text = ""
                    self.buttonX.isEnabled = false
                    self.buttonO.isEnabled = false
                    
                    Timer.after(2000.ms, {
                        
                        if self.length < 9{
                            self.length = self.length + 1
                            self.nextStimuli()
                        }else{
                            
                            //present the overall feedback for the practice block
                            
                            self.getFeedBack()
                            self.label2.text = "You have finish the practice!"
                            self.buttonO.isEnabled = false
                            self.buttonX.isEnabled = false
                            
                            
                            self.button1.setTitle("Continue to the real test", for: .normal)
                            self.button1.isEnabled = true
                            
                            //print(self.userRespondResult)
                            
                        }
                        
                    })
                })
                
                
                
            } else if self.practiceList[self.length] == 1{
                
                self.image1.image = UIImage(named: "SSTO")
                self.label2.text = "(Press O as fast as possible)"
                self.buttonX.isEnabled = true
                self.buttonO.isEnabled = true
                
                Timer.after(1000.ms, {
                    //present feedback
                    
                    self.timer?.invalidate()
                    
                    self.image1.image = UIImage(named: "trans")
                    //self.label1.text = self.checkAnswer()
                    self.getEveryTrailFeedback()
                    
                    self.userRespondResult.append([self.checkAnswer(), self.userRespondTime])
                    
                    //print(self.checkAnswer())
                    self.label2.text = ""
                    self.buttonX.isEnabled = false
                    self.buttonO.isEnabled = false
                    
                    Timer.after(2000.ms, {
                        
                        if self.length < 9{
                            self.length = self.length + 1
                            self.nextStimuli()
                        }else{
                            
                            self.getFeedBack()
                            //self.textView1.text = ""
                            self.label2.text = "You have finish the practice!"
                            self.buttonO.isEnabled = false
                            self.buttonX.isEnabled = false
                            
                            self.button1.setTitle("Continue to the real test", for: .normal)
                            self.button1.isEnabled = true
                            
                            //print("You have finish the test")
                            print(self.userRespondResult)
                        }
                        
                    })
                })
                
            } else if self.practiceList[self.length] == 2{
                
                self.image1.image = UIImage(named: "SSTX")
                self.label2.text = "(Do not press any key)"
                self.buttonX.isEnabled = true
                self.buttonO.isEnabled = true
                
                Timer.after(Double(self.stopSignalDelay).ms, {
                    
                    self.image1.image = UIImage(named: "stopX")
                    
                    Timer.after(1000.ms, {
                        //present feedback
                        
                        self.timer?.invalidate()
                        
                        self.image1.image = UIImage(named: "trans")
                        //self.label1.text = self.checkAnswer()
                        self.getEveryTrailFeedback()
                        
                        self.userRespondResult.append([self.checkAnswer(), self.userRespondTime])
                        
                        //print(self.checkAnswer())
                        self.label2.text = ""
                        self.buttonX.isEnabled = false
                        self.buttonO.isEnabled = false
                        
                        Timer.after(2000.ms, {
                            
                            if self.length < 9{
                                self.length = self.length + 1
                                self.nextStimuli()
                            }else{
                                
                                self.getFeedBack()
                                //self.textView1.text = ""
                                self.label2.text = "You have finish the practice!"
                                self.buttonO.isEnabled = false
                                self.buttonX.isEnabled = false
                                
                                self.button1.setTitle("Continue to the real test", for: .normal)
                                self.button1.isEnabled = true
                                
                                //print("You have finish the test")
                                print(self.userRespondResult)
                            }
                            
                        })
                    })
                    
                })
                
                
            } else if self.practiceList[self.length] == 3{
                
                self.image1.image = UIImage(named: "SSTO")
                self.label2.text = "(Do not press any key)"
                self.buttonX.isEnabled = true
                self.buttonO.isEnabled = true
                
                
                
                Timer.after(Double(self.stopSignalDelay).ms, {
                    
                    self.image1.image = UIImage(named: "stopO")
                    
                    Timer.after(1000.ms, {
                        //present feedback
                        
                        self.timer?.invalidate()
                        
                        self.image1.image = UIImage(named: "trans")
                        //self.label1.text = self.checkAnswer()
                        self.getEveryTrailFeedback()
                        
                        self.userRespondResult.append([self.checkAnswer(), self.userRespondTime])
                        
                        //print(self.checkAnswer())
                        self.label2.text = ""
                        self.buttonX.isEnabled = false
                        self.buttonO.isEnabled = false
                        
                        Timer.after(2000.ms, {
                            
                            if self.length < 9{
                                self.length = self.length + 1
                                self.nextStimuli()
                            }else{
                                
                                self.getFeedBack()
                                //self.textView1.text = ""
                                self.label2.text = "You have finish the practice!"
                                self.buttonO.isEnabled = false
                                self.buttonX.isEnabled = false
                                
                                self.button1.setTitle("Continue to the real test", for: .normal)
                                self.button1.isEnabled = true
                                
                                //print("You have finish the test")
                                print(self.userRespondResult)
                            }
                            
                        })
                    })
                })
            }
        
        }
        
    }
    
    //button X pressed function
    @IBAction func buttonXPressed(_ sender: Any) {
        
        self.timer?.invalidate()
        
        self.userRespondTime = self.hitTime
        
        selectedAnswer = 0
    }
    
    
    //button O pressed function
    @IBAction func buttonOPressed(_ sender: Any) {
        
        self.timer?.invalidate()
        
        self.userRespondTime = self.hitTime
        
        selectedAnswer = 1
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
                
                //change the stop signal delay time
                
                value =  "successful stop"
                
                if stopSignalDelay <= 900{
                    stopSignalDelay = stopSignalDelay + 50
                }
                
            }else{
                
                //change the stop signal delay time
                
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
    
    
    
    //get the feedback for each trail
    func getEveryTrailFeedback(){
        
        if self.checkAnswer() == "miss" {
            
            self.missedNum = self.missedNum + 1
            
            if self.missedNum >= 3 {
                
                self.textView1.textColor = UIColor.red
                self.textView1.text = "You MUST respond to X/O go stimuli as fast as possible"
                
            }else{
                
                self.textView1.textColor = UIColor.red
                self.textView1.text = "Miss (you must go faster)"
            }
            
        }else if self.checkAnswer() == "hit" {
            
            self.missedNum = 0
            
            if self.userRespondTime > 500 {
                
                self.textView1.textColor = UIColor.yellow
                self.textView1.text = "Hit (but try to go faster)"
                
            }else {
                
                self.textView1.textColor = UIColor.green
                self.textView1.text = "Hit"
            }
            
        }else if self.checkAnswer() == "incorrect" {
            
            self.missedNum = 0
            self.textView1.textColor = UIColor.red
            self.textView1.text = "Miss (incorrect button)"
            
        }else if self.checkAnswer() == "successful stop" {
            
            self.missedNum = 0
            self.textView1.textColor = UIColor.green
            self.textView1.text = "Successful stop - Well done!"
            
        }else if self.checkAnswer() == "unsuccessful stop" {
            
            self.missedNum = 0
            self.textView1.textColor = UIColor.red
            self.textView1.text = "Unsuccessful stop \n – You should not have pressed any button"
            
        }else{
            
            self.missedNum = 0
            self.textView1.textColor = UIColor.red
            self.textView1.text = "There may have some problems"
            
        }
        
        
    }
    
    
    //calculate the overall feedback for the practice block and show in the window
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
        
        while i <= 10 {
            
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
        
        successStopRate = Double(successStopNum)/Double(2)
        
        avgReactionTime = Double(hitReactionTime)/Double(hitNum)
        
        textView1.textAlignment = .left
        textView1.textColor = UIColor.white
        textView1.text = "Results of Practice Block \n - Number of incorrect responses to go stimuli: \(incorrectNum) \n - Number of missed responses to go stimuli: \(missedNum) \n - Average reaction time to go stimuli: \(String(format: "%.2f", avgReactionTime)) \n - Percentage of correctly suppressed responses on stop trials: \(String(format: "%.2f", successStopRate))"
        
    }
    
}
