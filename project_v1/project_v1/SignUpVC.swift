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
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var sex: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var eMail: UITextField!
    
    @IBOutlet weak var researchID: UITextField!
    
    var userInfoToRegister = [
        "age": 0,
        "email": "string",
        "name": "string",
        "password": "string",
        "researcherId": "string",
        "sex": 0,
        "username": "string"
        ] as [String : Any]
    
    
    
    
    
    
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

    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        if userName.text == nil || passWord.text == nil || name.text == nil || sex.text == nil || age.text == nil || eMail.text == nil {
            
            print("empty")
            
        }else{
            
            userInfoToRegister = [
                "age": age.text,
                "email": eMail.text,
                "name": name.text,
                "password": passWord.text,
                "researcherId": researchID.text,
                "sex": sex.text,
                "username": userName.text
                ] as [String : Any]
            
            Alamofire.request("http://45.113.232.152/user/register", method: .post, parameters: userInfoToRegister, encoding: JSONEncoding.default).responseJSON { (response) in
                if response.result.isSuccess{
                    
                    print("Success")
                    let resultJSON : JSON = JSON(response.result.value!)
                    
                    print(resultJSON)
                    //print(resultJSON["code"])
                    
                    if resultJSON["code"] == 200{
                        self.performSegue(withIdentifier: "SegueToMainMenu", sender: self)
                    }else {
                        print("May have some problem in log in.")
                    }
                    
                    self.finishedRemind()
                    
                    
                }
                else{
                    
                    print("Error \(String(describing: response.result.error))")
                }
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
    
    func finishedRemind(){
        
        let alert = UIAlertController(title: "Congratulations", message: "You have registered successfully!", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Return", style: .default, handler: { UIAlertAction in
            
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
}
