//
//  SplashProtocols.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/20/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

protocol SplashViewModelInput {
    
}

protocol SplashViewModelOutput {
    var tokenValidate: PublishSubject<User?> { get }
}


protocol SplashViewModelTypes {
    var inputs : SplashViewModelInput { get }
    var outputs : SplashViewModelOutput { get }
}
