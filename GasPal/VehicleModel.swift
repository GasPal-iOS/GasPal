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

    static let className = String(describing: VehicleModel.self)
    
    var pfObject = PFObject(className: VehicleModel.className)
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
    }
    
    override init() {
        super.init()
        userId = PFUser.current()?.objectId
    }
    
    var id: String? {
        get { return pfObject.objectId }
        set { pfObject.objectId = id }
    }
    
    var userId: String? {
        get { return pfObject["userId"] as? String }
        set { pfObject["userId"] = newValue }
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
    
    static func toArray (objects: [PFObject]?) -> ([VehicleModel]) {
        var items = [VehicleModel]()
        if let objects = objects {
            for pfObject in objects {
                items.append(VehicleModel(pfObject: pfObject))
            }
        }
        return items
    }
}
