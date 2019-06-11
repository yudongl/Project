//
//  NBackRecordsVC.swift
//  project_v1
//  N-back history records
//  Created by Yudong Liu on 2019/5/21.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

class NBackRecordsVC: UIViewController {

    
    @IBOutlet weak var oneBackChart: LineChartView!
    
    @IBOutlet weak var twoBackChart: LineChartView!
    
    @IBOutlet weak var threeBackChart: LineChartView!
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateOneBackChart()
        updateTwoBackChart()
        updateThreeBackChart()
    }
    
    //update 1-back correct rate records chart
    func updateOneBackChart(){
        
        let userName = defaults.dictionary(forKey: "currentUserInfo")?["username"] as! String
        
        let url = "http://45.113.232.152:8080/nback/getHistoryInfo?bound=10&level=1&username=\(userName)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                let resultJSON : JSON = JSON(response.result.value!)
                print(resultJSON)
                
                
                let json = """
                    \(resultJSON)
                    """.data(using: .utf8)!
                
                self.oneBackChart.noDataText = "There is no data for the chart."
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(NBackHistory.self, from: json)
                    //print(result.data.permutation)
                    
                    let nbackHistoryList = result.data.records
                    //print(nbackHistoryList)
                    
                    self.oneBackChart.noDataText = "There is no data for the chart."
                    var dataEntries:[ChartDataEntry] = []
                    for i in 0..<nbackHistoryList.count{
                        
                        let dataEntry = ChartDataEntry(x: Double(i+1), y: Double(nbackHistoryList[i]))
                        print(dataEntry)
                        dataEntries.append(dataEntry)
                    }
                    
                    if dataEntries.count > 0{
                    
                        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Last 10 1-Back Records")
                        let chartData = LineChartData(dataSet: chartDataSet)
                        self.oneBackChart.data = chartData
                        self.oneBackChart.xAxis.labelPosition = .bottom
                    }else{
                        self.oneBackChart.noDataText = "There is no data for the chart."
                    }
                        
                        
                } catch {
                    print(error)
                    
                }
                
            }
            else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
        
    }
    
    
    //update 2-back correct rate records chart
    func updateTwoBackChart(){
        
        let userName = defaults.dictionary(forKey: "currentUserInfo")?["username"] as! String
        
        let url = "http://45.113.232.152:8080/nback/getHistoryInfo?bound=10&level=2&username=\(userName)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                let resultJSON : JSON = JSON(response.result.value!)
                print(resultJSON)
                
                
                let json = """
                    \(resultJSON)
                    """.data(using: .utf8)!
                
                self.twoBackChart.noDataText = "There is no data for the chart."
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(NBackHistory.self, from: json)
                    //print(result.data.permutation)
                    
                    let nbackHistoryList = result.data.records
                    //print(nbackHistoryList)
                    
                    self.twoBackChart.noDataText = "There is no data for the chart."
                    var dataEntries:[ChartDataEntry] = []
                    for i in 0..<nbackHistoryList.count{
                        
                        let dataEntry = ChartDataEntry(x: Double(i+1), y: Double(nbackHistoryList[i]))
                        print(dataEntry)
                        dataEntries.append(dataEntry)
                    }
                    
                    if dataEntries.count > 0{
                    
                        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Last 10 2-Back Records")
                        let chartData = LineChartData(dataSet: chartDataSet)
                        self.twoBackChart.data = chartData
                        self.twoBackChart.xAxis.labelPosition = .bottom
                    }else{
                        self.twoBackChart.noDataText = "There is no data for the chart."
                    }
                    
                } catch {
                    print(error)
                    
                }
                
            }
            else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
        
    }
    
    //update 3-back correct rate records chart
    func updateThreeBackChart(){
        
        let userName = defaults.dictionary(forKey: "currentUserInfo")?["username"] as! String
        
        let url = "http://45.113.232.152:8080/nback/getHistoryInfo?bound=10&level=3&username=\(userName)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                let resultJSON : JSON = JSON(response.result.value!)
                print(resultJSON)
                
                
                let json = """
                    \(resultJSON)
                    """.data(using: .utf8)!
                
                self.threeBackChart.noDataText = "There is no data for the chart."
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(NBackHistory.self, from: json)
                    //print(result.data.permutation)
                    
                    let nbackHistoryList = result.data.records
                    //print(nbackHistoryList)
                    
                    self.threeBackChart.noDataText = "There is no data for the chart."
                    var dataEntries:[ChartDataEntry] = []
                    for i in 0..<nbackHistoryList.count{
                        
                        let dataEntry = ChartDataEntry(x: Double(i+1), y: Double(nbackHistoryList[i]))
                        print(dataEntry)
                        dataEntries.append(dataEntry)
                    }
                    
                    if dataEntries.count > 0{
                    
                        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Last 10 3-Back Records")
                        let chartData = LineChartData(dataSet: chartDataSet)
                        self.threeBackChart.data = chartData
                        self.threeBackChart.xAxis.labelPosition = .bottom
                    }else{
                        self.threeBackChart.noDataText = "There is no data for the chart."
                    }
                    
                } catch {
                    print(error)
                    
                }
                
            }
            else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
        
    }
    
    
    struct NBackHistory : Codable{
        var code : Int
        var message: String
        var data: RecordData
    }
    
    
    struct RecordData : Codable{
        
        var records: [Double]
        
    }
    

}
