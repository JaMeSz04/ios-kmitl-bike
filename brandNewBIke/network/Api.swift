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
    
    public static func borrowBike(id: String) -> Single<BikeOperation>{
        return bikeProvider.rx.request(.borrow(bikeId: id)).observeOn(MainScheduler.instance).map(BikeOperation.self)
    }
}

