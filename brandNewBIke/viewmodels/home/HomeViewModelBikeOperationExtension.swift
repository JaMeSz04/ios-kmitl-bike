//
//  HomeViewModelBikeOperationExtension.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift



extension HomeViewModel {
    
    func borrowBike(bike: Bike) {
        print("borrow " + bike.bike_name)
        let borrowUtil = self.createUtil(model: bike.bike_model) as! BorrowProtocol
        let nonce = Int(Double(NSDate.timeIntervalSinceReferenceDate) / 1000)
        self.bikeOperationStatus.subscribe(onNext: { bikeStatus in
            switch bikeStatus {
            case .BORROW_COMPLETED:
                self.currentPage.displayNextItem()
                print("COMPLETED")
                break
            default:
                print(bikeStatus.description)
            }
        }).disposed(by: self.disposeBag)
        borrowUtil.borrow(bike: bike, planId: 2, location: self.latestLocation, nonce: nonce)
            .subscribe(onSuccess: { (session) in
                print(session)
                self.currentSession = session
            }).disposed(by: self.disposeBag)
    }
    
    func createUtil(model: String) -> BikeOperationProtocol {
        switch model {
        case Constants.GIANT_ESCAPE:
            return self.bluetoothUtil
        default:
            return self.manualUtil
        }
    }
    
    
    func getBikeLocation(){
        Api.getBikeList().observeOn(MainScheduler.instance).subscribe(onSuccess: { (bikeList) in
            self.bikeList.onNext(bikeList)
            self.internalBikeList = bikeList
        }) { (error) in
            print(error)
            }.disposed(by: self.disposeBag)
    }
    
    func validateReturn(code: String){
        if self.currentSession.bike.barcode == code {
            let util: ReturnProtocol = self.createUtil(model: self.currentSession.bike.bike_model) as! ReturnProtocol
            util.returnBike(bike: self.currentSession.bike, location: self.latestLocation).subscribe(onSuccess: { (returnResponse) in
                print(returnResponse)
                self.bikeOperationStatus.onNext(BikeStatus.CONNECTED_SERVER)
                util.performReturn(bike: self.currentSession.bike)
            }) { (error) in
                print(error)
                }.disposed(by: self.disposeBag)
            print("pass")
        } else {
            print("qrcode mismatch!!!!")
        }
    }
}
