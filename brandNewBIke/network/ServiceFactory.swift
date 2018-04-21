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
    case token(token: String)
}

extension KMITLBike: TargetType {
    var baseURL: URL {
        return URL(string: "http://161.246.94.246:1995")!
    }
    
    var path: String {
        switch self {
        case .login(_,_):
            return "/api/v1/accounts/login"
        case .token(_):
            return "/api/v1/accounts/access_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_,_), .token(_):
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .login(let username, let password):
            return .requestJSONEncodable(LoginForm(username: username, password: password))
        case .token(let token):
            return .requestJSONEncodable(TokenForm(token: token))
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}
