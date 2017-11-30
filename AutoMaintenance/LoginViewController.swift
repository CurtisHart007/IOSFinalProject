//
//  LoginViewController.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/5/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit
import SQLite

class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite 3")
            
            // saves everything to that file
            let database = try Connection(fileURL.path)
            // set this database to global database
            self.database = database
        } catch {
            print(error)
        }
    }
    
    

    var database: Connection!
    
    @IBOutlet var usernameTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!
    
    
    
    @IBAction func loginBtn(_ sender: Any) {
//        // used to automatic login
//        usernameTxtField.text = "test"
//        passwordTxtField.text = "test "
        
        let username = usernameTxtField.text!
        let usernameDB =    try! database.scalar("SELECT username FROM Users WHERE username = '\(username)'") as? String
        let passwordDB =    try! database.scalar("SELECT password FROM Users WHERE username = '\(username)'") as? String
        let accountIDDB =    try! database.scalar("SELECT accountID FROM Users WHERE username = '\(username)'") as? Int64
        
        print(accountIDDB)
        
        UserDefaults.standard.set(accountIDDB, forKey: "myAccountNum")
        /* username in DB */    print(usernameDB)
        /* password in DB */    print(passwordDB)
        
        // test if username and password match Database
        if usernameTxtField.text == usernameDB && passwordTxtField.text == passwordDB {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "loginSuccess") as! ContainerVC
            UserDefaults.standard.set(usernameTxtField.text, forKey: "myUsername")
            self.present(home, animated: true, completion: nil)
        }
        
        // Password doesn't match Username
        if usernameTxtField.text == usernameDB {
            let alert = UIAlertController(title: "Alert", message: "Password Does Not Match Username", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "Username Does Not Exist", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    @IBAction func resetPasswordBtn(_ sender: Any) {
         self.performSegue(withIdentifier: "resetpassword", sender: self)
    }
    
    
    
    
    @IBAction func signupBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "signup", sender: self)
    }
    

}
