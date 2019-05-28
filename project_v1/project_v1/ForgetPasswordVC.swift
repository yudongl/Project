//
//  ForgetPasswordVC.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/5/28.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var emailAddress: UITextField!
    
    
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
    
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        
        
        let userEmailAddress = emailAddress.text as! String
        
        if emailAddress.text != nil{
            
            let url = "http://45.113.232.152:8080/resetpassword/request?email=\(userEmailAddress)"
            
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
                if response.result.isSuccess{
                    
                    //print("Success")
                    let resultJSON : JSON = JSON(response.result.value!)
                    
                    print(resultJSON)
                    //print(resultJSON["code"])
                    
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
    
    
    func successRemind(){
        
        let alert = UIAlertController(title: "Thanks", message: "The server will send an email to you mailbox.", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in
            
        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func unsuccessRemind(){
        
        let alert = UIAlertController(title: "Sorry", message: "Your email address may not exist.", preferredStyle: .alert)
        
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
