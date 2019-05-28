//
//  ViewControllerNBackPractice.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/4/28.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit

class ViewControllerNBackPractice: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var repeatOneBack: UIButton!
    
    @IBOutlet weak var repeatTwoBack: UIButton!
    
    
    var length1 = 0
    
    var answer1 = [Int]()
    
    var length2 = 0
    
    var answer2 = [Int]()
    
    var list1 = [String]()
    
    var list2 = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        oneBackPractice()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
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
        
        Timer.after(750.ms) {
            
            self.nextOneBackTrail()
            
        }
        
    }
    
    
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
        button1.setTitle("Button", for: .normal)
        
        Timer.after(750.ms) {
            
            self.nextTwoBackTrail()
            
        }
        
    }
    
    
    func nextOneBackTrail(){
        
        label1.text = ""
        label2.text = "(get ready)"
        image1.image = UIImage(named: "wait")
        button1.isEnabled = false
        
        Timer.after(500.ms) {
            self.button1.isEnabled = true
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
                
                print(self.answer1)
                
                let correctRate = self.calculateCorrectRate(n:1)
                
                self.label1.text = "Your correct rate is: \(correctRate)"
                
                print(Set(self.answer1))
                
                self.label2.text = "Continue to the 2-back practice"
                
                self.repeatOneBack.setTitle("Repeat 1-Back Practice", for: .normal)
                self.repeatOneBack.isEnabled = true
                
                self.button2.setTitle("Continue", for: .normal)
                self.button2.isEnabled = true
                
            }
        }

    }
    
    
    func nextTwoBackTrail(){
        
        label1.text = ""
        label2.text = "(get ready)"
        image1.image = UIImage(named: "wait")
        button1.isEnabled = false
        
        Timer.after(500.ms) {
            self.button1.isEnabled = true
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
                
                print(self.answer2)
                
                let correctRate = self.calculateCorrectRate(n:2)
                
                self.label1.text = "Your correct rate is: \(correctRate)"
                
                print(Set(self.answer2))
                
                self.label2.text = "Continue to the real test"
                
                self.repeatTwoBack.setTitle("Repeat 2-Back Practice", for: .normal)
                self.repeatTwoBack.isEnabled = true
                
                self.button3.setTitle("Continue", for: .normal)
                self.button3.isEnabled = true
            }
        }
        
    }
    
    
    
    @IBAction func button1Pressed(_ sender: Any) {
        
        if self.length1 <= 9{
            answer1.append(self.length1)
        }
        else if self.length1 > 9{
            answer2.append(self.length2)
        }
        
        
    }
    
    
    
    @IBAction func button2Pressed(_ sender: Any) {
        
        self.twoBackPractice()
    
    }
    
    
    
    @IBAction func repeatOneBackPressed(_ sender: Any) {
        self.oneBackPractice()
    }
    
    
    @IBAction func repeatTwoBackPressed(_ sender: Any) {
        self.twoBackPractice()
    }
    
    
    
    func calculateCorrectRate(n:Int) -> String {
        
        let targetList = findTargetIndex(n: n)
        
        var correctNum = 0
        
        var correctRate = 0.0
        
        if n == 1{
            
            for index1 in Set(answer1){
                for index2 in targetList{
                    if index1 == index2{
                        correctNum = correctNum + 1
                    }
                }
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
            
        }
        
        correctRate = Double(correctNum)/3.0
        
        return String(format:"%.2f", correctRate)
    }
    
    
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
    
    
    public func genarateOneBackPracticeList() -> [String] {
        
        return ["W", "W", "V", "V", "W", "K", "K", "V", "W", "Q"]
        
    }
    
    
    public func genarateTwoBackPracticeList() -> [String] {
        
        return ["W", "V", "W", "V", "Q", "K", "P", "K", "C", "W"]
    }
    
    
    
}
