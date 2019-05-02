//
//  NBackListGenerate.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/4/29.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import Foundation

public func genarateOneBackPracticeList() -> [String] {
    
    return ["W", "W", "V", "V", "W", "K", "K", "V", "W", "Q"]
    
}


public func genarateTwoBackPracticeList() -> [String] {
    
    return ["W", "V", "W", "V", "Q", "K", "P", "K", "C", "W"]
}


public func generateOneBackList() -> [String] {
    
    return ["W", "W", "V", "V", "W", "K", "K", "V", "W", "Q", "Q", "Z", "V", "L", "V", "V", "Z", "Z", "K", "K"]
}

public func generateTwoBackList() -> [String] {
    
    return ["Z", "Q", "Z", "Q", "P", "V", "Z", "P", "Q", "P", "Z", "K", "Q", "K", "L", "K", "C", "K", "C", "L"]
}

public func genarateThreeBackList() -> [String] {
    
    return ["W", "W", "W", "W", "Z", "W", "Q", "Z", "W", "P", "L", "W", "Z", "C", "Z", "Q", "C", "W", "Q", "P"]
}
