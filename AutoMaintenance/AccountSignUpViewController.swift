//
//  AccountSignUpViewController.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/5/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit
import SQLite

class AccountSignUpViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.hideKeyboardWhenTappedAround()
        
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
        
    }
    
    
    
    
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
    

    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var birthdayTxtField: UITextField!
    @IBOutlet var usernameTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!
    
    
    
    @IBAction func cancelBTN(_ sender: Any) {
        
        do {
            print("Dropped Users Table")
            try database.run(usersTable.drop())
        } catch {
            print(error)
        }
        
        let logincancel = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
        self.navigationController?.pushViewController(logincancel, animated: true)
    }
    
    

    @IBAction func saveBTN(_ sender: Any) {
        
        // get accountID number to add below
        let accountNum =    try! database.scalar("SELECT count(*) FROM Users") as! Int64
//        UserDefaults.standard.set(accountNum+1, forKey: "myAccountNum")
        
        let insertUser = self.usersTable.insert(
            self.accountID <- accountNum + 1,
            self.name <- nameTxtField.text!,
            self.email <- emailTxtField.text!,
            self.birthday <- birthdayTxtField.text!,
            self.username <- usernameTxtField.text!,
            self.password <- passwordTxtField.text!)
        
        do {
            try self.database.run(insertUser)
            print("Inserted User")
            
           let users = try self.database.prepare(self.usersTable)
           for user in users {
                print("userID: \(user[self.id]), accountID: \(user[self.accountID]), name: \(user[self.name]), email: \(user[self.email]), birthday: \(String(describing: user[self.birthday])), username: \(user[self.username]), password: \(user[self.password])")
           }
            
        } catch {
            print(error)
        }
        
        
        let loginsave = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
        self.navigationController?.pushViewController(loginsave, animated: true)
    }
    
    
    
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
    

}
