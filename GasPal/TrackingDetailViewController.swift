//
//  TrackingDetailViewController.swift
//  GasPal
//
//  Created by Luis Rocha on 5/6/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

protocol TrackingDetailViewControllerDelegate: class {
    func trackingSaved(controller: TrackingDetailViewController, savedTracking: TrackingModel)
}

class TrackingDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var tracking: TrackingModel?
    var vehicles = [VehicleModel]()
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var odometerEndTextField: UITextField!
    @IBOutlet weak var odometerStartTextField: UITextField!
    @IBOutlet weak var gallonsTextField: UITextField!
    @IBOutlet weak var unitPriceTextField: UITextField!
    @IBOutlet weak var vehiclePicker: UIPickerView!
    
    weak var delegate: TrackingDetailViewControllerDelegate?
    
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
        
        self.vehiclePicker.delegate = self
        self.vehiclePicker.dataSource = self
        
        odometerEndTextField.becomeFirstResponder()
        
        ParseClient.sharedInstance.getVehicles(success: { (vehicles: [VehicleModel]) in
            self.vehicles = vehicles
            var row = 0
            for i in 0...vehicles.count {
                if vehicles[i].id == self.tracking?.vehicleId {
                    row = i
                    break
                }
            }
            self.vehiclePicker.reloadAllComponents()
            self.vehiclePicker.selectRow(row, inComponent: 0, animated: true)
        }) { (error: Error) in
            print(error.localizedDescription)
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
        if vehicles.count > 0 {
            let vehicleRow = self.vehiclePicker.selectedRow(inComponent: 0)
            let vehicle = vehicles[vehicleRow]
            tracking?.vehicleId = vehicle.id
        }
        
        tracking?.gallons = Double(gallonsTextField.text!)
        tracking?.odometerStart = Int(odometerStartTextField.text!)
        tracking?.odometerEnd = Int(odometerEndTextField.text!)
        tracking?.unitPrice = Double(unitPriceTextField.text!)
        tracking?.calculate()
        
        ParseClient.sharedInstance.save(tracking: tracking!, success: { (tracking) in
            self.delegate?.trackingSaved(controller: self, savedTracking: tracking)
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            print("failed saving service; error=\(error.localizedDescription)")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let vehicle = vehicles[row]
        return  "\(vehicle.make ?? "") \(vehicle.model ?? "") "
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
