//
//  ServiceDetailViewController.swift
//  GasPal
//
//  Created by Luis Rocha on 5/7/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var service: ServiceModel?
    var vehicles = [VehicleModel]()
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var stationTextField: UITextField!
    @IBOutlet weak var serviceDescriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var vehiclePicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let service = service {
            if let date = service.serviceDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, YYYY"
                dateTextField.text = formatter.string(from: date)
            }
            if let price = service.price {
                priceTextField.text = String.init(format: "%.2f", price)
            }
            stationTextField.text = service.stationName
            serviceDescriptionTextField.text = service.serviceDescription
        }

        self.vehiclePicker.delegate = self
        self.vehiclePicker.dataSource = self

        ParseClient.sharedInstance.getVehicles(success: { (vehicles: [VehicleModel]) in
            self.vehicles = vehicles
            var row = 0
            for i in 0...vehicles.count {
                if vehicles[i].id == self.service?.vehicleId {
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
            service?.vehicleId = vehicle.id
        }
        
        service?.stationName = stationTextField.text!
        service?.serviceDescription = serviceDescriptionTextField.text!
        service?.price = Double(priceTextField.text!)
        
        ParseClient.sharedInstance.save(service: service!, success: { (service) in
            //
        }) { (error) in
            //
        }
        dismiss(animated: true, completion: nil)
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
