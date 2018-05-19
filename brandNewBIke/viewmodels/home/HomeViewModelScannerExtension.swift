//
//  HomeViewModelScannerExtension.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation


extension HomeViewModel {
    func onScannerCompleted(code: String) {
        if self.isTracking {
            self.validateReturn(code: code)
            print("done")
        } else {
            let bike = self.getBikeFromCode(code: code)
            print("found bike: " + bike.bike_name)
            self.bottomSheetItem.onNext(self.loadBikeInfoPage(bike: bike))
        }
    }
    
    
    func getBikeFromCode(code:String) -> Bike {
        return self.internalBikeList.filter{ bike in bike.barcode == code }[0]
    }
}
