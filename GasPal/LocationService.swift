//
//  LocationManager.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 5/8/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationServiceDelegate: class {
    func onLocationChange(location: CLLocation)
    func onLocationChangeError(error: Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static var sharedInstance: LocationService = LocationService()
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    weak var delegate: LocationServiceDelegate?

    override init()  {
        super.init()
        
        locationManager = CLLocationManager()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
    }
    
    func initialize() {
        // Entering this function kicks off the above init method
        print("Initializing location service...")
    }
    
    // CLLocationManagerDelegate - Success
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        self.currentLocation = location
        
        updateLocation(currentLocation: location)
    }
    
    // CLLocationManagerDelegate - Failure
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        updateLocationDidFailWithError(error: error)
    }
    
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.onLocationChange(location: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: Error) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.onLocationChangeError(error: error)
    }

}
