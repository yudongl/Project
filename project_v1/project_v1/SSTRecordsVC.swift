//
//  SSTRecordsVC.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/5/21.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts

class SSTRecordsVC: UIViewController {

    
    @IBOutlet weak var avgTimeLineChart: LineChartView!
    
    @IBOutlet weak var correctRateLineChart: LineChartView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateAvgTimeChart()
        updateCorrectRateChart()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func updateAvgTimeChart(){
        
        let userName = defaults.dictionary(forKey: "currentUserInfo")?["username"] as! String
        
        let url = "http://45.113.232.152:8080/sst/getHistoryInfo?bound=10&username=\(userName)"
        
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                let resultJSON : JSON = JSON(response.result.value!)
                //print(resultJSON)
                
                
                let json = """
                    \(resultJSON)
                    """.data(using: .utf8)!
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SSTHistory.self, from: json)
                    //print(result.data.permutation)
                    
                    let nbackHistoryList = result.data[0].reactionTime
                    print(nbackHistoryList)
                    
                    self.avgTimeLineChart.noDataText = "There is no data for the chart."
                    var dataEntries:[ChartDataEntry] = []
                    for i in 0..<result.data.count{
                        
                        let dataEntry = ChartDataEntry(x: Double(i+1), y: Double(result.data[i].reactionTime))
                        print(dataEntry)
                        dataEntries.append(dataEntry)
                    }
                    let chartDataSet = LineChartDataSet(values: dataEntries, label: "Last 10 SST average reaction time/ms")
                    let chartData = LineChartData(dataSet: chartDataSet)
                    self.avgTimeLineChart.data = chartData
                    self.avgTimeLineChart.xAxis.labelPosition = .bottom
                    
                    
                } catch {
                    print(error)
                    
                }
                
            }
            else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
        

    }
    
    
    func updateCorrectRateChart(){
        
        let userName = defaults.dictionary(forKey: "currentUserInfo")?["username"] as! String
        
        let url = "http://45.113.232.152:8080/sst/getHistoryInfo?bound=10&username=\(userName)"
        
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                let resultJSON : JSON = JSON(response.result.value!)
                //print(resultJSON)
                
                
                let json = """
                    \(resultJSON)
                    """.data(using: .utf8)!
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SSTHistory.self, from: json)
                    //print(result.data.permutation)
                    
                    let nbackHistoryList = result.data[0].reactionTime
                    print(nbackHistoryList)
                    
                    self.correctRateLineChart.noDataText = "There is no data for the chart."
                    var dataEntries:[ChartDataEntry] = []
                    for i in 0..<result.data.count{
                        
                        let dataEntry = ChartDataEntry(x: Double(i+1), y: Double(result.data[i].percentage))
                        print(dataEntry)
                        dataEntries.append(dataEntry)
                    }
                    let chartDataSet = LineChartDataSet(values: dataEntries, label: "Last 10 SST correct rate")
                    chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
                    let chartData = LineChartData(dataSet: chartDataSet)
                    self.correctRateLineChart.data = chartData
                    self.correctRateLineChart.xAxis.labelPosition = .bottom
                    
                    
                } catch {
                    print(error)
                    
                }
                
            }
            else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    struct SSTHistory : Codable{
        var code : Int
        var message: String
        var data: [SSTRecord]
    }
    
    
    struct SSTRecord : Codable{
        
        var missed: Int
        var incorrect: Int
        var reactionTime: Double
        var percentage: Double
        
    }
    
    
    
    
    
    
}
