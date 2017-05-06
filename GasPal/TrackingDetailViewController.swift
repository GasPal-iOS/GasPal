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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
    }

    @IBAction func onSave(_ sender: UIButton) {
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
