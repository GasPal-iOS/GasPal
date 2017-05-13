//
//  GasPriceModel
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Parse

class GasPriceModel: NSObject {
    
    static let className = String(describing: GasPriceModel.self)
    
    var pfObject = PFObject(className: GasPriceModel.className)
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
    }
    
    override init() {
        super.init()
    }
    
    
    init(fuelType: String, price: String) {
        super.init()
        self.fuelType = fuelType
        self.price = price
    }

    var fuelType: String? {
        get { return pfObject["fuelType"] as? String }
        set { pfObject["fuelType"] = newValue }
    }
    
    var price: String? {
        get { return pfObject["price"] as? String }
        set { pfObject["price"] = newValue }
    }
    
    static func toModel (objects: [PFObject]?) -> (GasPriceModel) {
        var item = GasPriceModel()
        if let objects = objects {
            for pfObject in objects {
                item = GasPriceModel(pfObject: pfObject)
            }
        }
        return item
    }
    
}

