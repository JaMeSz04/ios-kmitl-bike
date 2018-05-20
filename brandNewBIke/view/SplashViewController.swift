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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.outputs.tokenValidate.observeOn(MainScheduler.instance).subscribe{ user in
            let value = user.element!
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if value != nil {
                let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                homeViewController.viewModel.currentUser = value
                self.present(homeViewController, animated: true, completion: nil)
            } else {
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true, completion: nil)
            }
        }.disposed(by: self.disposeBag)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
