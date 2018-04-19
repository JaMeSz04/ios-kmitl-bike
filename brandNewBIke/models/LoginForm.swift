//
//  LoginForm.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/18/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation

struct LoginForm : Codable {
    let username : String
    let password : String
    
    init(username : String, password : String) {
        self.username = username
        self.password = password
    }
}
