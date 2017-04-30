//
//  TrackingCell.swift
//  GasPal
//
//  Created by Luis Rocha on 4/29/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class TrackingCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var odometerLabel: UILabel!
    @IBOutlet weak var gallonsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var mpgLabel: UILabel!
    
    var tracking: TrackingModel! {
        didSet {
            if let date = tracking.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, YYYY"
                dateLabel.text = formatter.string(from: date)
            }
            if let odometer = tracking.odometerEnd {
                let formatter = NumberFormatter()
                formatter.usesGroupingSeparator = true
                formatter.groupingSeparator = ","
                odometerLabel.text = formatter.string(for: odometer)
            }
            if let gallons = tracking.gallons {
                gallonsLabel.text = String.init(format: "%.3f", gallons)
            }
            if let totalPrice = tracking.totalPrice {
                totalPriceLabel.text = String.init(format: "$%.2f", totalPrice)
            }
            if let mpg = tracking.mpg {
                mpgLabel.text = String.init(format: "%.1f", mpg)
            }
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
