//
//  Location.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/20/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation


struct Location: Codable {
    var latitude : Double
    var longitude : Double
    
    init(lat: Double, long: Double){
        self.latitude = lat
        self.longitude = long
    }
}
