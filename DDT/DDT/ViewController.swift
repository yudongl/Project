//
//  ViewController.swift
//  DDT
//
//  Created by Yudong Liu on 2019/3/25.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    

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
                        ["questionNum": 27, "option1": "$20 today", "option2": "$55 in 7 days"],
                        ]
    
    var pickedAnswer = 1
    
    var answerList:[[Int]] = []
    
    let questionIndex = Array(0...26).shuffled()
    
    var questionNum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nextQuestion()
        
    }

    
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
            
            print(answerList)
            
            let alert = UIAlertController(title: "Awesome", message: "You have finished all the questions!", preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in
                self.startOver()
            })
            
            alert.addAction(restartAction)
            
            present(alert, animated: true, completion: nil)
        }
        
        
        
        nextQuestion()
        
    }
    
    func nextQuestion(){
        
        if questionNum <= 26 {
            button1.setTitle(questionList[questionIndex[questionNum]]["option1"] as? String, for: .normal)
            button2.setTitle((questionList[questionIndex[questionNum]]["option2"] as! String), for: .normal)
        }
        else {
            
            let alert = UIAlertController(title: "Awesome", message: "You have finished all the questions!", preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in
                self.startOver()
            })
            
            alert.addAction(restartAction)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func startOver() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

