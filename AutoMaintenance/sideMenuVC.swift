//
//  sideMenuVC.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/17/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit

class sideMenuVC: UITableViewController {
    
    @IBOutlet var usernameLabel: UILabel!
    
    override func viewDidLoad() {
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "myUsername") as? String {
            usernameLabel.text = "  Username: " + x
        }
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        // posts what button was selected
        switch indexPath.row {
        case 1: NotificationCenter.default.post(name: NSNotification.Name("ShowProfile"), object: nil)
        case 2: NotificationCenter.default.post(name: NSNotification.Name("ShowGarage"), object: nil)
        case 3: NotificationCenter.default.post(name: NSNotification.Name("ShowFuture"), object: nil)
        case 4: NotificationCenter.default.post(name: NSNotification.Name("ShowSpend"), object: nil)
        default: break
        }
    }


}
