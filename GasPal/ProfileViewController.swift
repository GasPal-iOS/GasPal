//
//  ProfileViewController.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ImageCaptureDelegate, FormCompleteDelegate {
    
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var profileView: ProfileView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileViewController")
        
        headerView.imageCaptureDelegate = self
        headerView.formCompleteDelegate = self
        
        headerView.title = "Profile"
        headerView.doShowCameraIcon = true
        headerView.doShowAddIcon = true
        
        // profile model
        profileView.image = UIImage(named: "ryan.png")
        profileView.fullNameLabel.text = "Ryan Gosling"
        profileView.addressLabel.text = "2650 Casey Av, Mountain View"
        profileView.licenceNumberLabel.text = "D5555912"
        profileView.licenseExpiryLabel.text = "06/15/2018"
        profileView.dobLabel.text = "03/10/1978"
        view.addSubview(profileView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onImageCaptured(capturedImage: UIImage) {
        OCRClient.extractData(image: capturedImage, success: { (extractedData: [String]) in
            
            print("The data", extractedData)
            
        }, error: {
            
        })
    }
    
    func onFormCompleted() {
        
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
