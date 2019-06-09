//
//  ViewControllerNBackPractice.swift
//  project_v1
//  This file is for the n-back practice block
//  Created by Yudong Liu on 2019/4/28.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit

class ViewControllerNBackPractice: UIViewController {
    
    //show n-back letters
    @IBOutlet weak var image1: UIImageView!
    
    //show correct rate
    @IBOutlet weak var label1: UILabel!
    
    //remind the user to go next block
    @IBOutlet weak var label2: UILabel!
    
    //record user selected n-back answer
    @IBOutlet weak var button1: UIButton!
    
    //go to 2-back practice
    @IBOutlet weak var button2: UIButton!
    
    //go to experiment block
    @IBOutlet weak var button3: UIButton!
    
    //repeat 1-back practice
    @IBOutlet weak var repeatOneBack: UIButton!
    
    //repeat 2-back practice
    @IBOutlet weak var repeatTwoBack: UIButton!
    
    //record the current 1-back practice position
    var length1 = 0
    
    //record 1-back practice user selected answer
    var answer1 = [Int]()
    
    //record the current 2-back practice position
    var length2 = 0
    
    //record 2-back practice user selected answer
    var answer2 = [Int]()
    
    //1-back list
    var list1 = [String]()
    
    //2-back list
    var list2 = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start 1-back practice when enter this view controller
        oneBackPractice()
        
    }
    
    //do the 1-back practice
    func oneBackPractice(){
        
        list1 = genarateOneBackPracticeList()
        length1 = 0
        answer1 = []
        
        button2.setTitle("", for: .normal)
        button2.isEnabled = false
        button3.setTitle("", for: .normal)
        button3.isEnabled = false
        
        repeatOneBack.setTitle("", for: .normal)
        repeatOneBack.isEnabled = false
        repeatTwoBack.setTitle("", for: .normal)
        repeatTwoBack.isEnabled = false
        
        label1.text = "1-Back Practice Block"
        label2.text = ""
        image1.image = UIImage(named: "trans")
        button1.isEnabled = false
        self.button1.backgroundColor = UIColor.black
        
        Timer.after(750.ms) {
            
            self.nextOneBackTrail()
            
        }
        
    }
    
    //do the 2-back practice
    func twoBackPractice(){
        
        length2 = 0
        answer2 = []
        
        list2 = genarateTwoBackPracticeList()
        
        button2.setTitle("", for: .normal)
        button2.isEnabled = false
        button3.setTitle("", for: .normal)
        button3.isEnabled = false
        repeatOneBack.setTitle("", for: .normal)
        repeatOneBack.isEnabled = false
        repeatTwoBack.setTitle("", for: .normal)
        repeatTwoBack.isEnabled = false
        
        label1.text = "2-Back Practice Block"
        label2.text = ""
        image1.image = UIImage(named: "trans")
        button1.isEnabled = false
        button1.setTitle("", for: .normal)
        self.button1.backgroundColor = UIColor.black
        
        Timer.after(750.ms) {
            
            self.nextTwoBackTrail()
            
        }
        
    }
    
    //determine the next 1-back letter
    func nextOneBackTrail(){
        
        label1.text = ""
        label2.text = "(get ready)"
        image1.image = UIImage(named: "wait")
        button1.isEnabled = false
        self.button1.backgroundColor = UIColor.black
        
        Timer.after(500.ms) {
            self.button1.isEnabled = true
            self.button1.backgroundColor = UIColor.yellow
            self.label2.text = ""
            self.image1.image = UIImage(named: self.list1[self.length1])
        }
        
        Timer.after(1000.ms) {
            self.label1.text = ""
            self.image1.image = UIImage(named: "trans")
        }
        
        Timer.after(3500.ms) {
            
            self.length1 = self.length1 + 1
            
            if self.length1 <= 9{
                
                self.nextOneBackTrail()
            }
            else {
                //present feedback and go next practice
                self.button1.setTitle("", for: .normal)
                self.button1.isEnabled = false
                self.button1.backgroundColor = UIColor.black
                
                print(self.answer1)
                
                let correctRate = self.calculateCorrectRate(n:1)
                
                self.label1.text = "Your correct rate is: \(correctRate)%"
                
                print(Set(self.answer1))
                
                self.label2.text = "Continue to the 2-back practice"
                
                self.repeatOneBack.setTitle("Repeat 1-Back Practice", for: .normal)
                self.repeatOneBack.isEnabled = true
                
                self.button2.setTitle("Continue", for: .normal)
                self.button2.isEnabled = true
                
            }
        }

    }
    
    //determine the next 2-back letter
    func nextTwoBackTrail(){
        
        label1.text = ""
        label2.text = "(get ready)"
        image1.image = UIImage(named: "wait")
        button1.isEnabled = false
        self.button1.backgroundColor = UIColor.black
        
        Timer.after(500.ms) {
            self.button1.isEnabled = true
            self.button1.backgroundColor = UIColor.yellow
            self.label2.text = ""
            self.image1.image = UIImage(named: self.list2[self.length2])
        }
        
        Timer.after(1000.ms) {
            self.label1.text = ""
            self.image1.image = UIImage(named: "trans")
        }
        
        Timer.after(3500.ms) {
            
            self.length2 = self.length2 + 1
            
            if self.length2 <= 9{
                
                self.nextTwoBackTrail()
            }
            else {
                //present feedback and go next practice
                //self.length = 0
                self.button1.setTitle("", for: .normal)
                self.button1.isEnabled = false
                self.button1.backgroundColor = UIColor.black
                
                print(self.answer2)
                
                let correctRate = self.calculateCorrectRate(n:2)
                
                self.label1.text = "Your correct rate is: \(correctRate)%"
                
                print(Set(self.answer2))
                
                self.label2.text = "Continue to the real test"
                
                self.repeatTwoBack.setTitle("Repeat 2-Back Practice", for: .normal)
                self.repeatTwoBack.isEnabled = true
                
                self.button3.setTitle("Continue", for: .normal)
                self.button3.isEnabled = true
            }
        }
        
    }
    
    
    //record the user selected answer
    @IBAction func button1Pressed(_ sender: Any) {
        
        if self.length1 <= 9{
            answer1.append(self.length1)
        }
        else if self.length1 > 9{
            answer2.append(self.length2)
        }
        
        
    }
    
    
    //go to 2-back practice
    @IBAction func button2Pressed(_ sender: Any) {
        
        self.twoBackPractice()
    
    }
    
    
    //repeat the 1-back practice
    @IBAction func repeatOneBackPressed(_ sender: Any) {
        self.oneBackPractice()
    }
    
    //repeat the 2-bak practice
    @IBAction func repeatTwoBackPressed(_ sender: Any) {
        self.twoBackPractice()
    }
    
    
    //calculate the correct rate with parameter n, means n-back
    func calculateCorrectRate(n:Int) -> String {
        
        let targetList = findTargetIndex(n: n)
        
        var correctNum = 0
        
        var correctRate = 0.0
        
        var incorrectNum = 0
        
        var score = 0
        
        if n == 1{
            
            for index1 in Set(answer1){
                for index2 in targetList{
                    if index1 == index2{
                        correctNum = correctNum + 1
                    }
                }
            }
            
            incorrectNum = Set(answer1).count - correctNum
            
            score = correctNum - incorrectNum
            
            if score >= 0{
                correctRate = Double(score)/3.0*100
            }else{
                correctRate = 0.0
            }
            
        }
        else if n == 2{
            
            for index1 in Set(answer2){
                for index2 in targetList{
                    if index1 == index2{
                        correctNum = correctNum + 1
                    }
                }
            }
            
            incorrectNum = Set(answer2).count - correctNum
            
            score = correctNum - incorrectNum
            
            if score >= 0{
                correctRate = Double(score)/3.0 * 100
            }else{
                correctRate = 0.0
            }
            
        }
        
        //correctRate = Double(correctNum)/3.0
        
        return String(format:"%.2f", correctRate)
    }
    
    
    //find the target indexes
    func findTargetIndex(n:Int) -> [Int]{
        
        var index = n
        var targetList = [Int]()
        
        if n == 1 {
        
            while index <= 9{
                
                if list1[index] == list1[index-1]{
                    targetList.append(index)
                }
                
                index = index + 1
            }
        
        }
        else if n == 2 {
            
            while index <= 9{
                
                if list2[index] == list2[index-2]{
                    targetList.append(index)
                }
                
                index = index + 1
            }

        }
        else {
            print("n may be out of stack")
        }
        
        return targetList
    }
    
    
    //1-back list
    public func genarateOneBackPracticeList() -> [String] {
        
        return ["W", "W", "V", "V", "W", "K", "K", "V", "W", "Q"]
        
    }
    
    
    //2-back list
    public func genarateTwoBackPracticeList() -> [String] {
        
        return ["W", "V", "W", "V", "Q", "K", "P", "K", "C", "W"]
    }
    
    
    
}
