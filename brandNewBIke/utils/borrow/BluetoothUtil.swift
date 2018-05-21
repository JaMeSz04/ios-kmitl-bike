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

public class BluetoothClient: BorrowProtocol, ReturnProtocol {
    
    func performBorrow(operation: BikeOperation) {}
    
    func performReturn(bike: Bike) {}
    
    func performConnection() {
        
    }
    
    var subject: PublishSubject<BikeStatus>
    let manager = CentralManager(queue: .main)
    private let serviceUUID = CBUUID(string: "FFE0")
    private let characteristicUUID = CBUUID(string: "FFE1")
    private var characteristic: Characteristic? = nil
    private let disposeBag: DisposeBag = DisposeBag()
    private var location: Location!
    private var planId: Int!
    private var bikeId: Int!
    private var singleSubject: PublishSubject<Session>
    private var returnSubject: PublishSubject<ReturnResponse>
    
    
    required public init() {
        self.subject = PublishSubject<BikeStatus>()
        self.singleSubject = PublishSubject<Session>()
        self.returnSubject = PublishSubject<ReturnResponse>()
        self.subject.dispose()
    }
    
    func borrow(bike: Bike, planId: Int, location: Location, nonce: Int) -> PrimitiveSequence<SingleTrait, Session> {
        
        self.location = location
        self.planId = planId
        self.bikeId = bike.id
        self.performBorrow(bikeName: bike.bike_name)
        return Single<Session>.create { observer in
            return self.singleSubject.subscribe{ session in
                observer(.success(session.element!))
            }
        }
    }
    
    public func performBorrow(bikeName: String){
        if self.characteristic != nil {
            self.characteristic?.writeValue(Data(bytes: Array("BORROW".utf8)), type: .withResponse).subscribe(onSuccess: { (characteristic) in
                self.characteristic = characteristic
                print("white success!!!")
            }, onError: { (error) in
                ErrorFactory.displayError(errorMessage: "Error on write command BORROW")
            }).disposed(by: self.disposeBag)
        } else {
        self.scanFor(bikeName: bikeName).observeOn(MainScheduler.instance   ).subscribe(onNext: { (scannedPheriperal) in
            self.subject.onNext(BikeStatus.FOUND_DEVICE)
            self.initCharacteristic(peripheral: scannedPheriperal.peripheral, action: "BORROW")
        }).disposed(by: self.disposeBag)
        }
        
    }
    
    func returnBike(bike: Bike, location: Location) -> Single<ReturnResponse> {
        self.location = location
        self.bikeId = bike.id
        if self.characteristic != nil {
            self.characteristic?.writeValue(Data(bytes: Array("RETURN".utf8)), type: .withResponse).subscribe(onSuccess: { (characteristic) in
                self.characteristic = characteristic
                print("white success!!!")
            }, onError: { (error) in
                ErrorFactory.displayError(errorMessage: "Error on write command RETURN")
            }).disposed(by: self.disposeBag)
        } else {
            self.scanFor(bikeName: bike.bike_name).observeOn(MainScheduler.instance).subscribe(onNext: { (scannedPheriperal) in
                
                self.subject.onNext(BikeStatus.FOUND_DEVICE)
                self.initCharacteristic(peripheral: scannedPheriperal.peripheral, action: "RETURN")
            }, onError: { error in
                ErrorFactory.displayError(errorMessage: "Error on write command RETURN")
            }).disposed(by: self.disposeBag)
        }
        
        return Single<ReturnResponse>.create { observer in
            return self.returnSubject.subscribe{ returnResponse in
                observer(.success(returnResponse.element!))
            }
        }
        
    }
    
    public func scanFor(bikeName : String) -> Observable<ScannedPeripheral> {
        self.subject.onNext(BikeStatus.SEARCHING_DEVICE)
        return manager.scanForPeripherals(withServices: [self.serviceUUID]).observeOn(MainScheduler.instance).filter({ (peripheral) -> Bool in
            return peripheral.peripheral.name == bikeName
        }).take(1).timeout(15.0, scheduler: MainScheduler.instance)
    }
    
    public func initCharacteristic(peripheral: Peripheral, action: String){
        print("check in")
        peripheral.establishConnection().flatMap { $0.discoverServices([self.serviceUUID]) }.asObservable()
            .flatMap { Observable.from($0) }
            .flatMap { $0.discoverCharacteristics([self.characteristicUUID])}.asObservable()
            .flatMap { Observable.from($0) }
            .subscribe(onNext: {  (characteristic) in
                self.characteristic = characteristic
                print(self.characteristic.debugDescription)
                characteristic.observeValueUpdateAndSetNotification().subscribe(onNext: { (characteristic) in
                    self.characteristic = characteristic
                    print("notification")
                    self.notificationHandler(command : (String(data:characteristic.value!, encoding: .utf8)?.split(separator: ",").map(String.init))!)
                    
                }).disposed(by: self.disposeBag)
                characteristic.writeValue(Data(bytes: Array(action.utf8)), type: .withResponse).subscribe(onSuccess: { (characteristic) in
                    self.characteristic = characteristic
                    print("white success!!!")
                }, onError: { (error) in
                    ErrorFactory.displayError(errorMessage: "Error init BORROW/RETURN command (charasteristic) at action " + action)
                }).disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
    }
    
    private func notificationHandler(command: [String]){
        print(command)
        switch command[0]{
        case "NONCE":
            self.connectToServer(nonce: command[1])
            break
        case "BORROW":
            print(command[1])
            break
        case "RETURN", "RETURNED":
            self.connectToServer(nonce: nil)
            break

        default:
            print("error si ai sus")
        }
    }
    
    private func connectToServer(nonce: String?){
        self.subject.onNext(BikeStatus.CONNECTING_SERVER)
        if nonce == nil {
            Api.returnBike(bikeId: String(self.bikeId), location: location, isCancel: false).subscribe(onSuccess: { (returnResponse) in
                self.subject.onNext(.RETURN_COMPLETED)
                self.returnSubject.onNext(returnResponse)
            }) { (error) in
                ErrorFactory.displayError(errorMessage: "Error connection to server to return")
                }.disposed(by: self.disposeBag)
        } else {
            Api.borrowBike(id: String(self.bikeId), nonce: Int(nonce!)!, location: self.location, planId: self.planId).observeOn(MainScheduler.instance).subscribe(onSuccess: { (bikeOperation) in
                self.subject.onNext(BikeStatus.CONNECTED_SERVER)
                self.singleSubject.onNext(bikeOperation.session)
                print(bikeOperation.message)
                self.deviceBorrow(message: bikeOperation.message)
            }) { (error) in
                ErrorFactory.displayError(errorMessage: "Error connection to server to borrow")
                }.disposed(by: self.disposeBag)
        }
        
    }
    
    private func deviceBorrow(message: String){
        self.subject.onNext(BikeStatus.CONNECTING_DEVICE)
        self.characteristic?.writeValue(Data(bytes: Array(message.utf8)), type: .withResponse).subscribe(onSuccess: { (characteristic) in
            print("write success")
            self.subject.onNext(BikeStatus.BORROW_COMPLETED)
        }, onError: { (error) in
            ErrorFactory.displayError(errorMessage: "Error bluetooth write encrypted emssage")
        }).disposed(by: self.disposeBag)
    }
    
    
    
    
    
    
    
}
