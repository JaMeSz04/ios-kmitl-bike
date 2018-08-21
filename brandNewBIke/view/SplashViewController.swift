//
//  SplashViewController.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/20/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SplashViewController: UIViewController {

    private let viewModel = SplashViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.outputs.tokenValidate.observeOn(MainScheduler.instance).subscribe{ user in
            let value = user.element!
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if value != nil {
                let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                homeViewController.viewModel.currentUser = value
                let navController = UINavigationController(rootViewController: homeViewController)
                self.present(navController, animated: true, completion: nil)
            } else {
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true, completion: nil)
            }
            }.disposed(by: self.disposeBag)
        
        self.viewModel.validateToken()
    }
    
    override func viewDidLoad() {
        print("hehe")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
