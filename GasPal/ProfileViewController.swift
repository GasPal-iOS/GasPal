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

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileViewController")
        
        headerView.imageCaptureDelegate = self
        headerView.formCompleteDelegate = self
        
        headerView.title = "Profile"
        headerView.doShowCameraIcon = true
        headerView.doShowAddIcon = true
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
