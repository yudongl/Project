//
//  NBackListGenerate.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/4/29.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


//var nBackList = [""]

//public func genarateOneBackPracticeList() -> [String] {
//
//    return ["W", "W", "V", "V", "W", "K", "K", "V", "W", "Q"]
//
//}
//
//
//public func genarateTwoBackPracticeList() -> [String] {
//
//    return ["W", "V", "W", "V", "Q", "K", "P", "K", "C", "W"]
//}


//struct NBackJSON: Codable {
//    var message: String
//    var code: Int
//    var data: NBackData
//}
//
//struct NBackData : Codable{
//    var answers : [Int]
//    var permutation: [String]
//}
//
//
//public func generateNBackList(level: Int, callback:@escaping ()-> Void) {
//
//    if level == 1{
//        nBackList = ["W", "W", "V", "V", "W", "K", "K", "V", "W", "Q", "Q", "Z", "V", "L", "V", "V", "Z", "Z", "K", "K"]
//    }else if level == 2{
//        nBackList = ["Z", "Q", "Z", "Q", "P", "V", "Z", "P", "Q", "P", "Z", "K", "Q", "K", "L", "K", "C", "K", "C", "L"]
//    }else if level == 3{
//        nBackList = ["W", "W", "W", "W", "Z", "W", "Q", "Z", "W", "P", "L", "W", "Z", "C", "Z", "Q", "C", "W", "Q", "P"]
//    }
//
//    let parameters = ["level" : level] as [String : Any]
//
//    Alamofire.request("http://45.113.232.152/nback/request", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
//        if response.result.isSuccess{
//
//            let resultJSON : JSON = JSON(response.result.value!)
//
//            if resultJSON["code"] == 200{
//
//                let json = """
//                    \(resultJSON)
//                    """.data(using: .utf8)!
//
//                do {
//                    let decoder = JSONDecoder()
//                    let result = try decoder.decode(NBackJSON.self, from: json)
//                    //print(result.data.permutation)
//
//                    nBackList = result.data.permutation
//                    callback()
//
//                } catch {
//                    print(error)
//
//                }
//            }
//            else {
//                print("May have some errors!")
//
//            }
//
//        }
//        else{
//            print("Error \(String(describing: response.result.error))")
//
//        }
//    }
//
//}
