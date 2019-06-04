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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if defaults.dictionary(forKey: "currentUserInfo")?["username"] != nil {
            textFieldUsername.text = defaults.dictionary(forKey: "currentUserInfo")?["username"] as? String
            textFieldPassword.text = defaults.dictionary(forKey: "currentUserInfo")?["password"] as? String
        }
        
        
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
        
        if textFieldPassword.text == nil || textFieldUsername.text == nil {
            
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
        
        Alamofire.request("http://45.113.232.152:8080/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                //print("Success")
                let resultJSON : JSON = JSON(response.result.value!)
                
                print(resultJSON)
                //print(resultJSON["code"])
                
                if resultJSON["code"] == 200{
                    self.performSegue(withIdentifier: "SegueToMainMenu", sender: self)
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
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func unsuccessRemind(){
        
        let alert = UIAlertController(title: "Sorry", message: "Your username or password may be not correct.", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in
            
        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func serverFailRemind(){
        
        let alert = UIAlertController(title: "Sorry", message: "There may be something wrong connecting to the server.", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in
            
            
        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
