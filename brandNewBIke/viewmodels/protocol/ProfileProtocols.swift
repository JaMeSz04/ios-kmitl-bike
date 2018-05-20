//
//  ProfileProtocols.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/21/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfileViewModelInput {
    
}

protocol ProfileViewModelOutput {
    var onHistoriesLoad: PublishSubject<[Session]> { get }
}


protocol ProfileViewModelTypes {
    var inputs : ProfileViewModelInput { get }
    var outputs : ProfileViewModelOutput { get }
}
