//
//  HomeCentralManagerDelegate.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 6/26/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import CoreBluetooth


extension HomeViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            self.viewModel.inputs.bluetoothStateUpdate.onNext("unknown")
        case .resetting:
            self.viewModel.inputs.bluetoothStateUpdate.onNext("not avaliable")
        case .unsupported:
            self.viewModel.inputs.bluetoothStateUpdate.onNext("not supported")
        case .unauthorized:
            self.viewModel.inputs.bluetoothStateUpdate.onNext("not authorized")
        case .poweredOff:
            self.viewModel.inputs.bluetoothStateUpdate.onNext("off")
        case .poweredOn:
            self.viewModel.inputs.bluetoothStateUpdate.onNext("avaliable")
        }
    }
    
    
    
}
