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
        let user = ProfileModel()
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
    
    func getTrackings(success: @escaping ([TrackingModel]) -> (), failure: @escaping (Error) -> ()) {
        let userId = PFUser.current()!.objectId!
        let query = PFQuery(className: TrackingModel.className).whereKey("userId", equalTo: userId).order(byDescending: "date")
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let error = error {
                print("getTrackings; status=failed; userId=\(userId); error=\(error.localizedDescription)")
                failure(error)
            } else {
                let trackings = TrackingModel.toArray(objects: results)
                print("getTrackings; status=success; userId=\(userId); total=\(trackings.count)")
                success(trackings)
            }
        }
    }
    
    func getTrackings(vehicle: VehicleModel, success: @escaping ([TrackingModel]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: TrackingModel.className).whereKey("vehicle", equalTo: vehicle.pfObject).order(byDescending: "date")
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
    
    func getServices(success: @escaping ([ServiceModel]) -> (), failure: @escaping (Error) -> ()) {
        let userId = PFUser.current()!.objectId!
        let query = PFQuery(className: ServiceModel.className).whereKey("userId", equalTo: userId).order(byDescending: "serviceDate")
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let error = error {
                print("getServices; status=failed; userId=\(userId); error=\(error.localizedDescription)")
                failure(error)
            } else {
                let services = ServiceModel.toArray(objects: results)
                print("getServices; status=success; userId=\(userId); total=\(services.count)")
                success(services)
            }
        }
    }
    
    func getServices(vehicle: VehicleModel, success: @escaping ([ServiceModel]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: ServiceModel.className).whereKey("vehicle", equalTo: vehicle.pfObject).order(byDescending: "serviceDate")
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
    
    func createTestAccount(success: @escaping (ProfileModel) -> (), failure: @escaping (Error) -> ()) {
        // Create test user
        let now = lround(Date().timeIntervalSince1970)
        signUp(email: "gaspaltest+\(now)@gmail.com", password: "test12", success: { (profile) in
            
            profile.dateOfBirth = Calendar.current.date(byAdding: .year, value: -27, to: Date())
            profile.driverLicenseNumber = "D\(now)"
            profile.firstName = "Joe"
            profile.lastName = "Doe"
            self.save(profile: profile, success: { (profile) in
            }, failure: { (error) in
            })
            
            let vehicle = VehicleModel()
            vehicle.make = "Audi"
            vehicle.model = "A3"
            vehicle.year = 2011
            vehicle.vin = "1FMDK06W89GA52368"
            
            // Create vehicle
            self.save(vehicle: vehicle, success: { (vehicle) in
                print(vehicle.id ?? "nil")
                
                var start = 20000 as Int
                for i in 0 ... 24 {
                    let tracking = TrackingModel()
                    tracking.date = Calendar.current.date(byAdding: .month, value: i - 24, to: Date())
                    tracking.gallons = 12.800 + Double(i) / 100
                    tracking.odometerStart = start
                    tracking.odometerEnd = tracking.odometerStart! + (500 + i)
                    start = tracking.odometerEnd!
                    tracking.unitPrice = 2.899 - Double(i)/100
                    tracking.calculate()
                    tracking.vehicle = vehicle
                    
                    // Create fuel tracking
                    self.save(tracking: tracking, success: { (tracking) in
                        
                    }) { (error) in
                        print("createTestAccount=failure; \(error.localizedDescription)")
                    }
                }
                
                let descriptions = ["Oil Change", "Scheduled Maintenance", "Tires Rotation", "Brakes Checkup", "Engine Tunning", "Battery Repacement"]
                let stations = ["Audi Palo Alto", "AJ Mechanical", "Audi Stevens Creek", "Jon's Auto Repair", "Audi San Jose", "GasPal Auto Center"]
                for i in 0 ... 24 {
                    let service = ServiceModel()
                    service.serviceDate = Calendar.current.date(byAdding: .month, value: -4*i, to: Date())
                    service.serviceDescription = descriptions[i % descriptions.count]
                    service.price = 100.0 + Double(10 * i)
                    service.stationName = stations[i % descriptions.count]
                    service.vehicle = vehicle
                    
                    self.save(service: service, success: { (tracking) in
                        print(vehicle.id ?? "nil")
                    }) { (error) in
                        print("createTestAccount=failure; \(error.localizedDescription)")
                    }
                }
                print("createTestAccount=success; user=\(profile.username!)")
                success(profile)
                
            }, failure: { (error) in
                print("createTestAccount=failure; \(error.localizedDescription)")
                failure(error)
            })
            
        }) { (error) in
            print("createTestAccount=failure; \(error.localizedDescription)")
            failure(error)
        }
    }
}
