//
//  TokenForm.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/20/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation


struct TokenForm: Codable {
    let token : String
    init(token : String) {
        self.token = token
    }
}
