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
    
    private var _vehicle: VehicleModel?
    var vehicle: VehicleModel? {
        get { return _vehicle }
        set {
            _vehicle = newValue
            pfObject["vehicle"] = newValue?.pfObject
        }
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
    
    static func toServiceArray (objects: [PFObject]?) -> ([ServiceModel]) {
        var items = [ServiceModel]()
        if let objects = objects {
            for pfObject in objects {
                items.append(ServiceModel(pfObject: pfObject))
            }
        }
        return items
    }
}
