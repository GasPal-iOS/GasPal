//
//  VehicleTableCell.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 4/30/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class VehicleTableCell: UITableViewCell {
    
    @IBOutlet weak var vehicleInfoLabel: UILabel!
    @IBOutlet weak var mileageTotalLabel: UILabel!
    @IBOutlet weak var vinLabel: UILabel!
    
    var vehicle: VehicleModel! {
        didSet {
            let year = vehicle.year?.description ?? ""
            let make = vehicle.make ?? ""
            let model = vehicle.model ?? ""
            vehicleInfoLabel.text = "\(year) \(make) \(model)"
            let totalMileage = vehicle.calculateTotalMileage()
            mileageTotalLabel.text = totalMileage.description
            vinLabel.text = vehicle.vin
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
