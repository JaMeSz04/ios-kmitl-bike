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
    
    init() {
        Locator.requestAuthorizationIfNeeded()
        location = PublishSubject<Location>()
        locationRequest = PublishSubject<Bool>()
        bottomSheetPageRequest = PublishSubject<Void>()
        bottomSheetItem = PublishSubject<PageBulletinItem>()
        
        locationRequest.observeOn(MainScheduler.instance).subscribe { isContinue in
            self.getLatestLocation()
        }.disposed(by: self.disposeBag)
        
        bottomSheetPageRequest.observeOn(MainScheduler.instance).subscribe{ () in
            
        }.disposed(by: self.disposeBag)
      
    }
    
    public static func getRootButtomSheet() -> PageBulletinItem {
        let rootItem : PageBulletinItem = PageBulletinItem(title: "Get ready to scan")
        rootItem.image = UIImage(named: "qrIcon")
        rootItem.descriptionText = "Improper used of the system may result as crime"
        rootItem.actionButtonTitle = "Subscribe"
        rootItem.isDismissable = true
        return rootItem
    }
    
    public func getLatestLocation() {
        Locator.currentPosition(accuracy: .room, onSuccess: { (location) -> (Void) in
            self.location.onNext(Location( lat: location.coordinate.latitude, long: location.coordinate.longitude ))
        }, onFail: { (_,_) in })
    }
    
}


