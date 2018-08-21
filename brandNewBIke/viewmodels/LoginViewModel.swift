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
        
        let userAndPassword = Driver.combineLatest(self.username.asDriver(onErrorJustReturn: nil),
                                                   self.password.asDriver(onErrorJustReturn: nil)) { ($0,$1)  }
        self.loginPress.withLatestFrom(userAndPassword).flatMapLatest { (arg) -> Single<User> in
            let (user, password) = arg
            return Api.login(username: user!, password: "123456") //in real auth system... use password
            }
            .subscribe(
                onNext: { (user) in
                    self.onLogin(user: user)
            }, onError: { (error) in
                print(error)
                ErrorFactory.displayError(errorMessage: "Unable to Login")
            }).disposed(by: self.disposedBag)
        
    }
    
    private func onLogin(user: User){
        localStorage.set(user.token, forKey: StorageKey.TOKEN_KEY)
        self.signin.onNext(user)
    }
    
    public func clear(){
        localStorage.removeObject(forKey: StorageKey.TOKEN_KEY)
    }
    
    
    
    
    
    
}
