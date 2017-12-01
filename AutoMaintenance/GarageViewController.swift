//
//  GarageViewController.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/17/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit
import SQLite

class GarageViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate {

// year JSON
struct vehicleYear: Decodable {
    let errors: Int
    let result: [Years]
}

struct Years: Decodable {
    let year: String
}

// **********************

// make JSON
struct vehicleMake: Decodable {
    let errors: Int
    let result: [Make]
}

struct Make: Decodable {
    let make_id: String
    let make: String
}

// **********************

// model JSON
struct vehicleModel: Decodable {
    let errors: Int
    let result: [Models]
}

struct Models: Decodable {
    let model_id: String
    let model: String
}



    
    var myAccountNum: Int64 = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearsJSON()
//        makesJSON()
//        modelsJSON()
        

        // Hide Keyboard when click away
        self.hideKeyboardWhenTappedAround()
        
        // Hide Year, Make & Model TableView on Load
        self.yearTableView.isHidden = true
        self.makeTableView.isHidden = true
        self.modelTableView.isHidden = true
        
        // Connect to SQLite for Vehicle Table
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("vehicle").appendingPathExtension("sqlite 3")
            
            // saves everything to that file
            let database = try Connection(fileURL.path)
            // set this database to global database
            self.database = database
        } catch {
            print(error)
        }
        
        // Create Vehicle Table, If Doesn't Exist
        createVehicleTable()
        print(myAccountNum)
        
        self.tabBar.delegate = self as UITabBarDelegate
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let y = UserDefaults.standard.object(forKey: "myAccountNum") as? Int64 {
            myAccountNum = y
            loadGarageDetails()
        }
    }
    
    

    var database: Connection!
    
        // database columns
    let vehicleTable = Table("Vehicle")
    let vehicleID = Expression<Int>("vehicleID")
    let accountID = Expression<Int64>("accountID")
    let year = Expression<String>("year")
    let make = Expression<String>("make")
    let model = Expression<String>("model")
    let vin = Expression<String?>("vin")            // optional string
    let mileage = Expression<String>("mileage")
    let nickname = Expression<String>("nickname")

    
    
        // Side Menu
    @IBAction func menuBTN(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
//    let Yeararray = ["2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999", "1998", "1997", "1996", "1995", "1994", "1993", "1992", "1991", "1990", "1989", "1988", "1987", "1986", "1985", "1984", "1983", "1982", "1981", "1980", "1979", "1978", "1977", "1976", "1975", "1974", "1973", "1972", "1971", "1970"]
    let Yeararray = [String]()
    let Makearray = ["Acura", "Mits", "Ford", "Honda", "Toyota"]
    let Modelarray = ["LX", "Lancer", "Evo", "F150", "F250"]
    
    
    

    // Button & Table View for Year
    @IBOutlet var YearBTN: UIButton!
    @IBOutlet var yearTableView: UITableView!
    
    // Button & Table View for Make
    @IBOutlet var MakeBTN: UIButton!
    @IBOutlet var makeTableView: UITableView!
    
    // Button & Table View for Model
    @IBOutlet var ModelBTN: UIButton!
    @IBOutlet var modelTableView: UITableView!
    
    // TextField for VIN & Mileage
    @IBOutlet var VINTextField: UITextField!
    @IBOutlet var MileageTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    
    
    
    func loadGarageDetails() {
        
        let accountNumberDB = myAccountNum
        let yearDB =        try! database.scalar("SELECT year FROM Vehicle WHERE accountID = '\(accountNumberDB)'") as? String
        let makeDB =        try! database.scalar("SELECT make FROM Vehicle WHERE accountID = '\(accountNumberDB)'") as? String
        let modelDB =       try! database.scalar("SELECT model FROM Vehicle WHERE accountID = '\(accountNumberDB)'") as? String
        let vinDB =         try! database.scalar("SELECT vin FROM Vehicle WHERE accountID = '\(accountNumberDB)'") as? String
        let mileageDB =     try! database.scalar("SELECT mileage FROM Vehicle WHERE accountID = '\(accountNumberDB)'") as? String
        let nicknameDB =    try! database.scalar("SELECT nickname FROM Vehicle WHERE accountID = '\(accountNumberDB)'") as? String
        
        
        YearBTN.setTitle(yearDB, for: .normal)
        MakeBTN.setTitle(makeDB, for: .normal)
        ModelBTN.setTitle(modelDB, for: .normal)
        VINTextField.text = vinDB
        MileageTextField.text = mileageDB
        nicknameTextField.text = nicknameDB
        
    }
    
    
    
        // Insert vehicle data into SQLite
    @IBAction func SaveBTN(_ sender: Any) {
        
        let tempAccountID = myAccountNum
        let vehicleCount =  try! database.scalar("SELECT count(*) FROM Vehicle WHERE accountID = '\(tempAccountID)'") as? Int64
        
        let yearDB =        try! database.scalar("SELECT year FROM Vehicle WHERE accountID = '\(tempAccountID)'") as? String
        let makeDB =        try! database.scalar("SELECT make FROM Vehicle WHERE accountID = '\(tempAccountID)'") as? String
        let modelDB =       try! database.scalar("SELECT model FROM Vehicle WHERE accountID = '\(tempAccountID)'") as? String
        let vinDB =         try! database.scalar("SELECT vin FROM Vehicle WHERE accountID = '\(tempAccountID)'") as? String
        let mileageDB =     try! database.scalar("SELECT mileage FROM Vehicle WHERE accountID = '\(tempAccountID)'") as? String
        let nicknameDB =    try! database.scalar("SELECT nickname FROM Vehicle WHERE accountID = '\(tempAccountID)'") as? String

        
        if (vehicleCount! > 0) {
            
            do {
                let alice = vehicleTable.filter(nickname == nicknameDB!)
                
                try self.database.run(alice.update(year <- year.replace(yearDB!, with: (YearBTN.titleLabel?.text)!)))
                try self.database.run(alice.update(make <- make.replace(makeDB!, with: (MakeBTN.titleLabel?.text)!)))
                try self.database.run(alice.update(model <- model.replace(modelDB!, with: (ModelBTN.titleLabel?.text)!)))
                try self.database.run(alice.update(vin <- vin.replace(vinDB!, with: (VINTextField.text)!)))
                try self.database.run(alice.update(mileage <- mileage.replace(mileageDB!, with: (MileageTextField.text)!)))
                try self.database.run(alice.update(nickname <- nickname.replace(nicknameDB!, with: (nicknameTextField.text)!)))
                
            } catch {
                print(error)
            }
            
            let alert = UIAlertController(title: "Alert", message: "Vehicle information has been updated", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    
        }
        else {
                let insertVehicle = self.vehicleTable.insert(self.accountID <- self.myAccountNum, self.year <- YearBTN.titleLabel!.text!, self.make <- MakeBTN.titleLabel!.text!, self.model <- ModelBTN.titleLabel!.text!, self.vin <- VINTextField.text!, self.mileage <- MileageTextField.text!, self.nickname <- nicknameTextField.text!)

                do {
                    try self.database.run(insertVehicle)
                    print("Inserted Vehicle")

                    let vehicles = try self.database.prepare(self.vehicleTable)
                    for vehicle in vehicles {
                        print("VehicleID: \(vehicle[self.vehicleID]), AccountID: \(vehicle[self.accountID]), Year: \(vehicle[self.year]), Make: \(vehicle[self.make]), Model: \(vehicle[self.model]), VIN: \(String(describing: vehicle[self.vin])), Mileage: \(vehicle[self.mileage]), Nickname: \(vehicle[self.nickname])")
                        
                        let alert = UIAlertController(title: "Alert", message: "Vehicle information has been saved", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }

                } catch {
                    print(error)
                }
        }
    }
    
    
    
    
    
        // Edit button to allow users to change vehichle
    @IBAction func editBTN(_ sender: Any) {
        YearBTN.isUserInteractionEnabled = true
        MakeBTN.isUserInteractionEnabled = true
        ModelBTN.isUserInteractionEnabled = true
        VINTextField.isUserInteractionEnabled = true
        MileageTextField.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: "Alert", message: "User Can Now Edit Year, Make, Model, VIN, & Mileage", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
        // Create Vehicle Table
    func createVehicleTable() {
        print("Create Vehicle Table")
        
        let createTable = self.vehicleTable.create { (table) in
            table.column(self.vehicleID, primaryKey: true)
            table.column(self.accountID)
            table.column(self.year)
            table.column(self.make)
            table.column(self.model)
            table.column(self.vin, unique: true)
            table.column(self.mileage)
            table.column(self.nickname)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Vehicle Table")
        } catch {
            print(error)
        }
    }
    

    
    
    
    
    
        // TableView NumberOfSections At for Year, Make & Model
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
        // TableView NumberofRowsInSection At for Year, Make & Model
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        // Count for Year Table View
        if tableView == self.yearTableView {
            count = Yeararray.count
        }
        
        // Count for Make Table View
        if tableView == self.makeTableView {
            count = Makearray.count
        }
        
        // Count for Model Table View
        if tableView == self.modelTableView {
            count = Modelarray.count
        }
        
        return count!
    }
    
        // TableView CellForRowAt At for Year, Make & Model
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        // Cells in Year Table View
        if tableView == self.yearTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "yearcell", for: indexPath)
            cell?.textLabel?.text = Yeararray[indexPath.row]
            cell?.textLabel?.textAlignment = .center
        }
        
        // Cells in Make Table View
        if tableView == self.makeTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "makecell", for: indexPath)
            cell?.textLabel?.text = Makearray[indexPath.row]
            cell?.textLabel?.textAlignment = .center
        }
        
        // Cells in Model Table View
        if tableView == self.modelTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "modelcell", for: indexPath)
            cell?.textLabel?.text = Modelarray[indexPath.row]
            cell?.textLabel?.textAlignment = .center
       }
        
        return cell!
    }
    
        // TableView DidSelectRow At for Year, Make & Model
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Cells in Year Table View
        if tableView == self.yearTableView {
            let cell = tableView.cellForRow(at: indexPath)
            YearBTN.setTitle(cell?.textLabel?.text, for: .normal)
            self.yearTableView.isHidden = true
        }
        
        // Cells in Make Table View
        if tableView == self.makeTableView {
            let cell = tableView.cellForRow(at: indexPath)
            MakeBTN.setTitle(cell?.textLabel?.text, for: .normal)
            self.makeTableView.isHidden = true
        }

        // Cells in Model Table View
        if tableView == self.modelTableView {
            let cell = tableView.cellForRow(at: indexPath)
            ModelBTN.setTitle(cell?.textLabel?.text, for: .normal)
            self.modelTableView.isHidden = true
        }
    }
    
    
    
    
    
    
    // Year Table View Hiding & Unhiding *********************************************
    @IBAction func YearBTNPressed(_ sender: Any) {
        self.yearTableView.isHidden = !self.yearTableView.isHidden
    }
    
    // Make Table View Hiding & Unhiding *********************************************
    @IBAction func MakeBTNPressed(_ sender: Any) {
        self.makeTableView.isHidden = !self.makeTableView.isHidden
    }
    
    // Model Table View Hiding & Unhiding *********************************************
    @IBAction func ModelBTNPressed(_ sender: Any) {
        self.modelTableView.isHidden = !self.modelTableView.isHidden
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
    

//    @IBAction func ImageBTN(_ sender: Any) {
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
//            self.present(imagePickerController, animated: true, completion: nil)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(actionSheet, animated: true, completion: nil)
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
    
    
    func yearsJSON() {
        
        let urlYear = "https://databases.one/api/?format=json&select=year&api_key=2cea30c809ed63591521b5bc5"
        guard let url = URL(string: urlYear) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response , err) in
            
            guard let data = data else { return }
            
            do {
                let vehicleallYears = try JSONDecoder().decode(vehicleYear.self, from: data)
                print(vehicleallYears.result.last!)
                
                
//                let years = try JSONDecoder().decode([Years].self, from: data)
//                print(years.count)
//
//                for jsonData in years {
//                    print(jsonData.year)
//                };﻿
                
//                let vehicleallYears = try JSONDecoder().decode([Years].self, from: data)
//                print(vehicleallYears)
//
//                self.Yeararray = vehicleallYears
                
            } catch let jsonErr {
                print("Error serializing json: ", jsonErr)
            }
            
            
            
            }.resume()
    }
    
    
    func makesJSON() {
        
        let urlMake = "https://databases.one/api/?format=json&select=make&api_key=2cea30c809ed63591521b5bc5"
        guard let url = URL(string: urlMake) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response , err) in
            
            guard let data = data else { return }
            
            do {
                let vehicleMakes = try JSONDecoder().decode(vehicleMake.self, from: data)
                print(vehicleMakes.result)
                
            } catch let jsonErr {
                print("Error serializing json: ", jsonErr)
            }
            
            }.resume()
    }
    
    func modelsJSON() {
        let urlModel = "https://databases.one/api/?format=json&select=model&api_key=2cea30c809ed63591521b5bc5"
        guard let url = URL(string: urlModel) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response , err) in
            
            guard let data = data else { return }
            
            do {
                let vehicleModels = try JSONDecoder().decode(vehicleModel.self, from: data)
                print(vehicleModels.result)
                
            } catch let jsonErr {
                print("Error serializing json: ", jsonErr)
            }
            
            }.resume()
        
        
    }
    
}
