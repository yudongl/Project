//
//  SignInVC.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/5/6.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class SignInVC: UIViewController {

    @IBOutlet weak var textFieldUsername: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    let defaults = UserDefaults.standard
    
    var userDict = ["username": "", "password": ""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func buttonSignInPressed(_ sender: Any) {
        
        if textFieldPassword.text == nil || textFieldUsername == nil {
            
            print("Your username or password may be empty.")
            
        }else{
            
            userDict["username"] = textFieldUsername.text
            userDict["password"] = textFieldPassword.text
            
            defaults.set(self.userDict, forKey: "currentUserInfo")
            
            self.checkUserInfo()
            
        }
        
    }
    
    
    func checkUserInfo(){
        
        let parameters = userDict
        
        //Alamofire.request("http://45.113.232.152/", method: .get, parameters: parameters, encoding: JSONEncoding.default)
        
        Alamofire.request("http://45.113.232.152/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                print("Success")
                let resultJSON : JSON = JSON(response.result.value!)
                
                //print(resultJSON)
                //print(resultJSON["code"])
                
                if resultJSON["code"] == 200{
                    self.performSegue(withIdentifier: "SegueToMainMenu", sender: self)
                }else {
                    print("May have some problem in log in.")
                }
                
                
            }
            else{
                
                print("Error \(String(describing: response.result.error))")
            }
            
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
}
