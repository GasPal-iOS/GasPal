//
//  TrackingDetailViewController.swift
//  GasPal
//
//  Created by Luis Rocha on 5/6/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class TrackingDetailViewController: UIViewController {

    var tracking: TrackingModel?
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var odometerEndTextField: UITextField!
    @IBOutlet weak var odometerStartTextField: UITextField!
    @IBOutlet weak var gallonsTextField: UITextField!
    @IBOutlet weak var unitPriceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tracking = tracking {

            if let date = tracking.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, YYYY"
                dateTextField.text = formatter.string(from: date)
            }
            if let odometer = tracking.odometerEnd {
                let formatter = NumberFormatter()
                formatter.usesGroupingSeparator = true
                formatter.groupingSeparator = ","
                odometerEndTextField.text = formatter.string(for: odometer)
            }
            if let odometer = tracking.odometerStart {
                let formatter = NumberFormatter()
                formatter.usesGroupingSeparator = true
                formatter.groupingSeparator = ","
                odometerStartTextField.text = formatter.string(for: odometer)
            }
            if let gallons = tracking.gallons {
                gallonsTextField.text = String.init(format: "%.3f", gallons)
            }
            if let unitPrice = tracking.unitPrice {
                unitPriceTextField.text = String.init(format: "%.2f", unitPrice)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSave(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
