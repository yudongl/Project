//
//  SignUpVC.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/5/6.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SignUpVC: UIViewController {

    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var sex: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var eMail: UITextField!
    
    @IBOutlet weak var researchID: UITextField!
    
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

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        if userName.text == nil || passWord.text == nil || firstName.text == nil || lastName.text == nil || sex.text == nil || age.text == nil || eMail.text == nil {
            
            self.unsuccessRemind()
            print("empty")
            
        }else{
        
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
            
            Alamofire.request("http://45.113.232.152:8080/user/register", method: .post, parameters: userInfoToRegister, encoding: JSONEncoding.default).responseJSON { (response) in
                if response.result.isSuccess{
                    
                    //print("Success")
                    let resultJSON : JSON = JSON(response.result.value!)
                    
                    print(resultJSON)
                    //print(resultJSON["code"])
                    
                    if resultJSON["code"] == 200{
                        
                        self.finishedRemind()
                        //self.performSegue(withIdentifier: "SegueToMainMenu", sender: self)
                    }else {
                        
                        
                        self.unsuccessRemind()
                        //print("May have some problem in log in.")
                    }
                    
                }
                else{
                    
                    self.serverFailRemind()
                    print("Error \(String(describing: response.result.error))")
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func buttonBackPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SegueBackToSignIn", sender: self)
    }
    
    
    
    
    
    func finishedRemind(){
        
        let alert = UIAlertController(title: "Congratulations", message: "You have registered successfully!", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Finish", style: .default, handler: { UIAlertAction in
            
            self.performSegue(withIdentifier: "SegueBackToSignIn", sender: self)
        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func unsuccessRemind(){
        
        let alert = UIAlertController(title: "Sorry", message: "Please double check your information!", preferredStyle: .alert)
        
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
    
    
    
    
}
