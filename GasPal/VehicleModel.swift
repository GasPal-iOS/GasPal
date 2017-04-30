//
//  VehicleModel.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Parse

class VehicleModel: NSObject {

    var pfObject = PFObject(className: "VehicleModel")
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
    }
    
    override init() {
        super.init()
    }
    
    var id: String? {
        get { return pfObject.objectId }
        set { pfObject.objectId = id }
    }
    
    var year: Int? {
        get { return pfObject["year"] as? Int }
        set { pfObject["year"] = newValue }
    }
    
    var make: String? {
        get { return pfObject["make"] as? String }
        set { pfObject["make"] = newValue }
    }
    
    var model: String? {
        get { return pfObject["model"] as? String }
        set { pfObject["model"] = newValue }
    }
    
    var vin: String? {
        get { return pfObject["vin"] as? String }
        set { pfObject["vin"] = newValue }
    }
}
