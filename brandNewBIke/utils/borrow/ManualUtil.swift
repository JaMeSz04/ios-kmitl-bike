//
//  ManualUtil.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/24/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

public class ManualClient: BorrowProtocol, ReturnProtocol {

    
    func performBorrow(bikeName: String) {
        
    }
    
    func returnBike(bike: Bike, location: Location) -> Single<ReturnResponse> {
        print("perform return!!!!")
        self.subject.onNext(.CONNECTING_SERVER)
        return Api.returnBike(bikeId: String(bike.id), location: location, isCancel: false).flatMap({ (returnResponse) -> Single<ReturnResponse> in
            self.subject.onNext(BikeStatus.BORROW_COMPLETED)
            return Single.just(returnResponse)
        })
        
    }
    
    func borrow(bike: Bike, planId: Int, location: Location, nonce: Int) -> Single<Session> {
        print("Perform borrowwww!!!ed")
        return Api.borrowBike(id: String(bike.id), nonce: nonce, location: location, planId: planId).observeOn(MainScheduler.instance).flatMap { (operation) -> Single<Session> in
            self.subject.onNext(BikeStatus.BORROW_COMPLETED)
            return Single.just(operation.session)
        }
        
    }
    

    func performReturn(bike: Bike) {
       
    }
    
    
    func performConnection() {}
    
    required public init() {
        self.subject = PublishSubject<BikeStatus>()
        self.subject.dispose()
    }
    
    var subject: PublishSubject<BikeStatus>


    

}
