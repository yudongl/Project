//
//  SignInVC.swift
//  project_v1
//  Sign in view controller functions
//  Created by Yudong Liu on 2019/5/6.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class SignInVC: UIViewController {
    
    //username text field
    @IBOutlet weak var textFieldUsername: UITextField!
    
    //password text field
    @IBOutlet weak var textFieldPassword: UITextField!
    
    let defaults = UserDefaults.standard
    
    //save username and password
    var userDict = ["username": "", "password": ""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adjust the frame position depend on the keyboard height
        //tap anywhere in the view to dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //set the last login username and password
        if defaults.dictionary(forKey: "currentUserInfo")?["username"] != nil {
            textFieldUsername.text = defaults.dictionary(forKey: "currentUserInfo")?["username"] as? String
            textFieldPassword.text = defaults.dictionary(forKey: "currentUserInfo")?["password"] as? String
        }
        
        
    }

    
    //button pressed function
    @IBAction func buttonSignInPressed(_ sender: Any) {
        
        if textFieldPassword.text == nil || textFieldUsername.text == nil {
            
            self.emptyUsernameOrPassword()
            print("Your username or password may be empty.")
            
        }else{
            
            //save the input username and password to userDict
            userDict["username"] = textFieldUsername.text
            userDict["password"] = textFieldPassword.text
            
            //the UserDefalts to save the username and password to the local storage
            defaults.set(self.userDict, forKey: "currentUserInfo")
            
            //check the user's username and password in the server
            self.checkUserInfo()
            
        }
        
    }
    
    //send username and password to the server
    //wait the server returned info to judge if the username and password are correct
    func checkUserInfo(){
        
        let parameters = userDict
        
        Alamofire.request("http://45.113.232.152:8080/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                let resultJSON : JSON = JSON(response.result.value!)
                
                //if  code == 200 => the username and password are correct
                //otherwise, they are not correct
                if resultJSON["code"] == 200{
                    
                    //enter the main menu
                    self.performSegue(withIdentifier: "SegueToMainMenu", sender: self)
                }else {
                    
                    //provide unsuccess alert
                    self.unsuccessRemind()
                    print("May have some problem in log in.")
                }
            }
            else{
                
                //provide server fail alert
                self.serverFailRemind()
                print("Error \(String(describing: response.result.error))")
            }
            
        }
        
    }
    
    
    //dismiss the keyboard
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //adjust the frame position depend on the keyboard height
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    //hide the keybord
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    //Give alert to the user if his username or password is not correct.
    func unsuccessRemind(){
        
        let alert = UIAlertController(title: "Sorry", message: "Your username or password may be not correct.", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in
            
        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //Give alert if cannot connect to the server.
    func serverFailRemind(){
        
        let alert = UIAlertController(title: "Sorry", message: "There may be something wrong connecting to the server.", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in
            
        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //Give alert if the username or password is empty.
    func emptyUsernameOrPassword(){
        
        let alert = UIAlertController(title: "Sorry", message: "Your username or password may be empty.", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in

        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}
