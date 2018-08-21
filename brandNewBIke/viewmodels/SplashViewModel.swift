//
//  SplashViewModel.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/20/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

class SplashViewModel: SplashViewModelTypes, SplashViewModelInput, SplashViewModelOutput {
    var inputs: SplashViewModelInput { return self }
    var outputs: SplashViewModelOutput { return self }
    var tokenValidate: PublishSubject<User?>
    let localStorage = UserDefaults.standard
    let disposedBag = DisposeBag()
    init(){
        tokenValidate = PublishSubject<User?>()
    }
    
    public func validateToken(){
        if let token = localStorage.string(forKey: StorageKey.TOKEN_KEY) {
            self.disposedBag.insert(
                Api.getUserFromToken(token: token).timeout(8, scheduler: MainScheduler.instance)
                    .subscribe(onSuccess: { (user) in
                        self.tokenValidate.onNext(user)
                    }, onError: { (error) in
                        self.tokenValidate.onNext(nil)
                }))
        } else {
            self.tokenValidate.onNext(nil)
        }
        
    }
    
}
