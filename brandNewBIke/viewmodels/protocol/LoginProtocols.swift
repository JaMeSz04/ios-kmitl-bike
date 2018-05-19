//
//  LoginProtocols.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift


protocol LoginViewModelInputs {
    var username : PublishSubject<String?> { get }
    var password : PublishSubject<String?> { get }
    var loginPress : PublishSubject<Void> { get }
}

protocol LoginViewModelOutputs {
    var signin : PublishSubject<User?> { get }
}

protocol LoginViewModelTypes {
    var inputs : LoginViewModelInputs { get }
    var outputs : LoginViewModelOutputs { get }
}
