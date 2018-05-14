//
//  ReturnForm.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/14/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation


public struct ReturnForm: Codable {
    var location: Location
    var cancel: Bool
    
    init(location:Location, cancel: Bool){
        self.location = location
        self.cancel = cancel
    }
}
