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
    
    func performReturn(bike: BikeResponse) {}
    
    func performConnection() {
        
    }
    var subject: PublishSubject<BikeStatus>
    let manager = CentralManager(queue: .main)
    private let serviceUUID = CBUUID(string: "FFE0")
    private let characteristicUUID = CBUUID(string: "FFE1")
    private var characteristic: Characteristic? = nil
    private let disposeBag: DisposeBag = DisposeBag()
    
    
    required public init() {
        self.subject = PublishSubject<BikeStatus>()
        self.subject.dispose()
    }
    
    public func performBorrow(operation: BikeOperation){
        print("Perform borrowwww")
    }
    
    public func scanFor(bikeName : String) -> Observable<ScannedPeripheral> {
        return manager.scanForPeripherals(withServices: [self.serviceUUID]).filter({ (peripheral) -> Bool in
            return peripheral.peripheral.name == bikeName
        }).take(1).timeout(10.0, scheduler: MainScheduler.instance)
    }
    
    public func initCharacteristic(peripheral: Peripheral){
        peripheral.establishConnection().flatMap { $0.discoverServices([self.serviceUUID]) }.asObservable()
            .flatMap { Observable.from($0) }
            .flatMap { $0.discoverCharacteristics([self.characteristicUUID])}.asObservable()
            .flatMap { Observable.from($0) }
            .subscribe(onNext: { characteristic in self.characteristic = characteristic }).disposed(by: self.disposeBag)
    }
    
    
    
    
    
    
    
}
