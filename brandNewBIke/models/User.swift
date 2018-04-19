//
//  User.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/18/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import Mapper

public struct UserMap: Mappable {
    public init(map: Mapper) throws {
        try gender = map.from("gender")
        try id = map.from("id")
        try point = map.from("point")
        try result = map.from("result")
        try username = map.from("username")
        try first_name = map.from("first_name")
        try last_name = map.from("last_name")
        try email = map.from("email")
        try phone_no = map.from("phone_no")
        try token = map.from("token")
    }
    
    let gender : Int
    let id : Int
    let point : Int
    let result : Int
    let username : String
    let first_name : String
    let last_name : String
    let email : String
    let phone_no : String
    let token : String
    
}

public struct User: Codable {
    let gender : Int
    let id : Int
    let point : Int
    let result : Int
    let username : String
    let first_name : String
    let last_name : String
    let email : String
    let phone_no : String
    let token : String
}
