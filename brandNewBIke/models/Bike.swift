//
//  Bike.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/22/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation


public struct Bike: Codable {
    var id: Int
    var bike_name: String
    var barcode: String
    var mac_address: String
    var latitude: Double
    var longitude: Double
    var bike_model: String
    
}

//
//{
//    "id": 1,
//    "bike_name": "KB001",
//    "barcode": "71664258",
//    "mac_address": "00:15:83:31:48:C7",
//    "latitude": 13.7304289948,
//    "longitude": 100.774918259,
//    "bike_model": "GIANT Escape 3"
//}

