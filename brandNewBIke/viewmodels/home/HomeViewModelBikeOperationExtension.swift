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
                self.currentBike = session.bike
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
    
    
    func validateReturn(code: String){
        
        if self.currentBike.barcode == code {
            self.bikeOperationStatus.onNext(BikeStatus.RETURNING_DEVICE)
            let util: ReturnProtocol = self.createUtil(model: self.currentBike.bike_model) as! ReturnProtocol
            util.returnBike(bike: self.currentBike, location: self.latestLocation).observeOn(MainScheduler.instance).subscribe(onSuccess: { (returnResponse) in
                self.currentSession = nil
                self.currentBike = nil
                print(returnResponse)
            })
            
        } else {
            print("qrcode mismatch!!!!")
        }
    }
}
