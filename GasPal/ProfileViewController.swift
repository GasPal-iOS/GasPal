//
//  ProfileViewController.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, ImageCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LogoutDelegate {
    
    @IBOutlet weak var headerView: Header!
    
    @IBOutlet weak var driverProfileImage: UIImageView!

    @IBOutlet weak var dlImage: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var licenseExpiryLabel: UILabel!
    @IBOutlet weak var licenseNumberLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
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

        setRounded()
        
        // save it
        let loggedInUser = ParseClient.sharedInstance.currentProfile!
        let imageData = UIImagePNGRepresentation(driverProfileImage.image!)
        loggedInUser.driverImage = PFFile(name:"image.png", data:imageData!)!
        
        ParseClient.sharedInstance.save(profile: loggedInUser, success: { (profileModel) in
            print("saved a profile model")
        }, failure: { (error) in
            print("error saving profile model")
        })
        
    }
    
    //func greet(firstName: String, lastName: String, address: String, dl: String, dob: String, exp: String, licensePic: PFFile, profilePic: PFFile) {
    func greet(profileModel: ProfileModel) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // profile model
        driverProfileImage.image = UIImage(named: "ryan.png")
        if let _firstName = profileModel.firstName {
            fullNameLabel.text = _firstName
            if let _lastName = profileModel.lastName {
                fullNameLabel.text = _firstName + " " + _lastName
            }
        }
        
        var addrString = "123 Main St. Mountain View, CA"
        if let _address = profileModel.address {
            //addressLabel.text =  _address
            addrString = _address
        }
        var licAddressString = NSMutableAttributedString()
        licAddressString = NSMutableAttributedString(string: addrString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 12.0)!])
        licAddressString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:0, length:0))
        addressLabel.attributedText = licAddressString
        
        
        var licString = "LIC123456"
        if let _license = profileModel.driverLicenseNumber {
            licString = "dl " + _license
        }
        
        var licMutableString = NSMutableAttributedString()
        licMutableString = NSMutableAttributedString(string: licString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!])
        licMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:0, length:2))
        licenseNumberLabel.attributedText = licMutableString
        
        var licExpiryString = "exp 12/01/2020"
        if let _licExpiry = profileModel.licenseExpiry {
            //licenseExpiryLabel.text = "License Expires: " + dateFormatter.string(from: _licExpiry)
            licExpiryString = "exp " + dateFormatter.string(from: _licExpiry)
        }
        
        var licExpMutableString = NSMutableAttributedString()
        licExpMutableString = NSMutableAttributedString(string: licExpiryString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!])
        licExpMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:0, length:3))
        licenseExpiryLabel.attributedText = licExpMutableString
        
        var dobStr = "dob 12/1/1980"
        if let _dob = profileModel.dateOfBirth {
            //dobLabel.text = "DOB: " + dateFormatter.string(from: _dob)
            dobStr = "dob " + dateFormatter.string(from: _dob)
        }
        
        var dobMutableString = NSMutableAttributedString()
        dobMutableString = NSMutableAttributedString(string: dobStr as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!])
        dobMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:0, length:3))
        dobLabel.attributedText = dobMutableString

        if let userPicture = profileModel.driverImage {
            userPicture.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.driverProfileImage.image = image
                    self.setRounded()
                }
            })
        }
        
        // set the DL image
        dlImage.image = UIImage(named: "drivers-license.png")
        if let dlPic = profileModel.dlImage {
            dlPic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.dlImage.image = image
                }
            })
        }
        
        setRounded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileViewController")
        
        headerView.logoutDelegate = self
     
        headerView.title = "Profile"
        headerView.doShowCameraIcon = true
        headerView.doShowLogoutButton = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Get the logged in User
        let loggedInUser = ParseClient.sharedInstance.currentProfile!

        greet(profileModel: loggedInUser)
        
        // tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        driverProfileImage.isUserInteractionEnabled = true
        driverProfileImage.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRounded() {
        driverProfileImage.layer.borderWidth = 0.3
        driverProfileImage.layer.masksToBounds = false
        driverProfileImage.layer.borderColor = UIColor.gray.cgColor
        driverProfileImage.layer.cornerRadius = driverProfileImage.frame.height/2
        driverProfileImage.clipsToBounds = true
    }
    
    func onImageCaptured(capturedImage: UIImage) {
        
        var licenseExpiry = "03/01/2020"
        var dlStr = "D5555123"
        var lastName = "Smith"
        var firstName = "Allen"
        var dobStr = "01/06/1975"
        var addrLine1 = "2650 Casey Ave"
        var addrLine2 = "Mountain View, CA 94065"
        var dobDate: Date?
        var licenseExpiryDate: Date?
        
        // set the dl
        dlImage.image = capturedImage
        
        OCRClient.extractData(image: capturedImage, success: { (extractedData: [String]) in
            
            // print("The dat/a", extractedData)
            // split each line
            var lines = extractedData.split(separator: ",")
            let line = lines.popLast()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            print("here is the dl data...")
            
            for index in 1..<line!.count-1 {
                let lineItem = line?[index]
                //print (lineItem!)
                // 1. extract expiry
                if lineItem!.range(of: "EXP") != nil {
                    let totalWords = lineItem?.components(separatedBy: " ")
                    licenseExpiry = String(totalWords![6])
                    licenseExpiryDate = dateFormatter.date(from: licenseExpiry)
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
                    dobDate = dateFormatter.date(from: dobStr)
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
            
            // Save the model
            // Get the logged in User
            let loggedInUser = ParseClient.sharedInstance.currentProfile!
            loggedInUser.firstName = firstName
            loggedInUser.lastName = lastName
            loggedInUser.address = addrLine1 + " " + addrLine2
            loggedInUser.driverLicenseNumber = dlStr
            loggedInUser.dateOfBirth = dateFormatter.date(from: dobStr)
            loggedInUser.licenseExpiry = dateFormatter.date(from: licenseExpiry)
            let imageData = UIImagePNGRepresentation(self.dlImage.image!)
            loggedInUser.dlImage = PFFile(name:"dlimage.png", data:imageData!)!
            
            ParseClient.sharedInstance.save(profile: loggedInUser, success: { (profileModel) in
                print("saved a profile model")
            }, failure: { (error) in
                print("error saving profile model")
            })
            
            self.greet(profileModel: loggedInUser)
            
            self.updateViewConstraints()
            
        }, error: {
            
        })

        
        print("Profile.onImageCaptured")
    }
    
    func onLogoutButtonTapped() {
        NotificationCenter.default.post(name: GasPalNotification.logout, object: nil)
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
