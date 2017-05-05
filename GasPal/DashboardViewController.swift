//
//  DashboardViewController.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {

    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var mpgChartView: LineChartView!
    
    var trackingModels: [TrackingModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DashboardViewController")
        
        headerView.title = "Dashboard"
        
        // Load tracking trips for initial timeline
        // Making sure we have trackings loaded -- Should we just fetch all required data on app load?
        if TrackingModel.hasLoadedTracking! {
            trackingModels = TrackingModel.getAllByTimeline(timelineFilter: TrackingTimelineFilter.lastWeek)
            createChart()
        } else {
            ParseClient.sharedInstance.getTrackings(success: { (trackingModels: [TrackingModel]) in
                self.trackingModels = TrackingModel.getAllByTimeline(timelineFilter: TrackingTimelineFilter.lastYear)
                self.createChart()
            }) { (error: Error) in
                print("ERROR")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createChart() {
        var dataEntries: [ChartDataEntry] = [ChartDataEntry]()
        
        var index = 0
        for tracking in trackingModels {
            let miles = tracking.odometerEnd! - tracking.odometerStart!
            let gallons = tracking.gallons!
            let mpg = Double(miles) / gallons
            
            let dataEntry = ChartDataEntry(x: Double(index), y: mpg)
            dataEntries.append(dataEntry)
            
            index += 1
        }
        
        let data = LineChartData()
        let ds = LineChartDataSet(values: dataEntries, label: "MPG")
        
        let xAxis: XAxis = XAxis()
        let lineChartFormatter: LineChartFormatter = LineChartFormatter()
        xAxis.valueFormatter = lineChartFormatter
        
        data.addDataSet(ds)
        mpgChartView.data = data
        mpgChartView.xAxis.valueFormatter = xAxis.valueFormatter
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
