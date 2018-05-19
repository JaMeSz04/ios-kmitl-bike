//
//  Session.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/24/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation


public struct Session: Codable {
    let id : Int
    let bike : Bike
    let selected_plan : UsagePlan
    let timestamps : Timestamps
    let duration : Double
    let distance : String
    let route_line : [Location]
}
