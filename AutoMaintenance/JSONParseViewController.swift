//
//  JSONParseViewController.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/29/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit

struct vehicleMake: Decodable {
    let count: Int
    let message: String
    let serachCriteria: String
    let result: [Results]
}

struct Results: Decodable {
    let county: String
    let commonName: String
    let id: Int
    let name: String
    let vehicleType: [vehicleTypes]
    
struct vehicleTypes: Decodable {
    let primary: Bool
    let vehiclename: String
}
    
    
//    init(json: [String: Any]) {
//        id = json["id"] as? Int ?? -1
//        name = json["name"] as? String ?? ""
//        link = json["link"] as? String ?? ""
//        imageURL = json["imageURL"] as? String ?? ""
//    }
}


class JSONParseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let jsonUrlString = "https://vpic.nhtsa.dot.gov/api/vehicles/getallmanufacturers?format=json"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response , err) in
            // perhaps check err
            // check response status 200 OK
            
            guard let data = data else { return }
            
//            let dataAsString = String(data: data, encoding: .utf8)
//            print(dataAsString)
            
            do {
                
                let vehicleManufacturers = try JSONDecoder().decode(vehicleMake.self, from: data)
                print(vehicleManufacturers.count,
                      vehicleManufacturers.message,
                      vehicleManufacturers.serachCriteria)
                
                    // single layer object
//                let courses = try JSONDecoder().decode([Course].self, from: data)
//                print(courses)
                
//                //Swift 2/3/ObjC
//                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
//                print(json)
//
//                let course = Course(json: json)
//                print(course.name)
                
            } catch let jsonErr {
                print("Error serializing json: ", jsonErr)
            }
            
        }.resume()
        
        
        
        
    }
}
