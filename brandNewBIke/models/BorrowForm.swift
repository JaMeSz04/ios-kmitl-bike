//
//  BorrowForm.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/12/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation


public struct BorrowForm: Codable {
    var nonce: Int
    var location: Location
    var selected_plan: Int
    
    init(nonce: Int, location: Location, selectedPlan: Int){
        self.nonce = nonce
        self.location = location
        self.selected_plan = selectedPlan
    }
}

