//
//  Api.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/20/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public class Api {
    static let bikeProvider = MoyaProvider<KMITLBike>()
    
    public static func login(username: String, password: String) -> Single<User> {
        return bikeProvider.rx.request(.login(username: username, password: password)).observeOn(MainScheduler.instance).map(User.self)
    }
    
    public static func getUserFromToken(token: String) -> Single<User> {
        return bikeProvider.rx.request(.token(token: token)).observeOn(MainScheduler.instance).map(User.self)
    }
    
    public static func getBikeList() -> Single<[Bike]> {
        return bikeProvider.rx.request(.bikeList()).observeOn(MainScheduler.instance).map([Bike].self)
    }
    
    static func borrowBike(id: String, nonce: Int, location: Location, planId: Int) -> Single<BikeOperation>{
        return bikeProvider.rx.request(.borrow(bikeId: id, nonce: nonce, location:location, plan: planId)).observeOn(MainScheduler.instance).do(onSuccess: { (response) in
            print( String(data: response.data, encoding: .utf8) ?? "")
        }).map(BikeOperation.self)
    }
    
    static func updateLocation(location: Location) -> Single<Response>{
        return bikeProvider.rx.request(.updateTrackingLocation(location: location))
    }
    
    static func returnBike(bikeId: String, location: Location, isCancel: Bool) -> Single<ReturnResponse> {
        return bikeProvider.rx.request(.returnBike(bikeId: bikeId, location: location, isCancel: isCancel)).observeOn(MainScheduler.instance).do(onSuccess: { (response) in
            print( String(data: response.data, encoding: .utf8) ?? "")
        }).map(ReturnResponse.self)
    }
    
}

