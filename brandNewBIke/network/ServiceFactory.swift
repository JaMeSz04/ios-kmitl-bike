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
    case bikeList()
    case borrow(bikeId: String, nonce: Int, location: Location, plan: Int)
    case updateTrackingLocation(location: Location)
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
        case .bikeList():
            return "/api/v1/bikes/list"
        case .borrow(let bikeId,_,_,_):
            return "/api/v1/bikes/\(bikeId.URLEscapedString)/borrow"
        case .updateTrackingLocation(_):
            return "/api/v1/bikes/update"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_,_), .token(_), .borrow(_), .updateTrackingLocation(_):
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
        case .bikeList():
            return .requestPlain
        case .borrow(_, let nonce, let location, let plan):
            let form = BorrowForm(nonce: nonce, location: location, selectedPlan: plan)
            print(form)
            return .requestJSONEncodable(form)
        case .updateTrackingLocation(let location):
            return .requestJSONEncodable(location)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .bikeList(), .borrow(bikeId: _):
            return ["Content-Type": "application/json",
                    "Authorization": UserDefaults.standard.string(forKey: StorageKey.TOKEN_KEY)!]
        default:
            return ["Content-Type": "application/json"]
        }
        
    }
    
    
}
