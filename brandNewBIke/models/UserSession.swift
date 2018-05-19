//
//  UserSession.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation

struct UserSession: Codable {
    let id : Int?
    let bike : Bike?
    let selected_plan : UsagePlan?
    let timestamps : Timestamps?
    let duration : Int?
    let distance : String?
    let route_line : [Location]?
    let resume : Bool
}
