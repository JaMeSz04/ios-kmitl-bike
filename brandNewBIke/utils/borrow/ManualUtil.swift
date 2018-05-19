//
//  ManualUtil.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/24/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

public class ManualClient: BorrowProtocol, ReturnProtocol {
    func performReturn(bike: BikeResponse) {
        print("perform return!!!!")
        self.subject.onNext(.RETURN_COMPLETED)
    }
    
    
    func performConnection() {}
    
    required public init() {
        self.subject = PublishSubject<BikeStatus>()
        self.subject.dispose()
    }
    
    var subject: PublishSubject<BikeStatus>

    public func performBorrow(operation: BikeOperation) {
        print("Perform borrowwww!!!ed")
        self.subject.onNext(BikeStatus.BORROW_COMPLETED)
       
    }
    
    

}
