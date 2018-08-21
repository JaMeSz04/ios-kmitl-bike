//
//  RegisterProtocol.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 8/21/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

protocol RegisterViewModelInputs {
    var username : PublishSubject<String?> { get }
    var fullname : PublishSubject<String?> { get }
    var email : PublishSubject<String?> { get }
    var phoneno : PublishSubject<String?> { get }
    var gender : PublishSubject<Int?> { get }
    var registerPress : PublishSubject<Void> { get }
}

protocol RegisterViewModelOutputs {
    var onSignup : PublishSubject<User> { get }
}

protocol RegisterViewModelTypes {
    var inputs : RegisterViewModelInputs { get }
    var outputs : RegisterViewModelOutputs { get }
}
