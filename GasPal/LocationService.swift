//
//  LocationManager.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 5/8/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol LocationServiceDelegate: class {
    func onLocationChange(location: CLLocation)
    func onLocationChangeError(error: Error)
    @objc optional func onDidEnterGeofence(identifier: Int, location: CLLocation)
    @objc optional func onMonitoringFailed(error: Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static var sharedInstance: LocationService = LocationService()
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var currentLocationsBeingGeofenced: [CLLocation] = []
    var currentGeofences: [CLRegion] = []
    var delegates: [LocationServiceDelegate] = []

    override init()  {
        super.init()
        
        locationManager = CLLocationManager()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100 // The minimum distance (measured in meters) a device must move horizontally before an update
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
        // Clear out old geofences
        for geofence in currentGeofences {
            locationManager.stopMonitoring(for: geofence)
        }
        
        for delegate in delegates {
            delegate.onLocationChange(location: currentLocation)
        }
    }
    
    private func updateLocationDidFailWithError(error: Error) {
        for delegate in delegates {
            delegate.onLocationChangeError(error: error)
        }
    }
    
    func createGeofences(locations: [CLLocation]) {
        currentLocationsBeingGeofenced = locations
        
        var geofenceIncrementalId = 0
        for location in locations {
            let geofence = CLCircularRegion(center: location.coordinate, radius: 100, identifier: geofenceIncrementalId.description)
            geofence.notifyOnEntry = true
            locationManager.startMonitoring(for: geofence)
            geofenceIncrementalId = geofenceIncrementalId + 1
        }
        
        print("created geofences")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("did enter region?")
        if region is CLCircularRegion {
            if let geofenceId = Int(region.identifier) {
                for delegate in delegates {
                    delegate.onDidEnterGeofence?(identifier: geofenceId, location: currentLocationsBeingGeofenced[geofenceId])
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
        for delegate in delegates {
            delegate.onMonitoringFailed?(error: error)
        }
    }

}
