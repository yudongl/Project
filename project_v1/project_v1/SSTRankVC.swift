//
//  SSTRankVC.swift
//  project_v1
//
//  Created by Yudong Liu on 2019/5/21.
//  Copyright © 2019 Yudong Liu. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

class SSTRankVC: UIViewController {

    
    @IBOutlet weak var avgTimeRankChart: BarChartView!
    
    @IBOutlet weak var rankPercentage: UILabel!
    
    @IBOutlet weak var lastRecord: UILabel!
    
    
    
    let defaults = UserDefaults.standard
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var timeInterval = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        axisFormatDelegate = self
        // Do any additional setup after loading the view.
        
        timeInterval = ["0-100ms", "100ms-200ms", "200ms-300ms", "300ms-400ms", "400ms-500ms", "500ms-600ms", "600ms-700ms", "700ms-800ms", "800ms-900ms", "900ms-1000ms"]
        
        updateAvgTimeChart(rankName: "getReactionTimeRank")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func avgReactionTimeRank(_ sender: Any) {
        
        timeInterval = ["0-100ms", "100ms-200ms", "200ms-300ms", "300ms-400ms", "400ms-500ms", "500ms-600ms", "600ms-700ms", "700ms-800ms", "800ms-900ms", "900ms-1000ms"]
        
        updateAvgTimeChart(rankName: "getReactionTimeRank")
        
    }
    
    
    
    @IBAction func stopSignalCorrectRate(_ sender: Any) {
        
        timeInterval = ["0-10%", "10%-20%", "20%-30%", "30%-40%", "40%-50%", "50%-60%", "60%-70%", "70%-80%", "80%-90%", "90%-100%"]
        
        updateAvgTimeChart(rankName: "getStopSignalRank")
        
    }
    
    
    @IBAction func normalSignalCorrectRate(_ sender: Any) {
        
        timeInterval = ["0-10%", "10%-20%", "20%-30%", "30%-40%", "40%-50%", "50%-60%", "60%-70%", "70%-80%", "80%-90%", "90%-100%"]
        
        updateAvgTimeChart(rankName: "getGoStimuliRank")
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateAvgTimeChart(rankName : String){
        
        let userName = defaults.dictionary(forKey: "currentUserInfo")?["username"] as! String
        
        let url = "http://45.113.232.152:8080/sst/\(rankName)?username=\(userName)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                
                let resultJSON : JSON = JSON(response.result.value!)
                print(resultJSON)
                
                let json = """
                    \(resultJSON)
                    """.data(using: .utf8)!
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SSTRankHistory.self, from: json)
                    //print(result.data.permutation)
                    
                    let sstRankList = result.data.list
                    print(sstRankList)
                    
                    self.setChart(dataEntryX: self.timeInterval, dataEntryY: sstRankList)
                    
                    self.rankPercentage.text = ("You are in the first \(result.data.myPercentage)% of all users.")
                    
                    if rankName == "getReactionTimeRank" {
                        self.lastRecord.text = ("Your last average reaction time is \(result.data.myScore)ms.")
                    }else if rankName == "getStopSignalRank" {
                        self.lastRecord.text = ("Your last stop signal correct rate is \(result.data.myScore)%.")
                    }else if rankName == "getGoStimuliRank" {
                        self.lastRecord.text = ("Your last normal trials correct rate is \(result.data.myScore)%.")
                    }else{
                        
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
    
    
    func setChart(dataEntryX forX:[String],dataEntryY forY: [Double]) {
        avgTimeRankChart.noDataText = "You need to provide data for the chart."
        var dataEntries:[BarChartDataEntry] = []
        for i in 0..<forX.count{
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i]) , data: timeInterval as AnyObject?)
            //print(dataEntry)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "SST time/percentage interval")
        let chartData = BarChartData(dataSet: chartDataSet)
        avgTimeRankChart.data = chartData
        let xAxisValue = avgTimeRankChart.xAxis
        xAxisValue.labelPosition = .bottom
        xAxisValue.valueFormatter = axisFormatDelegate
        
    }
    
    
    
    
    struct SSTRankHistory : Codable{
        var code : Int
        var message: String
        var data: SSTRankData
    }
    
    
    struct SSTRankData : Codable{
        
        var myPercentage: Double
        var list: [Double]
        var myGapPosition: Int
        var myScore: Double
        
    }
    

}


extension SSTRankVC: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return timeInterval[Int(value)]
    }
}
