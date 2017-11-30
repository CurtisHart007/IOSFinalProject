//
//  FutureViewController.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/26/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit
import SQLite

class FutureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate {

    var myUsername: String = ""
    var myAccountNum: Int64 = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        becomeFirstResponder()
        createDatePicker()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("services").appendingPathExtension("sqlite 3")
            
            // saves everything to that file
            let database = try Connection(fileURL.path)
            // set this database to global database
            self.database = database
        } catch {
            print(error)
        }
        
        createServiceTable()
        
        self.serviceTableView.isHidden = true               // hides Service Type Table view onLoad
        self.hideKeyboardWhenTappedAround()                 // hides keyboard when click away
        self.tabBar.delegate = self as UITabBarDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "myUsername") as? String {
            myUsername = x
        }
        
        if let y = UserDefaults.standard.object(forKey: "myAccountNum") as? Int64 {
            myAccountNum = y
        }
    }
    
    
    let array = ["Gas Refill", "Oil Change", "Tire Rotation", "Tire Repair", "Tire Installation", "* Other"]
    
    @IBOutlet var serviceTypeBTN: UIButton!
    @IBOutlet var otherTextField: UITextField!
    
    @IBOutlet var datePicker: UITextField!
    @IBOutlet var mileageTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var costTextField: UITextField!
    
    let picker = UIDatePicker()
    
    
    
    // Side Menu
    @IBAction func menuBTN(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    
    var database: Connection!
    let servicesTable = Table("Services")
    
    // database columns
    let serviceID = Expression<Int>("serviceID")
    let accountID = Expression<Int64>("accountID")
    let typeName = Expression<String>("typeName")
    let otherName = Expression<String?>("otherName")
    
    let date = Expression<String>("date")
    let mileage = Expression<String>("mileage")
    let company = Expression<String>("company")
    let cost = Expression<String>("cost")
    let status = Expression<String>("status")
    
    
    @IBAction func saveBTN(_ sender: Any) {
        
        let open:String = "Open"
        
        let accountNumberDB = myAccountNum
        
        if ((datePicker.text?.isEmpty)! || (mileageTextField.text?.isEmpty)! || companyTextField.text!.isEmpty || costTextField.text!.isEmpty) {
            
            let alert = UIAlertController(title: "Alert", message: "Service Type, Date, Mileage, Company & Cost CANNOT be blank", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            
            let insertService = self.servicesTable.insert(
                self.accountID <- accountNumberDB,
                self.typeName <- serviceTypeBTN.titleLabel!.text!,
                self.otherName <- otherTextField.text!,
                
                self.date <- datePicker.text!,
                self.mileage <- mileageTextField.text!,
                self.company <- companyTextField.text!,
                self.cost <- costTextField.text!,
                self.status <- open)
            
            do {
                try self.database.run(insertService)
                print("Inserted New Service Entry")
                
                let services = try self.database.prepare(self.servicesTable)
                for service in services {
                    print("serviceID: \(service[self.serviceID]), accountID: \(service[self.accountID]), typeName: \(service[self.typeName]), otherName: \(String(describing: service[self.otherName])), date: \(service[self.date]), mileage: \(service[self.mileage]), company: \(service[self.company]), cost: \(service[self.cost]), status: \(service[self.status])")
                }
                
                let alert = UIAlertController(title: "Alert", message: "Services has been Added", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                loadTextFields()
                
                
            } catch {
                print(error)
            }
            
            
        }
    }
    
    
    
    @IBAction func clearEntry(_ sender: Any) {
        
        loadTextFields()
        
    }
    
    
    
    func loadTextFields() {
       serviceTypeBTN.setTitle("", for: .normal)
       otherTextField.text = ""
       datePicker.text = ""
       mileageTextField.text = ""
       companyTextField.text = ""
       costTextField.text = ""
        
    }
    
    
    
    
    
    func createServiceTable() {
        print("Create Services Table")
        
        let createTable = self.servicesTable.create { (table) in
            table.column(self.serviceID, primaryKey: true)
            table.column(self.accountID)
            table.column(self.typeName)
            table.column(self.otherName)
            table.column(self.date)
            table.column(self.mileage)
            table.column(self.company)
            table.column(self.cost)
            table.column(self.status)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Services Table")
        } catch {
            print(error)
        }
    }
    
    
    
    
    
    @IBAction func serviceTypePressed(_ sender: Any) {
        // hiding and unhiding table view
        self.serviceTableView.isHidden = !self.serviceTableView.isHidden
    }
    
    @IBOutlet var serviceTableView: UITableView!
    
    // TableView numberOfSections At for Service Type
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // TableView numberOfRowsInSection At for Service Type
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    // TableView cellForRowAt At for Service Type
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    // TableView didSelectRowAt At for Service Type
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        serviceTypeBTN.setTitle(cell?.textLabel?.text, for: .normal)
        self.serviceTableView.isHidden = true
    }
    
    
    
    
    
    
    
    
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        datePicker.inputAccessoryView = toolbar
        datePicker.inputView = picker
        
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
        
        datePicker.text = "\(dateString)"
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
    
    
    
    //    @IBOutlet var imageView: UIImageView!
    
    
    
    //    @IBAction func chooseImage(_ sender: Any) {
    //
    //        let imagePickerController = UIImagePickerController()
    //        imagePickerController.delegate = self
    //
    //        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
    //
    //        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
    //            if UIImagePickerController.isSourceTypeAvailable(.camera) {
    //                imagePickerController.sourceType = .camera
    //                self.present(imagePickerController, animated: true, completion: nil)
    //            } else {
    //                print("Camera not Available")
    //            }
    //
    //        }))
    //
    //        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
    //            imagePickerController.sourceType = .photoLibrary
    //             self.present(imagePickerController, animated: true, completion: nil)
    //        }))
    //
    //        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //
    //        self.present(actionSheet, animated: true, completion: nil)
    //
    //    }
    //
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //
    //        imageView.image = image
    //
    //        picker.dismiss(animated: true, completion: nil)
    //    }
    //
    //    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    //        picker.dismiss(animated: true, completion: nil)
    //    }
    //
    
    
}
