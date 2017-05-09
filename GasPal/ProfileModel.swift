//
//  ProfileModel.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Parse

class ProfileModel: PFUser {

    /*
    var driverImage: PFFile? {
        get { return self["driverImage"] as? PFFile }
        set { self["driverImage"] = newValue }
    }
    */
    
    var dateOfBirth: Date? {
        get { return self["dateOfBirth"] as? Date }
        set { self["dateOfBirth"] = newValue }
    }
    
    var driverLicenseNumber: String? {
        get { return self["driverLicenseNumber"] as? String }
        set { self["driverLicenseNumber"] = newValue }
    }
    
    var firstName: String? {
        get { return self["firstName"] as? String }
        set { self["firstName"] = newValue }
    }
    
    var lastName: String? {
        get { return self["lastName"] as? String }
        set { self["lastName"] = newValue }
    }
    
    var licenseExpiry: Date? {
        get { return self["licenseExpiry"] as? Date }
        set { self["licenseExpiry"] = newValue }
    }
    
    var address: String? {
        get { return self["address"] as? String }
        set { self["address"] = newValue }
    }
    
    
}
