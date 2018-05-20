//
//  ReturnProtocol.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/14/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

protocol ReturnProtocol: BikeOperationProtocol {
    func performReturn(bike: Bike)
    func performConnection()
    func returnBike(bike: Bike, location: Location) -> Single<ReturnResponse>
}
