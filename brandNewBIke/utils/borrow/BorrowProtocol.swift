//
//  BorrowProtocol.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/24/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

protocol BorrowProtocol {
    var subject: PublishSubject<BikeStatus> { get set }
    init()
    func performBorrow(operation: BikeOperation)
    func performConnection()
}


extension BorrowProtocol {
    
    init(subject: PublishSubject<BikeStatus>){
        self.init()
        self.subject = subject
    }

    func borrow(bike: Bike, planId: Int, location: Location, nonce: Int) -> Single<Session> {
        self.subject.onNext(.CONNECTED_SERVER)
        return Api.borrowBike(id: String(bike.id), nonce: nonce, location: location, planId: planId).observeOn(MainScheduler.instance).flatMap({ (bikeOperation) -> Single<Session> in
            print(bikeOperation)
            self.subject.onNext(.CONNECTED_SERVER)
            self.performBorrow(operation: bikeOperation)
            return Single.just(bikeOperation.session)
        })
    }
}
