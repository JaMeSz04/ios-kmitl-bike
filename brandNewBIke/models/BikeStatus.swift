//
//  BikeStatus.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/11/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation


enum BikeStatus {
    case CONNECTING_SERVER
    case CONNECTED_SERVER
    case SEARCHING_DEVICE
    case FOUND_DEVICE
    case CONNECTING_DEVICE
    case CONNECTED_DEVICE
    case BORROWING_BIKE
    case BORROW_COMPLETED
    case RETURNING_DEVICE
    case RETURN_COMPLETED
    case TRACKING
}


extension BikeStatus {
    var description: String {
        switch self {
            case .CONNECTING_SERVER: return "Connecting to the server"
            case .CONNECTED_SERVER: return "Connected"
            case .SEARCHING_DEVICE: return "Searching the bike"
            case .FOUND_DEVICE: return "Bike founded"
            case .CONNECTING_DEVICE: return "Connecting to the bike"
            case .CONNECTED_DEVICE: return "Device connected"
            case .BORROWING_BIKE: return "Borrowing"
            case .BORROW_COMPLETED: return "Borrow Completed"
            case .RETURNING_DEVICE: return "Returning"
            case .RETURN_COMPLETED: return "Return Completed"
            case .TRACKING: return "Tracking"
        }
    }
}

