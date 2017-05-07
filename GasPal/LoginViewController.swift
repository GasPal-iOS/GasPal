//
//  LoginViewController.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailTextbox: UITextField!
    
    
    @IBOutlet weak var passwordTextbox: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!

    @IBAction func onSignup(_ sender: Any) {
        let user = PFUser()
        user.username = emailTextbox.text
        user.password = passwordTextbox.text
        user.email = emailTextbox.text
        // other fields can be set just like with PFObject
        user["phone"] = "415-392-0202"
        PFUser.registerSubclass()
        ParseClient.sharedInstance.createTestAccount(success: { (profileModel) in
            print(profileModel.email!)
            print(profileModel.password!)
            print("success signing up")
            self.statusLabel.text = ""
            self.performSegue(withIdentifier: "segueToMain", sender: nil)
        }) { (error: Error?) in
            print("error signing up")
            print(error!)
            
            self.emailTextbox.text = ""
            self.passwordTextbox.text = ""
            self.statusLabel.text = "Error signing up"
            let nsError = error! as NSError
            if 202 == nsError.code {
                self.statusLabel.text = "User already exists"
            }
        }
        
        /*
        user.signUpInBackground { (success: Bool, error: Error?) in
            if success == true {
                print("success signing up")
                self.statusLabel.text = ""
                self.performSegue(withIdentifier: "segueToMain", sender: nil)
            }
            
            if error != nil {
                print("error signing up")
                print(error!)
                
                self.emailTextbox.text = ""
                self.passwordTextbox.text = ""
                self.statusLabel.text = "Error signing up"
                let nsError = error! as NSError
                if 202 == nsError.code {
                    self.statusLabel.text = "User already exists"
                }
            }
        }
        */
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        ParseClient.sharedInstance.login(email: emailTextbox.text!, password: passwordTextbox.text!, success: { (profile) in
            print("login=success; userId=\(profile.objectId!)")
            self.statusLabel.text = ""
            
            self.performSegue(withIdentifier: "segueToMain", sender: nil)
        }) { (error) in
            print("login=failure; \(error.localizedDescription)")
            self.emailTextbox.text = ""
            self.passwordTextbox.text = ""
            self.statusLabel.text = "Error Logging In"
        }
    }
    
    
    @IBOutlet weak var onLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController")
        // pre populate with test user
        emailTextbox.text = "gaspaltest+1493707634@gmail.com"
        passwordTextbox.text = "test12"
        self.statusLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
