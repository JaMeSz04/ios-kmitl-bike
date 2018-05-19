//
//  HomeViewModelProtocols.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift
import BulletinBoard


protocol HomeViewModelInputs {
    var bottomSheetPageRequest: PublishSubject<Void> { get }
    var refreshBikeLocation: PublishSubject<Location> { get }
    var scannerBikeUpdate: PublishSubject<String> { get }
    var onLocationUpdate: PublishSubject<Location> { get }
}

protocol HomeViewModelOutputs {
    var location: PublishSubject<Location> { get }
    var bottomSheetItem: PublishSubject<PageBulletinItem> { get }
    var instructionAction: PublishSubject<PageBulletinItem> { get }
    var bikeList: PublishSubject<[Bike]> { get }
    var resetBulletin: PublishSubject<Void> { get }
    var bikeOperationStatus: PublishSubject<BikeStatus> { get }
}

protocol HomeViewModelType {
    var inputs : HomeViewModelInputs { get }
    var outputs : HomeViewModelOutputs { get }
}
