//
//  HomeViewModel.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/20/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import BulletinBoard
import RxSwift
import SwiftLocation
import MapKit
import SwiftMessages



class HomeViewModel: HomeViewModelType, HomeViewModelInputs, HomeViewModelOutputs {
    
    let disposeBag = DisposeBag()
    var location: PublishSubject<Location>
    var inputs : HomeViewModelInputs { return self }
    var outputs : HomeViewModelOutputs { return self }
    var locationRequest: PublishSubject<Bool>
    var bottomSheetPageRequest: PublishSubject<Void>
    var refreshBikeLocation: PublishSubject<Location>
    var onLocationUpdate: PublishSubject<Location>
    var resetBulletin: PublishSubject<Void>
    var scannerBikeUpdate: PublishSubject<String>
    var bottomSheetItem: PublishSubject<PageBulletinItem>
    var instructionAction: PublishSubject<PageBulletinItem>
    var bikeList: PublishSubject<[Bike]>
    var bikeOperationStatus: PublishSubject<BikeStatus>
    let bulletinFactory: BulletinFactory = BulletinFactory()
    let bluetoothStateUpdate: PublishSubject<String>
    
    var internalBikeList:[Bike]
    var currentPage: PageBulletinItem!
    var bluetoothUtil: BluetoothClient!
    var manualUtil: ManualClient!
    public var latestLocation: Location!
    public var isTracking: Bool = false
    public var currentSession: Session!
    public var currentUser: User!
    public var currentBike: Bike!
    public var locations: [CLLocationCoordinate2D]
    public var currentBluetoothState = "avaliable"
    
    init() {
        Locator.requestAuthorizationIfNeeded()
        location = PublishSubject<Location>()
        locationRequest = PublishSubject<Bool>()
        bottomSheetPageRequest = PublishSubject<Void>()
        refreshBikeLocation = PublishSubject<Location>()
        onLocationUpdate = PublishSubject<Location>()
        resetBulletin = PublishSubject<Void>()
        bottomSheetItem = PublishSubject<PageBulletinItem>()
        instructionAction = PublishSubject<PageBulletinItem>()
        scannerBikeUpdate = PublishSubject<String>()
        bikeOperationStatus = PublishSubject<BikeStatus>()
        bluetoothStateUpdate = PublishSubject<String>()
        bikeList = PublishSubject<[Bike]>()
        locations = [CLLocationCoordinate2D]()
      
        internalBikeList = [Bike]()
        
        currentPage = getRootBottomSheet()

        bottomSheetPageRequest.observeOn(MainScheduler.instance).subscribe(onNext: { () in
            self.bottomSheetItem.onNext(self.getBottomSheet())
        }).disposed(by: self.disposeBag)
        
        refreshBikeLocation.observeOn(MainScheduler.instance).subscribe(onNext: { (location) in
            self.latestLocation = location
        }).disposed(by: self.disposeBag)
        
        scannerBikeUpdate.observeOn(MainScheduler.instance).subscribe{ code in
            self.onScannerCompleted(code: code.element!)
        }.disposed(by: self.disposeBag)
        
        bluetoothStateUpdate.observeOn(MainScheduler.instance).subscribe{ state in
            self.currentBluetoothState = state.element!
        }
        
        onLocationUpdate.subscribe(onNext: { (location) in
            print("location updated tracking")
            Api.updateLocation(location: location).observeOn(MainScheduler.instance).subscribe({ (response) in
                print("location updated at : " + String(location.latitude) + " : " + String(location.longitude))
                self.latestLocation = location
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: self.disposeBag)
        
        self.bluetoothUtil = BluetoothClient(subject: self.bikeOperationStatus)
        self.manualUtil = ManualClient(subject: self.bikeOperationStatus)
        self.getBikeLocation()
    }
    
    func getBikeAsset(model: String) -> String {
        switch model {
            case Constants.GIANT_ESCAPE:
                return "giantEscape"
            case Constants.LA_BIKE_GREEN:
                return "LABikeGreen"
            default:
                return ""
        }
    }
    
    public func fetchSession(){
        Api.getUserSession(userId: String(self.currentUser.id)).observeOn(MainScheduler.instance).subscribe(onSuccess: { (session) in
            print(session)
            self.currentSession = session
            if session.resume! {
                self.currentBike = session.bike
                self.isTracking = session.resume!
                print(self.currentBike)
                self.latestLocation = session.route_line![session.route_line!.count - 1]
                if self.isTracking{
                    self.bikeOperationStatus.onNext(BikeStatus.BORROW_COMPLETED)
                    self.bikeOperationStatus.onNext(BikeStatus.TRACKING)
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func getBikeLocation(){
        Api.getBikeList().observeOn(MainScheduler.instance).subscribe(onSuccess: { (bikes) in
            self.bikeList.onNext(bikes)
            self.internalBikeList = bikes
        }) { (error) in
            ErrorFactory.displayError(errorMessage: "Could not get bike list")
        }.disposed(by: self.disposeBag)
    }
    
}


