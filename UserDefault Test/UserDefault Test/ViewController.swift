//
//  ViewController.swift
//  UserDefault Test
//
//  Created by Yudong Liu on 2019/5/6.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var textField1: UITextField!
    
    @IBOutlet weak var textField2: UITextField!
    
    
    let defaults = UserDefaults.standard
    
    var text = ""
    
    var dict = ["username": "", "password": ""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        text = textField1.text!
        
        print(text)
        
        self.defaults.set(self.text, forKey: "haha")
        
        dict["username"] = textField1.text!
        dict["password"] = textField2.text!
        
        self.defaults.set(self.dict, forKey: "userinfo")
        
        
    }
    
    

}

