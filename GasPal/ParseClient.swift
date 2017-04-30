//
//  ParseClient.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Parse

class ParseClient: NSObject {
    
    static let sharedInstance = ParseClient()
    
    override init() {
        super.init()
        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "GasPal-Parse"
                configuration.clientKey = nil
                configuration.server = "http://gaspal-parse.herokuapp.com/parse"
            })
        )
    }
    
    func signUp(email: String!, password: String!, success: @escaping (ProfileModel) -> (), failure: @escaping (Error) -> ()) {
        let user = PFUser()
        user.email = email
        user.username = email
        user.password = password
        user.signUpInBackground { (succeeded: Bool, error: Error?) in
            if let error = error {
                print("signUp; status=failed; error=\(error.localizedDescription)")
                failure(error)
            } else {
                print("signUp; status=success; user=\(user.username!)")
                success(user as! ProfileModel)
            }
        }
    }

    func login(email: String!, password: String!, success: @escaping (ProfileModel) -> (), failure: @escaping (Error) -> ()) {
        PFUser.logInWithUsername(inBackground: email, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("login; status=failed; error=\(error.localizedDescription)")
                failure(error)
            } else {
                print("login; status=success; user=\(user!.username!)")
                success(user as! ProfileModel)
            }
        }
    }
    
    func save(profile: ProfileModel, success: @escaping (ProfileModel) -> (), failure: @escaping (Error) -> ()) {
        do {
            try profile.save()
            success(profile)
        } catch {
            let error = NSError(domain:"Error saving profile", code: 500, userInfo:nil)
            failure(error)
        }
    }
    
    func save(vehicle: VehicleModel, success: @escaping (VehicleModel) -> (), failure: @escaping (Error) -> ()) {
        vehicle.pfObject.saveInBackground { (succeeded, error) in
            if let error = error {
                print("save; status=failed; error=\(error.localizedDescription)")
                failure(error)
            } else {
                print("save; status=success; vehicleId=\(vehicle.id ?? "nil")")
                success(vehicle)
            }
        }
    }
    
    func save(tracking: TrackingModel, success: @escaping (TrackingModel) -> (), failure: @escaping (Error) -> ()) {
        tracking.pfObject.saveInBackground { (succeeded, error) in
            if let error = error {
                print("save; status=failed; error=\(error.localizedDescription)")
                failure(error)
            } else {
                print("save; status=success; trackingId=\(tracking.id ?? "nil")")
                success(tracking)
            }
        }
    }
    
    func save(service: ServiceModel, success: @escaping (ServiceModel) -> (), failure: @escaping (Error) -> ()) {
        service.pfObject.saveInBackground { (succeeded, error) in
            if let error = error {
                print("save; status=failed; error=\(error.localizedDescription)")
                failure(error)
            } else {
                print("save; status=success; serviceId=\(service.id ?? "nil")")
                success(service)
            }
        }
    }
    
    func getTrackings(vehicle: VehicleModel, success: @escaping ([TrackingModel]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: TrackingModel.className).whereKey("vehicle", equalTo: vehicle.pfObject)
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let error = error {
                print("getTrackings; status=failed; error=\(error.localizedDescription)")
                failure(error)
            } else {
                let trackings = TrackingModel.toArray(objects: results)
                print("getTrackings; status=success; total=\(trackings.count)")
                success(trackings)
            }
        }
    }
    
    func getServices(vehicle: VehicleModel, success: @escaping ([ServiceModel]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: ServiceModel.className).whereKey("vehicle", equalTo: vehicle.pfObject)
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let error = error {
                print("getServices; status=failed; error=\(error.localizedDescription)")
                failure(error)
            } else {
                let services = ServiceModel.toArray(objects: results)
                print("getServices; status=success; total=\(services.count)")
                success(services)
            }
        }
    }
    
    func getVehicles(success: @escaping ([VehicleModel]) -> (), failure: @escaping (Error) -> ()) {
        let userId = PFUser.current()!.objectId!
        let query = PFQuery(className: VehicleModel.className).whereKey("userId", equalTo: userId);
        query.findObjectsInBackground { (results, error) in
            if let error = error {
                print("getVehicles; status=failed; userId=\(userId); error=\(error.localizedDescription)")
                failure(error)
            } else {
                let vehicles = VehicleModel.toArray(objects: results)
                print("getVehicles; status=success; userId=\(userId); total=\(vehicles.count)")
                success(vehicles)
            }
        }
    }
}
