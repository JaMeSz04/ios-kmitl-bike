//
//  Api.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/18/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import Moya



private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

enum KMITLBike {
    case login(username: String, password: String)
}

extension KMITLBike: TargetType {
    var baseURL: URL {
        return URL(string: "http://161.246.94.246:1995")!
    }
    
    var path: String {
        switch self {
        case .login(_,_):
            return "/api/v1/accounts/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_,_):
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .login(_,_):
            return "".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .login(let username, let password):
            return .requestJSONEncodable(LoginForm(username: username, password: password))
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}
