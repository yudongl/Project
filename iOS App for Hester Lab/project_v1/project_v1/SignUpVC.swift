//
//  SignUpVC.swift
//  project_v1
//  User register
//  Created by Yudong Liu on 2019/5/6.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SignUpVC: UIViewController {

    //user information text fields
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var sex: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var eMail: UITextField!
    
    @IBOutlet weak var researchID: UITextField!
    
    //user informaion disctionary
    var userInfoToRegister = [
        "age": 0,
        "email": "string",
        "firstName": "string",
        "lastName": "string",
        "password": "string",
        "researcherId": "string",
        "sex": 0,
        "username": "string"
        ] as [String : Any]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //adjust the frame position depend on the keyboard height
        //tap anywhere in the view to dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        if userName.text == nil || passWord.text == nil || firstName.text == nil || lastName.text == nil || sex.text == nil || age.text == nil || eMail.text == nil {
            
            self.unsuccessRemind()
            //print("empty")
            
        }else{
            
            //male -> sexNum = 0
            //female -> sexNum = 1
            var sexNum = 0
            
            if sex.text?.lowercased() == "male" {
                sexNum = 0
            }else if sex.text?.lowercased() == "female"{
                sexNum = 1
            }
            
            userInfoToRegister = [
                "age": age.text,
                "email": eMail.text,
                "firstName": firstName.text,
                "lastName": lastName.text,
                "password": passWord.text,
                "researcherId": researchID.text,
                "gender": sexNum,
                "username": userName.text
                ] as [String : Any]
            
            //save user register information to the server
            Alamofire.request("http://45.113.232.152:8080/user/register", method: .post, parameters: userInfoToRegister, encoding: JSONEncoding.default).responseJSON { (response) in
                if response.result.isSuccess{
                    
                    let resultJSON : JSON = JSON(response.result.value!)
                    
                    if resultJSON["code"] == 200{
                        
                        self.finishedRemind()
                        
                    }else {
                        
                        self.unsuccessRemind()
                        print("May have some problem in log in.")
                    }
                    
                }
                else{
                    
                    self.serverFailRemind()
                    print("Error \(String(describing: response.result.error))")
                }
                
            }
            
        }
        
    }
    
    //back to sign in page
    @IBAction func buttonBackPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SegueBackToSignIn", sender: self)
    }
    
    
    //Give alert to show the register is succeed.
    func finishedRemind(){
        
        let alert = UIAlertController(title: "Congratulations", message: "You have registered successfully!", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Finish", style: .default, handler: { UIAlertAction in
            
            self.performSegue(withIdentifier: "SegueBackToSignIn", sender: self)
        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //Give alert if the user's information is not correct.
    func unsuccessRemind(){
        
        let alert = UIAlertController(title: "Sorry", message: "Please double check your information!", preferredStyle: .alert)
        
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
    
    
    
    
}
