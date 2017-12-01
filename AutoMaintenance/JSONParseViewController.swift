//
//  JSONParseViewController.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/29/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import UIKit


//    // year JSON
//struct vehicleYear: Decodable {
//    let errors: Int
//    let result: [Years]
//}
//
//struct Years: Decodable {
//    let year: String
//}
//
//// **********************
//
//    // make JSON
//struct vehicleMake: Decodable {
//    let errors: Int
//    let result: [Make]
//}
//
//struct Make: Decodable {
//    let make_id: String
//    let make: String
//}
//
//// **********************
//
//// model JSON
//struct vehicleModel: Decodable {
//    let errors: Int
//    let result: [Models]
//}
//
//struct Models: Decodable {
//    let model_id: String
//    let model: String
//}


class JSONParseViewController: UIViewController {

//    var makes = [Make]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        yearsJSON()
//        makesJSON()
//        modelsJSON()
    
    }
    
//
//     func yearsJSON() {
//
//        let urlYear = "https://databases.one/api/?format=json&select=year&api_key=2cea30c809ed63591521b5bc5"
//        guard let url = URL(string: urlYear) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response , err) in
//
//            guard let data = data else { return }
//
//            do {
//                let vehicleallYears = try JSONDecoder().decode(vehicleYear.self, from: data)
//                print(vehicleallYears.result)
//
//            } catch let jsonErr {
//                print("Error serializing json: ", jsonErr)
//            }
//
//            }.resume()
//    }
//
//
//    func makesJSON() {
//
//        let urlMake = "https://databases.one/api/?format=json&select=make&api_key=2cea30c809ed63591521b5bc5"
//        guard let url = URL(string: urlMake) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response , err) in
//
//            guard let data = data else { return }
//
//            do {
//                let vehicleMakes = try JSONDecoder().decode(vehicleMake.self, from: data)
//                print(vehicleMakes.result)
//
//            } catch let jsonErr {
//                print("Error serializing json: ", jsonErr)
//            }
//
//            }.resume()
//    }
//
//    func modelsJSON() {
//        let urlModel = "https://databases.one/api/?format=json&select=model&api_key=2cea30c809ed63591521b5bc5"
//        guard let url = URL(string: urlModel) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response , err) in
//
//            guard let data = data else { return }
//
//            do {
//                let vehicleModels = try JSONDecoder().decode(vehicleModel.self, from: data)
//                print(vehicleModels.result)
//
//            } catch let jsonErr {
//                print("Error serializing json: ", jsonErr)
//            }
//
//            }.resume()
//
//        
//    }
//
}
