//
//  ViewController.swift
//  SST
//
//  Created by Yudong Liu on 2019/3/26.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var buttonX: UIButton!
    
    @IBOutlet weak var buttonO: UIButton!
    
    let practiceList = [0,0,0,0,0,1,1,1,1,1].shuffled()
    
    var signalNum = 0
    
    var timeCount = 0
    
    var pressTime: [Int] = [0]
    
    var everyTime: [Int] = []
    
    var buttonPressed = false
    
    var timer : Timer? = nil
    
    var timer2 : Timer? = nil
    
    var timeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Timer.every(1.ms) {
            self.timeCount = self.timeCount + 1
        }
        
        self.firstStimuli()
        
    }

    
    func firstStimuli(){
        
        image1.image = UIImage(named: "trans")
        label1.text = ("practice block")
        
        buttonX.isEnabled = false
        buttonO.isEnabled = false
        
        Timer.after(750.ms) {
            self.waitPage()
        }
        
        Timer.after(1750.ms) {
            self.getReadyPage()
        }
        
        Timer.after(2000.ms) {
            self.goStimuliPage()
        }
        
        timer = Timer.after(3000.ms, {
            
            print("missed")
            
            self.pressTime.append(self.timeCount)
            
            if self.signalNum == 0{
                self.everyTime.append(self.timeCount - self.pressTime[self.signalNum] - 1250 - 750)
                //print(self.everyTime[self.signalNum])
                //print(timeCount)
            }
            else{
                self.everyTime.append(self.timeCount - self.pressTime[self.signalNum] - 1250)
                //print(self.everyTime[self.signalNum])
                //print(timeCount)
            }
            
            self.label1.text = ("result")
            self.image1.image = UIImage(named: "trans")
            
            self.buttonX.isEnabled = false
            self.buttonO.isEnabled = false
            
            self.timer2 = Timer.after(2000.ms, {
                
                self.signalNum = self.signalNum + 1
                
                if self.signalNum < 10 {
                    
                    self.nextStimuli()
                }
                else {
                    print("You have finished the practice!")
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        })
        
    }
    

    func nextStimuli(){


        waitPage()
        
        Timer.after(1000.ms) {
            self.getReadyPage()
        }
        
        Timer.after(1250.ms) {
            self.goStimuliPage()
        }
        
        timer = Timer.after(2250.ms, {
            
            print("missed")
            
            self.pressTime.append(self.timeCount)
            
            if self.signalNum == 0{
                self.everyTime.append(self.timeCount - self.pressTime[self.signalNum] - 1250 - 750)
                //print(self.everyTime[self.signalNum])
                //print(timeCount)
            }
            else{
                self.everyTime.append(self.timeCount - self.pressTime[self.signalNum] - 1250)
                //print(self.everyTime[self.signalNum])
                //print(timeCount)
            }
            
            self.label1.text = ("result")
            self.image1.image = UIImage(named: "trans")
            
            self.buttonX.isEnabled = false
            self.buttonO.isEnabled = false
            
            self.timer2 = Timer.after(2000.ms, {
                
                self.signalNum = self.signalNum + 1
                
                if self.signalNum < 10 {
                    
                    self.nextStimuli()
                }
                else {
                    print("You have finished the practice!")
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        
        })
        

    }
    

    
    @IBAction func buttonXPressed(_ sender: Any) {
        
        timer?.invalidate()
        timer2?.invalidate()
        
        pressTime.append(timeCount)
        
        if signalNum == 0{
            everyTime.append(timeCount - pressTime[signalNum] - 1250 - 750)
            print(everyTime[signalNum])
            //print(timeCount)
        }
        else{
            everyTime.append(timeCount - pressTime[signalNum] - 1250 - 2000)
            print(everyTime[signalNum])
            //print(timeCount)
        }
        
        self.label1.text = ("result")
        image1.image = UIImage(named: "trans")
        
        self.buttonX.isEnabled = false
        self.buttonO.isEnabled = false
        
        Timer.after(2000.ms) {
            
            self.signalNum = self.signalNum + 1
            
            if self.signalNum < 10 {
                
                self.nextStimuli()
            }
            else {
                print("You have finished the practice!")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    
    
    @IBAction func buttonOPressed(_ sender: Any) {

        timer?.invalidate()
        
        pressTime.append(timeCount)
        
        if signalNum == 0{
            print(timeCount - pressTime[signalNum] - 1250 - 750)
        }
        else{
            print(timeCount - pressTime[signalNum] - 1250)
        }
        
        signalNum = signalNum + 1
        
        if signalNum < 10 {
            
            nextStimuli()
        }
        else {
            print("You have finished the practice!")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    func waitPage(){
        
        image1.image = UIImage(named: "trans")
        label1.text = ("(wait)")
        buttonX.isEnabled = false
        buttonO.isEnabled = false
        
    }
    
    
    func getReadyPage(){
        
        self.image1.image = UIImage(named: "wait")
        label2.text = ("(get ready)")
    }
    
    
    func goStimuliPage(){
        
        self.buttonX.isEnabled = true
        self.buttonO.isEnabled = true
        label1.text = ("")
        label2.text = ("")
        
        if self.practiceList[self.signalNum] == 0{
            self.image1.image = UIImage(named: "X")
        }
        else if self.practiceList[self.signalNum] == 1{
            self.image1.image = UIImage(named: "O")
        }
        
    }
    
    
    func getFeedbackPage(){
        
        
        
    }


    
    
    
    
}

