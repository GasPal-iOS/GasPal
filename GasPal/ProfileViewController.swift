//
//  ProfileViewController.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ImageCaptureDelegate, AddIconDelegate {
    
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var profileView: ProfileView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileViewController")
        
        headerView.imageCaptureDelegate = self
        headerView.addIconDelegate = self
     
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
        
        var licenseExpiry = "03/01/2020"
        
        OCRClient.extractData(image: capturedImage, success: { (extractedData: [String]) in
            
            // print("The dat/a", extractedData)
            // split each line
            var lines = extractedData.split(separator: ",")
            let line = lines.popLast()
            
            for index in 1..<line!.count-1 {
                let lineItem = line?[index]
                print (lineItem!)
                // 1. extract expiry
                if lineItem!.range(of: "EXPIRES") != nil {
                    let totalWords = lineItem?.components(separatedBy: " ")
                    licenseExpiry = String(totalWords![1])
                }

            }
            
        }, error: {
            
        })

        
        print("Profile.onImageCaptured")
        //profileView.image = capturedImage
        //self.reloadInputViews()
    }
    
    func onAddIconTapped() {
        
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
