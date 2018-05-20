//
//  BorrowProtocol.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/24/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

protocol BorrowProtocol: BikeOperationProtocol {
    func performBorrow(bikeName: String)
    func performConnection()
    func borrow(bike: Bike, planId: Int, location: Location, nonce: Int) -> Single<Session>
}

