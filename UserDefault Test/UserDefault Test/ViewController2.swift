//
//  ViewController2.swift
//  UserDefault Test
//
//  Created by Yudong Liu on 2019/5/6.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    
    @IBOutlet weak var label1: UILabel!
    
    let defaults = UserDefaults.standard
    
    var text = ""
    
    var username = ""
    
    
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
        
        text = defaults.object(forKey: "haha") as! String
        
        //label1.text = text
        
        label1.text = defaults.dictionary(forKey: "userinfo")?["username"] as? String
        
    }
    
    
    

}
