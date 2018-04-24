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



protocol HomeViewModelInputs {
    var locationRequest: PublishSubject<Bool> { get }
    var bottomSheetPageRequest: PublishSubject<Void> { get }
}

protocol HomeViewModelOutputs {
    var location: PublishSubject<Location> { get }
    var bottomSheetItem: PublishSubject<PageBulletinItem> { get }
    var instructionAction: PublishSubject<PageBulletinItem> { get }
    var bikeList: PublishSubject<[Bike]> { get }
}

protocol HomeViewModelType {
    var inputs : HomeViewModelInputs { get }
    var outputs : HomeViewModelOutputs { get }
}

class HomeViewModel: HomeViewModelType, HomeViewModelInputs, HomeViewModelOutputs {
    
    let disposeBag = DisposeBag()
    var location: PublishSubject<Location>
    var inputs : HomeViewModelInputs { return self }
    var outputs : HomeViewModelOutputs { return self }
    var locationRequest: PublishSubject<Bool>
    var bottomSheetPageRequest: PublishSubject<Void>
    var bottomSheetItem: PublishSubject<PageBulletinItem>
    var instructionAction: PublishSubject<PageBulletinItem>
    var bikeList: PublishSubject<[Bike]>
    let bulletinFactory: BulletinFactory = BulletinFactory()
    
    init() {
        Locator.requestAuthorizationIfNeeded()
        location = PublishSubject<Location>()
        locationRequest = PublishSubject<Bool>()
        bottomSheetPageRequest = PublishSubject<Void>()
        bottomSheetItem = PublishSubject<PageBulletinItem>()
        instructionAction = PublishSubject<PageBulletinItem>()
        bikeList = PublishSubject<[Bike]>()
        
        locationRequest.observeOn(MainScheduler.instance).subscribe { isContinue in
            self.getLatestLocation()
        }.disposed(by: self.disposeBag)
        
        bottomSheetPageRequest.observeOn(MainScheduler.instance).subscribe(onNext: { () in
            self.bottomSheetItem.onNext(self.getBottomSheet())
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            
        }).disposed(by: self.disposeBag)
        
        self.initializeBulletinBoard()
      
    }
    
    private func initializeBulletinBoard(){
        self.bulletinFactory.addPage(title: "Get ready to scan", subtitle: "Please return the bike within 1 hour", image: UIImage(named: "qrIcon")!, buttonText: "Got it", action: self.instructionAction)
    }
    
    public func getBottomSheet() -> PageBulletinItem {
        return self.bulletinFactory.getPageItem()
    }
    
    public func getRootBottomSheet() -> PageBulletinItem {
        return self.bulletinFactory.getRoot()
    }
    
    public func getLatestLocation() {
        Locator.currentPosition(accuracy: .room, onSuccess: { (location) -> (Void) in
            self.location.onNext(Location( lat: location.coordinate.latitude, long: location.coordinate.longitude ))
        }, onFail: { (_,_) in })
    }
    
}


