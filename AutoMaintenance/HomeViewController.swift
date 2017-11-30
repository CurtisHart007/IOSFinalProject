//
//  HomeViewController.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/17/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITabBarDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showProfile),
                                               name: NSNotification.Name("ShowProfile"),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showGarage),
                                               name: NSNotification.Name("ShowGarage"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showFuture),
                                               name: NSNotification.Name("ShowFuture"),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showSpend),
                                               name: NSNotification.Name("ShowSpend"),
                                               object: nil)
        
        self.tabBar.delegate = self as UITabBarDelegate
    }
    
    @objc func showProfile(){
        performSegue(withIdentifier: "ShowProfile", sender: nil)
    }
    @objc func showGarage(){
        performSegue(withIdentifier: "ShowGarage", sender: nil)
    }
    @objc func showFuture(){
        performSegue(withIdentifier: "ShowFuture", sender: nil)
    }
    @objc func showSpend(){
        performSegue(withIdentifier: "ShowSpend", sender: nil)
    }



        // Extra button to send to View Controller
    @IBAction func SendView(_ sender: Any) {
        performSegue(withIdentifier: "CompletedServices", sender: nil)
    }
    
    
 
        // Action for Side Menu Button
    @IBAction func menuBTN(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    
    @IBAction func serviceReportBTN(_ sender: Any) {
         performSegue(withIdentifier: "serviceReports", sender: nil)
    }
    
    
    @IBAction func garageBTN(_ sender: Any) {
         performSegue(withIdentifier: "ShowGarage", sender: nil)
    }
    

    @IBAction func addCompletedBTN(_ sender: Any) {
        performSegue(withIdentifier: "addCompletedEntry", sender: nil)
    }
    
    
    @IBAction func addFutureBTN(_ sender: Any) {
         performSegue(withIdentifier: "ShowFuture", sender: nil)
    }

    
    
    @IBAction func spendingBTN(_ sender: Any) {
         performSegue(withIdentifier: "ShowSpend", sender: nil)
    }
    
    
    
    @IBAction func viewProfileBTN(_ sender: Any) {
         performSegue(withIdentifier: "ShowProfile", sender: nil)
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

    // Extension to Hide Keyboard when clicking about for Field
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
