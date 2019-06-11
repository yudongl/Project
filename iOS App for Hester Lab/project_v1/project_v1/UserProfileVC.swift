//
//  UserProfileVC.swift
//  project_v1
//  Show user profile information
//  Created by Yudong Liu on 2019/5/21.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserProfileVC: UIViewController {

    //labels to show the user information
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var sex: UILabel!
    
    @IBOutlet weak var eMail: UILabel!
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let username = defaults.dictionary(forKey: "currentUserInfo")?["username"] as Any
        
        let password = defaults.dictionary(forKey: "currentUserInfo")?["password"] as Any
        
        let parameters = ["username": username, "password": password]
        
        Alamofire.request("http://45.113.232.152:8080/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                //print("Success")
                let resultJSON : JSON = JSON(response.result.value!)
                
                print(resultJSON)
                //print(resultJSON["code"])
                
                let json = """
                    \(resultJSON)
                    """.data(using: .utf8)!
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UserInfo.self, from: json)
                    //print(result.data.permutation)
                    
                    var sexStr = ""
                    if result.data.gender == 0{
                        sexStr = "Male"
                    }else if result.data.gender == 1{
                        sexStr = "Female"
                    }
                    
                    
                    self.userName.text = "Username: " + result.data.username
                    self.age.text = "Age: " + String(result.data.age)
                    self.sex.text = "Gender: " + sexStr
                    self.firstName.text = "Firstname: " + result.data.firstName
                    self.lastName.text = "Lastname: " + result.data.lastName
                    self.eMail.text = "Email: " + result.data.email
                    
                } catch {
                    print(error)
                    
                }
                
            }
            else{
                //self.serverFailRemind()
                print("Error \(String(describing: response.result.error))")
            }
            
        }
        
    }
    
    //define user infromation structure
    struct UserInfo : Codable{
        var code : Int
        var message: String
        var data: UserData
    }
    
    struct UserData :Codable{
        
        var age : Int
        var gender : Int
        var firstName : String
        var lastName : String
        var researcherId: String
        var username : String
        var email: String
        var password: String
    }
    
    
    
}
