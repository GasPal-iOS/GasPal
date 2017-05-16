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
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var toggleLoginButton: UIButton!
    
    @IBOutlet weak var emailTextbox: UITextField!
    
    @IBOutlet weak var passwordTextbox: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var isSigningUp: Bool = false

    // This says "onSignup" but it actually just toggles the toggleLoginButton text now
    @IBAction func onSignup(_ sender: Any) {
        isSigningUp = !isSigningUp
        if isSigningUp {
            loginButton.setTitle("Sign up", for: .normal)
            toggleLoginButton.setTitle("Login", for: .normal)
        } else {
            loginButton.setTitle("Login", for: .normal)
            toggleLoginButton.setTitle("Sign up", for: .normal)
        }
    }
    
    func signUp() {
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
            self.saveEmail(email: profileModel.email)
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
    }
    
    @IBAction func onLogin(_ sender: Any) {
        if isSigningUp {
            signUp()
        } else {
            login()
        }
    }
    
    func login() {
        ParseClient.sharedInstance.login(email: emailTextbox.text!, password: passwordTextbox.text!, success: { (profile) in
            print("login=success; userId=\(profile.objectId!)")
            self.statusLabel.text = ""
            self.saveEmail(email: profile.email)
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
        
        let defaults = UserDefaults.standard
        emailTextbox.text = defaults.string(forKey: "username") ?? "gaspaltest+1493707634@gmail.com"
        passwordTextbox.text = "test12"
        self.statusLabel.text = ""
        loginButton.layer.cornerRadius = 5
        loginButton.titleLabel?.numberOfLines = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveEmail(email: String?) -> () {
        if let email = email {
            let defaults = UserDefaults.standard
            defaults.set(email, forKey: "username")
            defaults.synchronize()
        }
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
