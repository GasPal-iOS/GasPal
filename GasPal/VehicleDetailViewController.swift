//
//  VehicleDetailViewController.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 5/6/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

protocol VehicleDetailViewControllerDelegate: class {
    func vehicleSaved(controller: VehicleDetailViewController, savedVehicle: VehicleModel)
}

class VehicleDetailViewController: UIViewController {
    
    @IBOutlet weak var yearInput: UITextField!
    @IBOutlet weak var makeInput: UITextField!
    @IBOutlet weak var modelInput: UITextField!
    @IBOutlet weak var vinInput: UITextField!
    
    weak var delegate: VehicleDetailViewControllerDelegate?
    
    var vehicle: VehicleModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        yearInput.keyboardType = .numberPad
        yearInput.layer.borderWidth = 1.0
        makeInput.layer.borderWidth = 1.0
        modelInput.layer.borderWidth = 1.0
        vinInput.layer.borderWidth = 1.0
        
        if let vehicle = vehicle {
            yearInput.text = vehicle.year?.description
            makeInput.text = vehicle.make
            modelInput.text = vehicle.model
            vinInput.text = vehicle.vin
        } else {
            vehicle = VehicleModel()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveTap(_ sender: Any) {
        let valid = validateInputs()
        
        if !valid {
            return
        }

        vehicle.year = Int(yearInput.text!)
        vehicle.make = makeInput.text
        vehicle.model = modelInput.text
        vehicle.vin = vinInput.text
        
        ParseClient.sharedInstance.save(vehicle: vehicle, success: { (savedVehicle: VehicleModel) in
            self.delegate?.vehicleSaved(controller: self, savedVehicle: savedVehicle)
            self.dismiss(animated: true, completion: nil)
        }) { (Error) in
            print("ERROR SAVING VEHICLE")
        }
    }
    
    func validateInputs() -> Bool {
        var valid = true
        
        if yearInput.text == nil || yearInput.text?.characters.count == 0 {
            valid = false
            yearInput.layer.borderColor = UIColor.red.cgColor
        } else {
            yearInput.layer.borderColor = UIColor.gray.cgColor
        }
        
        if makeInput.text == nil || makeInput.text?.characters.count == 0 {
            valid = false
            makeInput.layer.borderColor = UIColor.red.cgColor
        } else {
            makeInput.layer.borderColor = UIColor.gray.cgColor
        }
        
        if modelInput.text == nil || modelInput.text?.characters.count == 0 {
            valid = false
            modelInput.layer.borderColor = UIColor.red.cgColor
        } else {
            modelInput.layer.borderColor = UIColor.gray.cgColor
        }
        
        if vinInput.text == nil || vinInput.text?.characters.count == 0 {
            valid = false
            vinInput.layer.borderColor = UIColor.red.cgColor
        } else {
            vinInput.layer.borderColor = UIColor.gray.cgColor
        }
        
        return valid
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
