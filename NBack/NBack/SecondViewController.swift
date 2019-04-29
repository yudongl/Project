//
//  SecondViewController.swift
//  NBack
//
//  Created by Yudong Liu on 2019/4/11.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    
    var length = 0
    
    let list = genarateOneBackPracticeList()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        oneBackPractice()
        
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
        
        print(length)
        
  
    }
    
    func oneBackPractice(){
        
        label2.text = "1-Back Practice Block"
        label1.text = ""
        image1.image = UIImage(named: "trans")
        button1.isEnabled = false
        
        Timer.after(750.ms) {
            
            self.nextLetter()
            
        }
        
        Timer.after(35750.ms) {
            
            //display feedback and go next block
            
            
            
        }
        

    }
    
    func twoBackPractice(){
        
    }
    
    
    func oneBack(){
        
    }
    
    func twoBack(){
        
    }
    
    func threeBack(){
        
    }
    
    
    func nextLetter(){
        
        label2.text = ""
        label1.text = "(get ready)"
        image1.image = UIImage(named: "wait")
        button1.isEnabled = false
        
        Timer.after(500.ms) {
            self.button1.isEnabled = true
            self.label1.text = ""
            self.image1.image = UIImage(named: self.list[self.length])
        }
        
        Timer.after(1000.ms) {
            self.label1.text = ""
            self.image1.image = UIImage(named: "trans")
        }
        
        Timer.after(3500.ms) {
            
            self.length = self.length + 1
            
            if self.length <= 9 {
                
                self.nextLetter()
            }
            else {
                self.label2.text = "feedback"
            }
            
        }
        
    }
    
    
    
    
}
