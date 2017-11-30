//
//  ProfileViewController.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/17/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit
import SQLite

class ProfileViewController: UIViewController, UITabBarDelegate {
    
    var myUsername: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        becomeFirstResponder()
        createDatePicker()          // calls createDatePicker function
        
        
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
        
        createUserTable()
        
        // Hide Keyboard when click away
        self.hideKeyboardWhenTappedAround()
        
        self.tabBar.delegate = self as UITabBarDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "myUsername") as? String {
            myUsername = x
            loadProfileDetails()
        }
    }
    
    
        // Side Menu
    @IBAction func menuBTN(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }

    
    @IBOutlet var fullnameTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var accountNumTxtField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var birthdayTextField: UITextField!
    

    
    var database: Connection!
    let usersTable = Table("Users")
    
    // database columns
    let id = Expression<Int>("id")
    let accountID = Expression<Int64>("accountID")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    let birthday = Expression<String?>("birthday")      // optional string
    let username = Expression<String>("username")
    let password = Expression<String>("password")
    
    func createUserTable() {
        print("Create User Table")
        
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.accountID)
            table.column(self.name)
            table.column(self.email, unique: true)
            table.column(self.birthday)
            table.column(self.username, unique: true)
            table.column(self.password)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Users Table")
        } catch {
            print(error)
        }
    }
    
    
    
    func loadProfileDetails() {

        let username = myUsername

        let accountNumberDB =    try! database.scalar("SELECT accountID FROM Users WHERE username = '\(username)'") as? Int64
        let nameDB =    try! database.scalar("SELECT name FROM Users WHERE username = '\(username)'") as? String
        let emailDB =    try! database.scalar("SELECT email FROM Users WHERE username = '\(username)'") as? String
        let birthdayDB =    try! database.scalar("SELECT birthday FROM Users WHERE username = '\(username)'") as? String
        
        let x : Int64 = accountNumberDB!
        let myAccountNum = String(x)
        
        fullnameTextField.text = nameDB
        usernameTextField.text = username
        accountNumTxtField.text = myAccountNum
        emailTextField.text = emailDB
        birthdayTextField.text = birthdayDB
    }
    
    
    
    @IBAction func updateBTN(_ sender: Any) {
        let usernames = myUsername
        
        let nameDB =    try! database.scalar("SELECT name FROM Users WHERE username = '\(usernames)'") as? String
        let usernameDB = usernames
        let emailDB =    try! database.scalar("SELECT email FROM Users WHERE username = '\(usernames)'") as? String
        let birthdayDB =    try! database.scalar("SELECT birthday FROM Users WHERE username = '\(usernames)'") as? String
        
        do {
            let alice = usersTable.filter(username == usernameDB)
            
            try self.database.run(alice.update(name <- name.replace(nameDB!, with: (fullnameTextField.text)!)))
            try self.database.run(alice.update(username <- username.replace(usernameDB, with: (usernameTextField.text)!)))
            try self.database.run(alice.update(email <- email.replace(emailDB!, with: (emailTextField.text)!)))
            try self.database.run(alice.update(birthday <- birthday.replace(birthdayDB!, with: (birthdayTextField.text)!)))
            
        } catch {
            print(error)
        }
        
        let alert = UIAlertController(title: "Alert", message: "Profile information has been updated", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
        // Allows users to edit Fields
    @IBAction func editBTN(_ sender: Any) {
        fullnameTextField.isUserInteractionEnabled = true
        usernameTextField.isUserInteractionEnabled = true
        emailTextField.isUserInteractionEnabled = true
        birthdayTextField.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: "Alert", message: "User Can Now Edit Name, Username, Email & Birthday", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
  



    
    
    let picker = UIDatePicker()
    
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = picker
        
        // format picker for date
        picker.datePickerMode = .date
    }
    
        // done Button Pressed when datePicker is selected
    @objc func donePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        birthdayTextField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    
    
    
    
    @IBOutlet var tabBar: UITabBar!
    
        // Selecting Tab Bar
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 0) {
            // Send User to Home Page
            let home = self.storyboard?.instantiateViewController(withIdentifier: "loginSuccess") as! ContainerVC
            self.present(home, animated: true, completion: nil)
        }
        else if (item.tag == 1) {
            // Log User out and Send User to Login Page
            let login = self.storyboard?.instantiateViewController(withIdentifier: "logNav")
            self.present(login!, animated: true, completion: nil)
            
        }
    }
    
    
}
