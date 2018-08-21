//
//  RegisterForm.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 8/21/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation

public struct RegisterForm: Codable {
    let username: String
    let first_name: String
    let last_name: String
    let phone_no: String
    let email: String
    let gender: Int
    
    init(username : String, firstName : String, lastName: String, email: String, phoneNo: String, gender: Int) {
        self.username = username
        self.first_name = firstName
        self.last_name = lastName
        self.email = email
        self.phone_no = phoneNo
        self.gender = gender
    }
}
