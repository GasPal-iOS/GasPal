//
//  ServiceViewController.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import MBProgressHUD

class ServiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddIconDelegate {
    
    var services = [ServiceModel]()
    
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ServiceViewController")
        
        headerView.title = "Services"
        headerView.doShowAddIcon = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        let cell = UINib(nibName: "ServiceCell", bundle: Bundle.main)
        tableView.register(cell, forCellReuseIdentifier: "ServiceCell")
        
        // initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TrackingViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        refreshControlAction(refreshControl)
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        MBProgressHUD.hide(for: self.view, animated: true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ParseClient.sharedInstance.getServices(success: { (services) in
            self.services = services
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
            refreshControl.endRefreshing()
        }) { (error) in
            print(error.localizedDescription)
            MBProgressHUD.hide(for: self.view, animated: true)
            refreshControl.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        cell.service = services[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailView(model: services[indexPath.row])
    }
    
    func onAddIconTapped() {
        openDetailView(model: ServiceModel())
    }
    
    func openDetailView(model: ServiceModel) {
        print("openDetailView")
        
        // if this is a new object, then set defaults
        if model.id == nil {
            if services.count > 0 {
                if model.userId == nil {
                    model.userId = services[0].userId
                }
                if model.vehicleId == nil {
                    model.vehicleId = services[0].vehicleId
                }
            }
            if model.serviceDate == nil {
                model.serviceDate = Date()
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let serviceDetailViewController = storyboard.instantiateViewController(withIdentifier: "ServiceDetailViewController") as! ServiceDetailViewController
        // Set the model for the details view controller
        serviceDetailViewController.service = model
        present(serviceDetailViewController, animated: true, completion: nil)
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
