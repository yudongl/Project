//
//  ForgetPasswordVC.swift
//  project_v1
//  This file deals with the forget password function
//  Created by Yudong Liu on 2019/5/28.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgetPasswordVC: UIViewController {
    
    //email address textfield
    @IBOutlet weak var emailAddress: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        
        
        let userEmailAddress = emailAddress.text as! String
        
        //send the email address to the server and check if it is valid
        if emailAddress.text != nil{
            
            let url = "http://45.113.232.152:8080/resetpassword/request?email=\(userEmailAddress)"
            
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
                if response.result.isSuccess{
                    
                    let resultJSON : JSON = JSON(response.result.value!)
                    
                    if resultJSON["code"] == 200{
                        
                        self.successRemind()
                        
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
            
        }else{
            
            self.unsuccessRemind()
        }
        
    }
    
    
    //Give alert to show the email address is valid.
    func successRemind(){
        
        let alert = UIAlertController(title: "Thanks", message: "The server will send an email to you mailbox.", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in
            
        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //Give alert if the user's email address is not correct.
    func unsuccessRemind(){
        
        let alert = UIAlertController(title: "Sorry", message: "Your e-mail address may not exist.", preferredStyle: .alert)
        
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
    
}
