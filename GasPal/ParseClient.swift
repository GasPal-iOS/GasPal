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
    
    func signUp(email: String!, password: String!, success: @escaping (PFUser) -> (), failure: @escaping (Error) -> ()) {
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
                success(user)
            }
        }
    }

    func login(email: String!, password: String!, success: @escaping (PFUser) -> (), failure: @escaping (Error) -> ()) {
        PFUser.logInWithUsername(inBackground: email, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("login; status=failed; error=\(error.localizedDescription)")
                failure(error)
            } else {
                print("login; status=success; user=\(user!.username!)")
                success(user!)
            }
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
}