//
//  MainViewController.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 4/29/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, LocationServiceDelegate {
    
    @IBOutlet var contentView: UIView!
    
    var mainStoryboard: UIStoryboard!
    
    var imageCaptureOrigin: String!
    
    var contentViewController: UITabBarController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationObservers()

        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        contentViewController = tabBarController
        
        // Fetch the data we need
        ParseClient.sharedInstance.getTrackings(success: { (trackings: [TrackingModel]) in
            
        }) { (error) in
            
        }
        
        // Initialize user's location
        LocationService.sharedInstance.delegate = self
        LocationService.sharedInstance.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initNavigationObservers() {
        NotificationCenter.default.addObserver(forName: GasPalNotification.openCamera, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            
            self.imageCaptureOrigin = notification.userInfo?["origin"] as! String
            self.displayCamera()
            
        }
        
        NotificationCenter.default.addObserver(forName: GasPalNotification.logout, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func displayCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.dismiss(animated: true) {
            
            let currentVC = self.contentViewController.selectedViewController as? ImageCaptureDelegate
            currentVC?.onImageCaptured(capturedImage: image)
            
        }
    }
    
    func onLocationChange(location: CLLocation) {
        print("location: ", location)
        let ll = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        FourSquareClient.sharedInstance.fetchLocations("Gas stations", ll: ll, limit: 10, llAcc: 500.0, success: { (results: [NSDictionary]) in
            // Geofence nearby gas stations to send user a push notification when they come within range
            var geofenceLocations = [CLLocation]()
            for station in results {
                let location = station["location"] as? NSDictionary
                let latitude = location?["lat"] as? CLLocationDegrees
                let longitude = location?["lng"] as? CLLocationDegrees
                if let latitude = latitude, let longitude = longitude {
                    let cllocation = CLLocation(latitude: latitude, longitude: longitude)
                    geofenceLocations.append(cllocation)
                }
            }
            LocationService.sharedInstance.createGeofences(locations: geofenceLocations)
        }) { (error: Error) in
            
        }
    }
    
    func onLocationChangeError(error: Error) {
        print("location error: ", error.localizedDescription)
    }
    
    func onDidEnterGeofence(location: CLLocation) {
        
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
