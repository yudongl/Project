//
//  ViewControllerNBackTest.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/4/28.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UserNotifications


class ViewControllerNBackTest: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    var nBackNum = 1
    
    var experimentBlockNum = 1
    
    var length = 0
    
    var correctRate = 0.0
    
    var selectedTrial = [Int]()
    
    var nBackList = [String]()
    
    var dataToServer = ["level": 0, "percentage": 0, "username": "string", "block": 0, "trials": 20, "incorrect": 0, "missed": 0] as [String : Any]
    
    var dataToServerList = [Any]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nBackTest(nBack: 1)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func nBackTest(nBack: Int){
        
        generateNBackList(level: nBack) {
            
            //print(self.nBackList)
            //print(self.experimentBlockNum)
            //print(self.nBackNum)
            
            
            self.selectedTrial = []
            self.length = 0
            self.correctRate = 0
            
            self.button2.setTitle("", for: .normal)
            self.button2.isEnabled = false
            self.button3.setTitle("", for: .normal)
            self.button3.isEnabled = false
            
            self.label1.text = "\(nBack)-Back Test Block"
            self.label2.text = ""
            self.image1.image = UIImage(named: "trans")
            self.button1.setTitle("", for: .normal)
            self.button1.backgroundColor = UIColor.black
            self.button1.isEnabled = false
            
            Timer.after(750.ms) {
                
                self.nextNBackTrail()
                
            }
        }
        
    }
    
    func nextNBackTrail(){
        
        label1.text = ""
        label2.text = "(get ready)"
        image1.image = UIImage(named: "wait")
        self.button1.backgroundColor = UIColor.black
        button1.isEnabled = false
        
        Timer.after(500.ms) {
            self.button1.backgroundColor = UIColor.yellow
            self.button1.isEnabled = true
            self.label2.text = ""
            self.image1.image = UIImage(named: self.nBackList[self.length])
        }
        
        Timer.after(1000.ms) {
            self.label1.text = ""
            self.image1.image = UIImage(named: "trans")
        }
        
        Timer.after(3500.ms) {
            
            self.length = self.length + 1
            
            if self.length <= 19{
                
                self.nextNBackTrail()
            }
            else {
                //present feedback and go next practice
                
                self.button1.setTitle("", for: .normal)
                self.button1.backgroundColor = UIColor.black
                self.button1.isEnabled = false
                
                self.correctRate = self.calculateCorrectRate(n:self.nBackNum)
                
                let correctPercentage = self.correctRate * 100
                let percentage = String(format:"%.2f", correctPercentage)
                
                //Server control whether show result
                Alamofire.request("http://45.113.232.152:8080/setting/get", method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
                    if response.result.isSuccess{
                        
                        //print("Success")
                        let resultJSON : JSON = JSON(response.result.value!)
                        
                        let json = """
                            \(resultJSON)
                            """.data(using: .utf8)!
                        
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(GetSetting.self, from: json)
                            //print(result.data.permutation)
                            
                            let showResultCode = result.data.showResult
                            //print(showResultCode)
                            
                            if showResultCode == 0{
                                self.label1.text = "Your correct rate is: \(percentage)%"
                            }else{
                                self.label1.text = ""
                            }
                            
                        } catch {
                            self.label1.text = "Your correct rate is: \(percentage)"
                            print(error)
                            
                        }
                        
                    }
                    else{
                        self.label1.text = "Your correct rate is: \(percentage)"
                        print("Error \(String(describing: response.result.error))")
                    }
                    
                }
                
                

                //print(Set(self.selectedTrial))
                
                //self.dataToServer = ["level": self.nBackNum, "percentage": String(format:"%.2f" ,self.correctRate), "username": self.defaults.dictionary(forKey: "currentUserInfo")?["username"] as Any] as [String : Any]
                
                self.dataToServerList.append(self.dataToServer)
                
                //print(self.dataToServer)
                
                
                //send data to server
//                Alamofire.request("http://45.113.232.152:8080/nback/save", method: .post, parameters: self.dataToServer, encoding: JSONEncoding.default).responseJSON { (response) in
//                    if response.result.isSuccess{
//                        //print("Success")
//                        let resultJSON : JSON = JSON(response.result.value!)
//                        //print(resultJSON)
//                    }
//                    else{
//                        print("Error \(String(describing: response.result.error))")
//                    }
//                }
                
                
                if self.experimentBlockNum == 4 {
                    
                    self.label2.text = "You have finished the n-back test"
                    
                    self.button3.setTitle("Return to the main menu", for: .normal)
                    self.button3.isEnabled = true
                    
                    let parameters1 = ["records":self.dataToServerList] as [String:Any]
                    print(parameters1)
                    
                    //send all data to server
                    Alamofire.request("http://45.113.232.152:8080/nback/saveall", method: .post, parameters: parameters1, encoding: JSONEncoding.default).responseJSON { (response) in
                        if response.result.isSuccess{
                            
                            //print("Success")
                            let resultJSON : JSON = JSON(response.result.value!)
                            
                            print(resultJSON)
                            
                        }
                        else{
                            
                            print("Error \(String(describing: response.result.error))")
                        }
                        
                    }
                    
                    self.defaults.set(true, forKey: "NBackFinished")
                    
                    self.pushNotification()
                    
                    
                }else{
                    
                    self.label2.text = "Continue to the next block"
                    
                    self.button2.setTitle("Continue", for: .normal)
                    self.button2.isEnabled = true
                }
                
            }
        }
        
    }
    
    
    
    @IBAction func button1Pressed(_ sender: Any) {
        
        selectedTrial.append(self.length)
        print(self.length)
        
    }
    
    
    @IBAction func button2Pressed(_ sender: Any) {
        
        experimentBlockNum = experimentBlockNum + 1
        self.nextExperimentBlock()
        
    }
    
    
    func nextExperimentBlock(){
        
        if correctRate <= 0.2{
            
            if nBackNum >= 2{
                nBackNum = nBackNum - 1
            }
            
            nBackTest(nBack: nBackNum)
            
            
        }else if correctRate > 0.2 && correctRate <= 0.6 {
            
            nBackTest(nBack: nBackNum)
            
        }else if correctRate > 0.6{
            
            if nBackNum <= 2{
                nBackNum = nBackNum + 1
            }
            
            nBackTest(nBack: nBackNum)
            
        }
        
    }
    

    func findTargetIndex(n:Int) -> [Int]{
        
        var index = n
        var targetList = [Int]()
        
        while index <= 19{
            
            if nBackList[index] == nBackList[index-n]{
                targetList.append(index)
            }
            
            index = index + 1
        }

        return targetList
    }
    
    
    
    func calculateCorrectRate(n:Int) -> Double {
        
        let targetList = findTargetIndex(n: n)
        
        var correctNum = 0
        
        var incorrectNum = 0
        
        var missedNum = 0
        
        var correctRate = 0.0
        
        var score = 0
        
        for index1 in Set(selectedTrial){
            for index2 in targetList{
                if index1 == index2{
                    correctNum = correctNum + 1
                }
            }
        }
        
        incorrectNum = Set(selectedTrial).count - correctNum
        
        missedNum = targetList.count - correctNum
        
        score = correctNum - incorrectNum
        
        if score >= 0{
            correctRate = Double(score)/7.0
        }else{
            correctRate = 0.0
        }
        
        let correctPercentage = correctRate * 100
        
        self.dataToServer = ["level": self.nBackNum, "percentage": correctPercentage, "username": self.defaults.dictionary(forKey: "currentUserInfo")?["username"] as Any, "block": self.experimentBlockNum, "trials": 20, "incorrect": incorrectNum, "missed": missedNum] as [String : Any]
        
        return correctRate
    }
    
    
    
    struct NBackJSON: Codable {
        var message: String
        var code: Int
        var data: NBackData
    }
    
    struct NBackData : Codable{
        var answers : [Int]
        var permutation: [String]
    }
    
    struct GetSetting: Codable {
        var message: String
        var code: Int
        var data: SettingData
    }
    
    struct SettingData : Codable{
        var showResult: Int
    }
    
    
    //get n-back list from the server, parameter level means n-back level
    func generateNBackList(level: Int, callback:@escaping ()-> Void) {
        
        if level == 1{
            nBackList = ["W", "W", "V", "V", "W", "K", "K", "V", "W", "Q", "Q", "Z", "V", "L", "V", "V", "Z", "Z", "K", "K"]
        }else if level == 2{
            nBackList = ["Z", "Q", "Z", "Q", "P", "V", "Z", "P", "Q", "P", "Z", "K", "Q", "K", "L", "K", "C", "K", "C", "L"]
        }else if level == 3{
            nBackList = ["W", "W", "W", "W", "Z", "W", "Q", "Z", "W", "P", "L", "W", "Z", "C", "Z", "Q", "C", "W", "Q", "P"]
        }
        
        let parameters = ["level" : level] as [String : Any]
        
        Alamofire.request("http://45.113.232.152:8080/nback/request", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                let resultJSON : JSON = JSON(response.result.value!)
                
                if resultJSON["code"] == 200{
                    
                    let json = """
                        \(resultJSON)
                        """.data(using: .utf8)!
                    
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(NBackJSON.self, from: json)
                        //print(result.data.permutation)
                        
                        self.nBackList = result.data.permutation
                        callback()
                        
                    } catch {
                        print(error)
                        
                    }
                }
                else {
                    print("May have some errors!")
                    
                }
                
            }
            else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
    
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
    
    
    
    
}
