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
    var signin : PublishSubject<User?> { get }
}

protocol LoginViewModelTypes {
    var inputs : LoginViewModelInputs { get }
    var outputs : LoginViewModelOutputs { get }
}

class LoginViewModel: LoginViewModelInputs, LoginViewModelTypes, LoginViewModelOutputs {
    
    var disposedBag: DisposeBag = DisposeBag()
    
    var inputs: LoginViewModelInputs { return self }
    
    var outputs: LoginViewModelOutputs { return self }
    
    var signin: PublishSubject<User?>

    let username: PublishSubject<String?>
    
    var password: PublishSubject<String?>
    
    var loginPress: PublishSubject<Void>
    
    let localStorage = UserDefaults.standard
    
    
    init() {
        username = PublishSubject<String?>()
        password = PublishSubject<String?>()
        loginPress = PublishSubject<Void>()
        signin = PublishSubject<User?>()

        if let token = localStorage.string(forKey: StorageKey.TOKEN_KEY) {
            
            self.disposedBag.insert(
                Api.getUserFromToken(token: token).subscribe(
                    onSuccess: { (user) in
                        self.onLogin(user: user)
                    },
                    onError: { (error) in print(error)}) )
        }
        
        let userAndPassword = Driver.combineLatest(self.username.asDriver(onErrorJustReturn: nil),
                                                   self.password.asDriver(onErrorJustReturn: nil)) { ($0,$1)  }
        self.disposedBag.insert(self.loginPress.withLatestFrom(userAndPassword).flatMapLatest { (arg) -> Single<User> in
            let (user, password) = arg
            return Api.login(username: user!, password: password!)
            }
            .subscribe(
                onNext: { (user) in
                    self.onLogin(user: user)
            }, onError: { (error) in
                print(error)
            })
        )
        
        
    }
    
    private func onLogin(user: User){
        localStorage.set(user.token, forKey: StorageKey.TOKEN_KEY)
    
        self.signin.onNext(user)
    }
    
    
}
