//
//  ProfileViewModel.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/21/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import RxSwift

class ProfileViewModel: ProfileViewModelTypes, ProfileViewModelInput, ProfileViewModelOutput {
    
    var onHistoriesLoad: PublishSubject<[Session]>
    var userId: Int!
    var inputs: ProfileViewModelInput { return self }
    var outputs: ProfileViewModelOutput { return self }
    let disposeBag: DisposeBag = DisposeBag()
    
    init(){
        onHistoriesLoad = PublishSubject<[Session]>()
    }
    
    public func fetchData(){
        Api.getHistories(userId: String(userId)).observeOn(MainScheduler.instance).flatMap({ (userSessions) -> Single<[Session]> in
            if userSessions.count > 20 {
                return Single.just(Array(userSessions.prefix(20)))
            } else {
                return Single.just(userSessions)
            }
        }).subscribe(onSuccess: { (userSessions) in
            print(userSessions)
            self.onHistoriesLoad.onNext(userSessions)
        }) { (error) in
            print(error)
        }.disposed(by: self.disposeBag)
    }
}
