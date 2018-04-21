//
//  protocol.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
    
}
