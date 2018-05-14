//
//  BikeOperationProtocol.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/14/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift


protocol BikeOperationProtocol {
    var subject: PublishSubject<BikeStatus> { get set }
    init()
}

extension BikeOperationProtocol {
    init(subject: PublishSubject<BikeStatus>){
        self.init()
        self.subject = subject
    }
}
