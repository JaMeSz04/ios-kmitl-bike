//
//  ReturnProtocol.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/14/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

protocol ReturnProtocol: BikeOperationProtocol {
    func performReturn(bike: BikeResponse)
    func performConnection()
}

extension ReturnProtocol {

    func returnBike(bike: BikeResponse, location: Location) -> Single<ReturnResponse> {
        self.subject.onNext(.CONNECTING_SERVER)
        return Api.returnBike(bikeId: String(bike.id), location: location, isCancel: false).observeOn(MainScheduler.instance)
            
        
        
        
    }
}
