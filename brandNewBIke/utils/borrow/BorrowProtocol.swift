//
//  BorrowProtocol.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/24/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

public protocol BorrowProtocol {
    func borrow(bike: Bike) -> Single<Bool>
}
