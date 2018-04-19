//
//  networkUtils.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift
import Mapper
import Moya

public class Api {
    static let provider = MoyaProvider<KMITLBike>()
    
    public static func login(username: String, password: String) -> Single<Bool> {
        return provider.rx.request(.login(username: username, password: password))
            .map(User.self)
            .observeOn(MainScheduler.instance)
            .flatMap { user -> Single<Bool> in
                print("requested")
                return Single.just(true)
            }
    }
}
