//
//  LoginViewController.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/18/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya


class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindRx()
        // Do any additional setup after loading the view, typically from a nib.
    }

    private func bindRx(){
        usernameField.becomeFirstResponder()
        self.usernameField.rx.text.bind(to: self.viewModel.inputs.username).disposed(by: self.disposeBag)
        self.passwordField.rx.text.bind(to: self.viewModel.inputs.password).disposed(by: self.disposeBag)
        self.loginButton.rx.tap.bind(to:self.viewModel.inputs.loginPress).disposed(by: self.disposeBag)
        self.disposeBag.insert(
            self.viewModel.signin.subscribeOn(MainScheduler.instance).subscribe { user in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.present(homeViewController, animated: true, completion: nil)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

