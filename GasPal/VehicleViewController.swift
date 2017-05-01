//
//  VehicleViewController.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import MBProgressHUD

class VehicleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var vehicleTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var vehicles: [VehicleModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VehicleViewController")
        
        headerView.title = "Vehicle"
        headerView.doShowCameraIcon = true
        headerView.doShowAddIcon = true
        
        vehicleTableView.delegate = self
        vehicleTableView.dataSource = self
        vehicleTableView.rowHeight = UITableViewAutomaticDimension
        vehicleTableView.estimatedRowHeight = 100
        let cell = UINib(nibName: "VehicleTableCell", bundle: Bundle.main)
        vehicleTableView.register(cell, forCellReuseIdentifier: "VehicleTableCell")
        
        // initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(VehicleViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        vehicleTableView.insertSubview(refreshControl, at: 0)
        
        getVehicles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = vehicleTableView.dequeueReusableCell(withIdentifier: "VehicleTableCell") as! VehicleTableCell
        let vehicle = vehicles[indexPath.row]
        cell.vehicle = vehicle
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func getVehicles() {
        MBProgressHUD.hide(for: self.view, animated: true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ParseClient.sharedInstance.getVehicles(success: { (vehicles: [VehicleModel]) in
            
            self.vehicles = vehicles
            self.vehicleTableView.reloadData()
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            
        }) { (error: Error) in
            
            print(error.localizedDescription)
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getVehicles()
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
