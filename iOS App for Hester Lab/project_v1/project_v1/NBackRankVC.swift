//
//  NBackRankVC.swift
//  project_v1
//  N-back rank information
//  Created by Yudong Liu on 2019/5/21.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

class NBackRankVC: UIViewController {

    let defaults = UserDefaults.standard
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    let correctRateInterval = ["0%-10%", "10%-20%", "20%-30%", "30%-40%", "40%-50%", "50%-60%", "60%-70%", "70%-80%", "80%-90%", "90%-100%"]
    
    
    @IBOutlet weak var nBackRankChart: BarChartView!
    
    //provide the user's last record
    @IBOutlet weak var lastRecord: UILabel!
    
    //provide the user's rank percentage
    @IBOutlet weak var rankInfo: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        axisFormatDelegate = self
        updateNBackRankChart(level: 1)
       
    }
    
    
    //show 1-back chart
    @IBAction func updateOneBack(_ sender: Any) {
        
        updateNBackRankChart(level: 1)
        
    }
    
    
    //show 2-back chart
    @IBAction func updateTwoBack(_ sender: Any) {
        
        updateNBackRankChart(level: 2)
    }
    
    
    //show 3-back chart
    @IBAction func updateThreeBack(_ sender: Any) {
        
        updateNBackRankChart(level: 3)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //update the NBack rank chart
    func updateNBackRankChart(level: Int){
        
        let userName = defaults.dictionary(forKey: "currentUserInfo")?["username"] as! String
        
        let url = "http://45.113.232.152:8080/nback/getCorrectnessRank?level=\(level)&username=\(userName)"
        
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                let resultJSON : JSON = JSON(response.result.value!)
                //print(resultJSON)
                
                let json = """
                    \(resultJSON)
                    """.data(using: .utf8)!
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(NBackRankRecords.self, from: json)
                    //print(result.data.permutation)
                    
                    let nBackRankList = result.data.list
                    print(nBackRankList)
                    
                    self.setChart(dataEntryX: self.correctRateInterval, dataEntryY: nBackRankList, target: Double(result.data.myGapPosition))
                    
                    self.rankInfo.text = "You are in the first \(result.data.myPercentage)% of all users."
                    
                    self.lastRecord.text = "Your last \(level)-back correct rate is \(result.data.myScore)%."
                    
                } catch {
                    print(error)
                    
                }
                
            }
            else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
    }
    
    //add data entries to the chart
    func setChart(dataEntryX forX:[String], dataEntryY forY: [Double], target: Double) {
        
        nBackRankChart.noDataText = "You need to provide data for the chart."
        var dataEntries:[BarChartDataEntry] = []
        for i in 0..<forX.count{
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i]) , data: correctRateInterval as AnyObject?)
            //print(dataEntry)
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Correct Rate")
        let chartData = BarChartData(dataSet: chartDataSet)
        nBackRankChart.data = chartData
        let xAxisValue = nBackRankChart.xAxis
        xAxisValue.labelPosition = .bottom
        xAxisValue.valueFormatter = axisFormatDelegate
        
    }
    
    struct NBackRankRecords : Codable{
        var code : Int
        var message: String
        var data: NBackRankData
    }
    
    
    struct NBackRankData : Codable{
        
        var myPercentage: Double
        var list: [Double]
        var myGapPosition: Int
        var myScore: Double
        
    }
    
}

extension NBackRankVC: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return correctRateInterval[Int(value)]
    }
}
