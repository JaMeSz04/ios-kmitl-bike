//
//  NetworkLogger.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/12/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import Moya
import Result


/// Logs network activity (outgoing requests and incoming responses).
class NetworkLogger: PluginType {
    
    typealias Comparison = (TargetType) -> Bool
    
    let whitelist: Comparison
    let blacklist: Comparison
    
    init(whitelist: @escaping Comparison = { _ -> Bool in return true }, blacklist: @escaping Comparison = { _ -> Bool in  return true }) {
        self.whitelist = whitelist
        self.blacklist = blacklist
    }
    
    func willSendRequest(_ request: RequestType, target: TargetType) {
        // If the target is in the blacklist, don't log it.
        guard blacklist(target) == false else { return }
        print("Sending request:" + (request.request?.url?.absoluteString ?? String()))
    }
    
    func didReceiveResponse(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        // If the target is in the blacklist, don't log it.
        guard blacklist(target) == false else { return }
        
        switch result {
        case .success(let response):
            if 200..<400 ~= (response.statusCode ) && whitelist(target) == false {
                // If the status code is OK, and if it's not in our whitelist, then don't worry about logging its response body.
                print("Received response(" + (response.response?.url?.absoluteString)! + ")" )
            }
        case .failure(let error):
            // Otherwise, log everything.
            print("Received networking error: \(error)")
        }
    }
}
