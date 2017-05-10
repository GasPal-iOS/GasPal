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
    @IBOutlet weak var mpgFilterSegmentedControl: UISegmentedControl!
    
    var lineChartColors: [UIColor] = [UIColor.blue, UIColor.red, UIColor.yellow]
    
    var vehicles: [VehicleModel]!
    var selectedVehicles: [VehicleModel]! // The vehicles user is including in chart
    var selectedTimelineFilter: TrackingTimelineFilter = TrackingTimelineFilter.allTime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DashboardViewController")
        
        headerView.title = "Dashboard"
        
        mpgFilterSegmentedControl.apportionsSegmentWidthsByContent = true
        mpgFilterSegmentedControl.insertSegment(withTitle: TrackingTimelineFilter.lastYear.rawValue, at: 2, animated: false)
        mpgFilterSegmentedControl.insertSegment(withTitle: TrackingTimelineFilter.allTime.rawValue, at: 3, animated: false)
        
        // Load vehicles to build mpg charts
        ParseClient.sharedInstance.getVehicles(success: { (vehicles: [VehicleModel]) in
            self.vehicles = vehicles
            self.createChart()
        }) { (Error) in
            print("ERROR GETTING VEHICLES")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getChartDataSet(vehicle: VehicleModel) -> LineChartDataSet {
        var dataEntries: [ChartDataEntry] = [ChartDataEntry]()
        
        let trackingModels = TrackingModel.getAllByTimelineAndVehicle(timelineFilter: selectedTimelineFilter, vehicle: vehicle)
        
        var index = 0
        for tracking in trackingModels {
            if let mpg = tracking.mpg {
                let dataEntry = ChartDataEntry(x: Double(index), y: mpg)
                dataEntries.append(dataEntry)
                
                index += 1
            }
            
        }
        
        let dataSet = LineChartDataSet(values: dataEntries, label: "\(vehicle.make!) \(vehicle.model!)")
        
        return dataSet
    }
    
    func createChart() {
        var dataSets = [LineChartDataSet]()

        var index = 0
        for vehicle in vehicles {
            let dataSet = getChartDataSet(vehicle: vehicle)
            let color = lineChartColors[index % 3]
            dataSet.setColor(color)
            dataSet.setCircleColor(color)
            dataSet.circleRadius = 5.0
            dataSets.append(dataSet)
            
            index += 1
        }
        
        let xAxis: XAxis = XAxis()
        let lineChartFormatter: LineChartFormatter = LineChartFormatter()
        xAxis.valueFormatter = lineChartFormatter
        
        let data = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        mpgChartView.data = data
        mpgChartView.xAxis.valueFormatter = xAxis.valueFormatter
    }
    
    @IBAction func onMPGFilterChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedTimelineFilter = TrackingTimelineFilter.lastWeek
        case 1:
            selectedTimelineFilter = TrackingTimelineFilter.lastMonth
        case 2:
            selectedTimelineFilter = TrackingTimelineFilter.lastYear
        case 3:
            selectedTimelineFilter = TrackingTimelineFilter.allTime
        default:
            break
        }
        createChart()
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
