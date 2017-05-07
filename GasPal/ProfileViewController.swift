//
//  ProfileViewController.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ImageCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//, AddIconDelegate {
    
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var profileView: ProfileView!
    
    
    @IBOutlet weak var driverProfileImage: UIImageView!
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("onTap")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(vc, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            driverProfileImage.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            driverProfileImage.image = image
        } else {
            driverProfileImage.image = nil
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileViewController")
        
        //headerView.addIconDelegate = self
     
        headerView.title = "Profile"
        headerView.doShowCameraIcon = true
        //headerView.doShowAddIcon = true
        
        // profile model
        driverProfileImage.image = UIImage(named: "ryan.png")
        profileView.fullNameLabel.text = "Ryan Gosling"
        profileView.addressLabel.text = "2650 Casey Av, Mountain View"
        profileView.licenceNumberLabel.text = "D5555912"
        profileView.licenseExpiryLabel.text = "06/15/2018"
        profileView.dobLabel.text = "03/10/1978"
        
        // tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        driverProfileImage.isUserInteractionEnabled = true
        driverProfileImage.addGestureRecognizer(tapGestureRecognizer)
        
        //view.addSubview(profileView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onImageCaptured(capturedImage: UIImage) {
        
        var licenseExpiry = "03/01/2020"
        var dlStr = "D5555123"
        var lastName = "Smith"
        var firstName = "Allen"
        var dobStr = "01/06/1975"
        var addrLine1 = "2650 Casey Ave"
        var addrLine2 = "Mountain View, CA 94065"
        
        OCRClient.extractData(image: capturedImage, success: { (extractedData: [String]) in
            
            // print("The dat/a", extractedData)
            // split each line
            var lines = extractedData.split(separator: ",")
            let line = lines.popLast()
            
            print("here is the dl data...")
            
            for index in 1..<line!.count-1 {
                let lineItem = line?[index]
                //print (lineItem!)
                // 1. extract expiry
                if lineItem!.range(of: "EXP") != nil {
                    let totalWords = lineItem?.components(separatedBy: " ")
                    licenseExpiry = String(totalWords![6])
                }
                
                // 2. DL
                if lineItem!.range(of: "DL") != nil {
                    print(lineItem!)
                    let totalWords = lineItem?.components(separatedBy: " ")
                    dlStr = String(totalWords![5])
                }
                
                // 4. Last Name
                if lineItem!.range(of: "LN") != nil {
                    print(lineItem!)
                    let totalWords = lineItem?.components(separatedBy: " ")
                    lastName = String(totalWords![4])
                    lastName = lastName.replacingOccurrences(of: "LN", with: "")
                }
                
                // 4. First Name
                if lineItem!.range(of: "FN") != nil {
                    let totalWords = lineItem?.components(separatedBy: " ")
                    firstName = String(totalWords![4])
                }

                // 4. DOB
                if lineItem!.range(of: "DOB") != nil {
                    let totalWords = lineItem?.components(separatedBy: " ")
                    dobStr = String(totalWords![5])
                }
                
                // Line 8 is address line 1
                if index == 8 {
                    //addrLine1 = lineItem!
                    let totalWords = lineItem?.components(separatedBy: " ")
                    addrLine1 = String(totalWords![3]) + " " + String(totalWords![4]) + " " + String(totalWords![5])
                }
                
                // Line 9 is address line 2
                if index == 9 {
                    let totalWords = lineItem?.components(separatedBy: " ")
                    addrLine2 = String(totalWords![3]) + " " + String(totalWords![4]) + " " + String(totalWords![5])
                }
            }
            
            // all scanned
            print("scanned data..")
            print(firstName)
            print(lastName)
            print(licenseExpiry)
            print(dobStr)
            print(dlStr)
            print(addrLine1)
            print(addrLine2)
            
            // update UI
            self.profileView.fullNameLabel.text = "Name: " + firstName + " " + lastName
            self.profileView.addressLabel.text = "Address: " + addrLine1 + addrLine2
            self.profileView.licenceNumberLabel.text = "DL: " + dlStr
            self.profileView.licenseExpiryLabel.text = "Expires: " + licenseExpiry
            self.profileView.dobLabel.text = "DOB: " + dobStr
            
            self.updateViewConstraints()
            
        }, error: {
            
        })

        
        print("Profile.onImageCaptured")
    }
    
    /*
    func onAddIconTapped() {
        
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
