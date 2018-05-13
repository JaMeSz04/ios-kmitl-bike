//
//  BikeResponse.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/13/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation

public struct BikeResponse: Codable {
    let id : Int
    let bike_name : String
    let barcode : String
    let mac_address : String
    let bike_model : String
}
