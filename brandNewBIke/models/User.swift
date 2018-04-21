//
//  User.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/18/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import Mapper

public struct User: Codable {
    let gender : Int
    let id : Int
    let point : Int
    let result : Int?
    let username : String
    let first_name : String
    let last_name : String
    let email : String
    let phone_no : String
    let token : String
}
