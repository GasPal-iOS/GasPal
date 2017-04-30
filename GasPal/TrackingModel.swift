//
//  TrackingModel.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Parse

class TrackingModel: NSObject {
    
    static let className = String(describing: TrackingModel.self)
    
    var pfObject = PFObject(className: TrackingModel.className)
    
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
            userId = _vehicle?.userId
        }
    }
    
    var userId: String? {
        get { return pfObject["userId"] as? String }
        set { pfObject["userId"] = newValue }
    }
    
    var date: Date? {
        get { return pfObject["date"] as? Date }
        set { pfObject["date"] = newValue }
    }
    
    var gallons: Double? {
        get { return pfObject["gallons"] as? Double }
        set { pfObject["gallons"] = newValue }
    }
    
    var unitPrice: Double? {
        get { return pfObject["unitPrice"] as? Double }
        set { pfObject["unitPrice"] = newValue }
    }
    
    var totalPrice: Double? {
        get { return pfObject["totalPrice"] as? Double }
        set { pfObject["totalPrice"] = newValue }
    }
    
    var odometerStart: CLong? {
        get { return pfObject["odometerStart"] as? CLong }
        set { pfObject["odometerStart"] = newValue }
    }
    
    var odometerEnd: CLong? {
        get { return pfObject["odometerEnd"] as? CLong }
        set { pfObject["odometerEnd"] = newValue }
    }
    
    var mpg: Double? {
        get { return pfObject["mpg"] as? Double }
        set { pfObject["mpg"] = newValue }
    }
    
    static func toArray (objects: [PFObject]?) -> ([TrackingModel]) {
        var items = [TrackingModel]()
        if let objects = objects {
            for pfObject in objects {
                items.append(TrackingModel(pfObject: pfObject))
            }
        }
        return items
    }
}
