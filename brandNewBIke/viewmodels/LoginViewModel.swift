//
//  LoginViewModel.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/18/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelInputs {
    var username : PublishSubject<String?> { get }
    var password : PublishSubject<String?> { get }
    var loginPress : PublishSubject<Void> { get }
}

protocol LoginViewModelOutputs {
    var signin : Driver<Bool> { get }
}

protocol LoginViewModelTypes {
    var inputs : LoginViewModelInputs { get }
    var outputs : LoginViewModelOutputs { get }
}

class LoginViewModel: LoginViewModelInputs, LoginViewModelTypes, LoginViewModelOutputs {
    
    var signin: Driver<Bool>
    
    var disposedBag: DisposeBag = DisposeBag()
    
    var inputs: LoginViewModelInputs { return self }
    
    var outputs: LoginViewModelOutputs { return self }

    let username: PublishSubject<String?> = PublishSubject<String?>()
    
    var password: PublishSubject<String?> = PublishSubject<String?>()
    
    var loginPress: PublishSubject<Void>  = PublishSubject<Void>()
    
    
    init() {
        
        let userAndPassword = Driver.combineLatest(self.username.asDriver(onErrorJustReturn: nil),
                                                    self.password.asDriver(onErrorJustReturn: nil)) { ($0,$1) }
        self.signin = self.loginPress
            .asDriver(onErrorJustReturn:(print("ERROR")))
            .withLatestFrom(userAndPassword)
            .flatMapLatest{ (user, pass) in
                print("check~~~")
                return Api.login(username: user!, password: pass!).asDriver(onErrorJustReturn: false)
            }
        print("init")
        
    }
        
        
    
    
    public func initSubscription(){
        self.disposedBag.insert(self.loginPress.subscribe { (_) in
            print("hehe")
        })
    }
    
    
    
}
