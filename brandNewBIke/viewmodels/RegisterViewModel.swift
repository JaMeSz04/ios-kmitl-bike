//
//  RegisterViewModel.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 8/21/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel: RegisterViewModelTypes, RegisterViewModelInputs, RegisterViewModelOutputs {
    
    var inputs: RegisterViewModelInputs { return self }
    
    var outputs: RegisterViewModelOutputs { return self }
    
    var username: PublishSubject<String?>
    
    var fullname: PublishSubject<String?>
    
    var email: PublishSubject<String?>
    
    var phoneno: PublishSubject<String?>
    
    var gender: PublishSubject<Int?>
    
    var registerPress: PublishSubject<Void>
    
    var onSignup: PublishSubject<User>
    
    let disposeBag = DisposeBag()
    
    let localStorage = UserDefaults.standard
    
    public init(){
        username = PublishSubject<String?>()
        fullname = PublishSubject<String?>()
        email = PublishSubject<String?>()
        phoneno = PublishSubject<String?>()
        gender = PublishSubject<Int?>()
        registerPress = PublishSubject<Void>()
        onSignup = PublishSubject<User>()
        
        bindRx()
    }
    
    private func bindRx(){
    
        let form =  Driver.combineLatest(self.username.asDriver(onErrorJustReturn: nil),
                                                              self.fullname.asDriver(onErrorJustReturn: nil),
                                                              self.email.asDriver(onErrorJustReturn: nil),
                                                              self.phoneno.asDriver(onErrorJustReturn: nil),
                                                              self.gender.asDriver(onErrorJustReturn: nil)) { ($0,$1,$2,$3,$4) }
        var userName:String? = nil
        self.registerPress.withLatestFrom(form).flatMapLatest { (arg) -> Single<RegisterResponse> in
                let (user, fullname, email, phoneno, gender) = arg
                print(gender)
                userName = user
                let splitName = fullname?.split(separator: " ")
            return Api.register(username: user!, firstName: String(splitName![0]), lastName: String(splitName![1]), email: email!, phoneno: phoneno!, gender: (gender! + 1))
            }.subscribe(onNext: { (response) in
                if response.result {
                    self.login(username: userName!)
                }
            }, onError: { (error) in
                ErrorFactory.displayError(errorMessage: "Unable to register to system...")
            }).disposed(by: self.disposeBag)
        
    }
    
    private func login(username:String){
        Api.login(username: username, password: "123456").subscribe(onSuccess: { (user) in
            self.localStorage.set(user.token, forKey: StorageKey.TOKEN_KEY)
            self.onSignup.onNext(user)
        }) { (error) in
            ErrorFactory.displayError(errorMessage: "Unable to login to the system...")
        }.disposed(by: self.disposeBag)
    }
    
    
    
}
