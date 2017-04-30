//
//  ServiceModel.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Parse

class ServiceModel: NSObject {

    var pfObject = PFObject(className: "ServiceModel")
    
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
    
    var vehicleId: String? {
        get { return pfObject["vehicleId"] as? String }
        set { pfObject["vehicleId"] = newValue }
    }
    
    var serviceDate: Date? {
        get { return pfObject["serviceDate"] as? Date }
        set { pfObject["serviceDate"] = newValue }
    }
    
    var stationName: String? {
        get { return pfObject["stationName"] as? String }
        set { pfObject["stationName"] = newValue }
    }
    
    var serviceDescription: String? {
        get { return pfObject["serviceDescription"] as? String }
        set { pfObject["serviceDescription"] = newValue }
    }
    
    var price: Double? {
        get { return pfObject["price"] as? Double }
        set { pfObject["price"] = newValue }
    }
}
