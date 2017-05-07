//
//  TrackingViewController.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import MBProgressHUD


class TrackingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ImageCaptureDelegate, FormCompleteDelegate {

    
    var trackings = [TrackingModel]()
    
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("TrackingViewController")
        
        headerView.imageCaptureDelegate = self

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
    
    func onImageCaptured(capturedImage: UIImage) {
        print("Tracking.onImageCaptured")

        
         OCRClient.extractData(image: capturedImage, success: { (extractedData: [String]) in
         
            // print("The dat/a", extractedData)
            // split each line
            var lines = extractedData.split(separator: ",")
            let line = lines.popLast()
            
            
            // Tracking Data
            var totalAmountString = "25.99"
            var pricePerGallonString = "2.99"
            var dateStr = "05/12/17"
            
            for index in 1..<line!.count-1 {
                let lineItem = line?[index]
                // print (lineItem!)
                // 1. extract price/gal
                if lineItem!.range(of: "PRICE/GAL") != nil {
                    //print("PRICE/GAL")
                    //print(lineItem!)
                    let totalWords = lineItem?.components(separatedBy: " ")
                    pricePerGallonString = String(totalWords![1].characters.dropFirst())
                    print(pricePerGallonString)

                } else if (lineItem!.range(of: "Pace/Gal") != nil) {
                    //print("PRICE/GAL")
                    //print(lineItem!)
                    let totalWords = lineItem?.components(separatedBy: " ")
                    pricePerGallonString = String(totalWords![1].characters.dropFirst())
                    pricePerGallonString.insert(".", at: pricePerGallonString.index(after: pricePerGallonString.startIndex))
                    print(pricePerGallonString)
                }
                
                // 2. Total Fuel
                if lineItem!.range(of: "TOTAL") != nil {
                    //print(lineItem!)
                    let totalWords = lineItem?.components(separatedBy: " ")
                    totalAmountString = String(totalWords![2].characters.dropFirst())
                    print(totalAmountString)

                } else if (lineItem!.range(of: "Fuel Sale") != nil) {
                    let totalWords = lineItem?.components(separatedBy: " ")
                    totalAmountString = String(totalWords![2].characters.dropFirst())
                    print(totalAmountString)
                }
                
                // 3. Date
                if lineItem!.range(of: "DATE") != nil {
                    print("Date")
                    print(lineItem!)
                } else if (lineItem!.range(of: "PM") != nil) {
                    //print("Date")
                    //print(lineItem!)
                    // replace all 9 with 0 and 8 with 0
                    dateStr = lineItem!
                    dateStr = dateStr.replacingOccurrences(of: "9", with: "0")
                    dateStr = dateStr.replacingOccurrences(of: "8", with: "0")
                    print(dateStr)

                }
                
                // debug
                // print(lineItem!)
                let tracking = TrackingModel(date: dateStr, totalAmount: totalAmountString, pricePerGallon: pricePerGallonString)
                print(tracking)
            }
         
         }, error: {
         
         })
        
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
        
        // if this is a new object, then set defaults
        if model.id == nil {
            if trackings.count > 0 {
                model.odometerStart = trackings[0].odometerEnd
            }
            if model.date == nil {
                model.date = Date()
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let trackingDetailViewController = storyboard.instantiateViewController(withIdentifier: "TrackingDetailViewController") as! TrackingDetailViewController
        // Set the model for the details view controller
        trackingDetailViewController.tracking = model
        present(trackingDetailViewController, animated: true, completion: nil)
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
