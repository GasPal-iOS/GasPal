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

    static let className = String(describing: ServiceModel.self)
    
    var pfObject = PFObject(className: ServiceModel.className)
    
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
    
    var userId: String? {
        get { return pfObject["userId"] as? String }
        set { pfObject["userId"] = newValue }
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
    
    static func toArray (objects: [PFObject]?) -> ([ServiceModel]) {
        var items = [ServiceModel]()
        if let objects = objects {
            for pfObject in objects {
                items.append(ServiceModel(pfObject: pfObject))
            }
        }
        return items
    }
}
