//
//  ServicesTableViewCell.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/25/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit

class ServicesTableViewCell: UITableViewCell {

    
    @IBOutlet var dateValue: UILabel!
    @IBOutlet var serviceValue: UILabel!
    @IBOutlet var costValue: UILabel!
    @IBOutlet var serviceIDValue: UILabel!
    @IBOutlet var statusValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
