//
//  TrackingViewController.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import MBProgressHUD

class TrackingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FormCompleteDelegate {
    
    var trackings = [TrackingModel]()
    
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("TrackingViewController")
        
        headerView.title = "Tracking"
        headerView.doShowCameraIcon = true
        headerView.doShowAddIcon = true
        headerView.formCompleteDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        let cell = UINib(nibName: "TrackingCell", bundle: Bundle.main)
        tableView.register(cell, forCellReuseIdentifier: "TrackingCell")
        
        // initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TrackingViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        refreshControlAction(refreshControl)
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        MBProgressHUD.hide(for: self.view, animated: true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ParseClient.sharedInstance.getTrackings(success: { (trackings) in
            self.trackings = trackings
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
        return trackings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingCell", for: indexPath) as! TrackingCell
        cell.tracking = trackings[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailView(model: trackings[indexPath.row])
    }
    
    func onFormCompleted() {
        openDetailView(model: TrackingModel())
    }
    
    func openDetailView(model: TrackingModel) {
        print("openDetailView")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let trackingDetailViewController = storyboard.instantiateViewController(withIdentifier: "TrackingDetailViewController") as! TrackingDetailViewController
        // Set the model for the details view controller
        trackingDetailViewController.tracking = model
        self.navigationController?.pushViewController(trackingDetailViewController, animated: true)
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
