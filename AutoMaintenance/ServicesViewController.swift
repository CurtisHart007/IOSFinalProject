//
//  ServicesViewController.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/25/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit
import SQLite


class ServicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    var myAccountNum: Int64 = 0
    var myServicesCount: Int64 = 0
    var myServiceID: Int = 0
    
    var dateArray = [String]()
    var serviceArray = [String]()
    var costArray = [String]()
    var serviceIDArray = [Int]()
    var statusArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.servicesTableView.rowHeight = 150.0
        self.tabBar.delegate = self as UITabBarDelegate
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let y = UserDefaults.standard.object(forKey: "myAccountNum") as? Int64 {
            myAccountNum = y
            loadData()
        }

        
        servicesTableView.reloadData()
    }
    
    
    
        // Action for Side Menu Button
    @IBAction func menuBTN(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
        // Segue to send to Add Servive Entry
    @IBAction func addBTN(_ sender: Any) {
        let addcompletedServicesController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addCompletedEntry") as! AddEntryViewController
        self.navigationController?.pushViewController(addcompletedServicesController, animated: true)
    }
    
    
    var database: Connection!
    let servicesTable = Table("Services")
    
    // database columns
    let serviceID = Expression<Int>("serviceID")
    var accountID = Expression<Int64>("accountID")
    let typeName = Expression<String>("typeName")
    let otherName = Expression<String?>("otherName")
    
    let date = Expression<String>("date")
    let mileage = Expression<String>("mileage")
    let company = Expression<String>("company")
    let cost = Expression<String>("cost")
    var status = Expression<String>("status")
    
    
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
    
    func loadData() {
        
        let tempAcccountNum = myAccountNum
        let tempStatus:String = "completed"
        
        let serviceCount =  try! database.scalar("SELECT count(*) FROM Services WHERE accountID = '\(tempAcccountNum)' AND status = '\(tempStatus)'") as? Int64
        myServicesCount = serviceCount!
        
        do {


//            let services = try self.database.prepare(self.servicesTable)
            let services = try self.database.prepare("SELECT date, typeName, cost FROM Services WHERE accountID = '\(tempAcccountNum)'")
            for service in services {
                var x: Int = 0

                dateArray.insert(service[self.date], at: x)
                serviceArray.insert(service[self.typeName], at: x)
                costArray.insert(service[self.cost], at: x)
                serviceIDArray.insert(service[self.serviceID], at: x)
                statusArray.insert(service[self.status], at: x)
                
                x = x + 1
            }
        } catch {
            print(error)
        }

    }
    
    
    
    
    
    
    @IBOutlet var servicesTableView: UITableView!
    
        // TableView numberOfSections for Services
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
        // TableView numberOfRowsInSection for Services
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(myServicesCount)
    }
    
        // TableView cellForRowAt for Services
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServicesTableViewCell
        
        cell.dateValue.text = dateArray[indexPath.row]
        cell.serviceValue.text = serviceArray[indexPath.row]
        cell.costValue.text = costArray[indexPath.row]
        cell.serviceIDValue.text = "\(serviceIDArray[indexPath.row])"
        cell.statusValue.text = statusArray[indexPath.row]

        return (cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let indexPath = self.servicesTableView.indexPathForSelectedRow
        
        guard let selectedRow = indexPath?.row else {return}
        
        let serviceID = serviceIDArray[selectedRow]
        
        let destinationVC = segue.destination as? AddEntryViewController
        
        destinationVC?.myServiceID = serviceID
        
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
