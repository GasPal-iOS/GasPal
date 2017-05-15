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
            vehicleInfoLabel.text = vehicle.getVehicleInfo()
            let totalMileage = vehicle.calculateTotalMileage()
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            mileageTotalLabel.text = formatter.string(for: totalMileage)
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
