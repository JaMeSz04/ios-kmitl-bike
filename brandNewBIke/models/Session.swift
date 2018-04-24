//
//  Session.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/24/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation


public struct Session: Codable {
    var bike: Bike
    var duration: Int
    var id: Int
    var distance: String
    var timestamps: Date
    var selectedPlan: UsagePlan
    var routeLine: [Location]
}
