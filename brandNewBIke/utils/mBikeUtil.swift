//
//  BluetoothUtil.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/22/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxBluetoothKit
import CoreBluetooth
import RxSwift

@objc public class mBikeUtil: NSObject {
    
    @objc static let shared = mBikeUtil()
    
    var subject: PublishSubject<BikeStatus>
    let manager = CentralManager(queue: .main)

    private let disposeBag: DisposeBag = DisposeBag()
    private var location: Location!
    private var planId: Int!
    private var bikeId: Int!
    private var bikeMac: String!
    private var singleSubject: PublishSubject<Session>
    private var returnSubject: PublishSubject<ReturnResponse>
    
    required public override init() {
        self.subject = PublishSubject<BikeStatus>()
        self.singleSubject = PublishSubject<Session>()
        self.returnSubject = PublishSubject<ReturnResponse>()
        self.subject.dispose()
        
    }
    
    public func setSubject(bikeOperationStatus : Any){
        self.subject = bikeOperationStatus as! PublishSubject<BikeStatus>
    }
    
    func borrow(bike: Bike, planId: Int, location: Location, nonce: Int) -> PrimitiveSequence<SingleTrait, Session> {
        
        self.location = location
        self.planId = planId
        self.bikeId = bike.id
        self.bikeMac = bike.mac_address
        
        self.connectToServer(nonce: nonce)
        return Single<Session>.create { observer in
            return self.singleSubject.subscribe{ session in
                observer(.success(session.element!))
            }
        }
    }
    
    @objc public func onConnected(){
        print("connected to device")
        self.subject.onNext(BikeStatus.BORROWING_BIKE)
        mBluetoothUtil.unlock()
        
    }
    
    @objc public func onUnlocked(){
        print("unlocked")
        self.subject.onNext(BikeStatus.BORROW_COMPLETED)
        //self.bluetoothUtil.disconnect()
    }
    
    private func done(){
        self.subject = PublishSubject<BikeStatus>()
        self.singleSubject = PublishSubject<Session>()
        self.returnSubject = PublishSubject<ReturnResponse>()
        self.subject.dispose()
    }
    
    @objc public func disconnect(){
        print("disconnected")
    }
    
    @objc public func onError(whereError: String){
        let message:String = { () -> String in
            switch whereError {
            case "connection":
                return "Connection failed"
            case "unlock":
                return "Unlock failed"
            default:
                return "Unexpected failure"
            }
        }()
        ErrorFactory.displayError(errorMessage: "Borrow failed : " + message)
    }
    

    func returnBike(bike: Bike, location: Location) -> Single<ReturnResponse> {
        self.location = location
        self.connectToServer(nonce: nil)
        
        return Single<ReturnResponse>.create { observer in
            return self.returnSubject.subscribe{ returnResponse in
                observer(.success(returnResponse.element!))
            }
        }
    }
 
    private func connectToServer(nonce: Int?){
        self.subject.onNext(BikeStatus.CONNECTING_SERVER)
        if nonce == nil {
            Api.returnBike(bikeId: String(self.bikeId), location: location, isCancel: false).subscribe(onSuccess: { (returnResponse) in
                self.subject.onNext(.RETURN_COMPLETED)
                self.returnSubject.onNext(returnResponse)
            }) { (error) in
                ErrorFactory.displayError(errorMessage: "Error connection to server to return")
                }.disposed(by: self.disposeBag)
        } else {
            Api.borrowBike(id: String(self.bikeId), nonce: nonce!, location: self.location, planId: self.planId).observeOn(MainScheduler.instance).subscribe(onSuccess: { (bikeOperation) in
                self.subject.onNext(BikeStatus.CONNECTED_SERVER)
                self.singleSubject.onNext(bikeOperation.session)
                print(bikeOperation.message)
                let macAddr = "0102" + self.bikeMac.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
                mBluetoothUtil.connect(macAddr)
            }) { (error) in
                ErrorFactory.displayError(errorMessage: "Error connection to server to borrow")
                }.disposed(by: self.disposeBag)
        }
        
    }

    
    
    
    
    
    
    
}
