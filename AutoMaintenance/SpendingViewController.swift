//
//  SpendingViewController.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/25/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit

class SpendingViewController: UIViewController, UITabBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createstartDatePicker()
        createendDatePicker()
        
        self.tabBar.delegate = self as UITabBarDelegate
    }
    
    
    @IBOutlet var startDatePicker: UITextField!
    @IBOutlet var endDatePicker: UITextField!
    
    let startPicker = UIDatePicker()
    let endPicker = UIDatePicker()
    
    @IBOutlet var milesValue: UILabel!
    @IBOutlet var gaschargesValue: UILabel!
    @IBOutlet var oilchargesValue: UILabel!
    @IBOutlet var tirechargesValue: UILabel!
    @IBOutlet var otherchargesValue: UILabel!
    @IBOutlet var totalCharges: UILabel!
    
    
    
        // Side Menu
    @IBAction func menuBTN(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    

    
    
    
    func createstartDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startdonePressed))
        toolbar.setItems([done], animated: false)
        
        startDatePicker.inputAccessoryView = toolbar
        startDatePicker.inputView = startPicker
        
        // format picker for date
        startPicker.datePickerMode = .date
    }
    
        // done Button Pressed when start datePicker is selected
    @objc func startdonePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: startPicker.date)
        
        startDatePicker.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    
    func createendDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(enddonePressed))
        toolbar.setItems([done], animated: false)
        
        endDatePicker.inputAccessoryView = toolbar
        endDatePicker.inputView = endPicker
        
        // format picker for date
        endPicker.datePickerMode = .date
    }
    
        // done Button Pressed when end datePicker is selected
    @objc func enddonePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: endPicker.date)
        
        endDatePicker.text = "\(dateString)"
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
