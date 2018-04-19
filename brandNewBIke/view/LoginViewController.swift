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
    
    
    @IBAction func onTap(_ sender: Any) {
        print("HEHE")
    }
    private func bindRx(){
        usernameField.becomeFirstResponder()
        self.usernameField.rx.text.bind(to: self.viewModel.inputs.username).disposed(by: self.disposeBag)
        self.passwordField.rx.text.bind(to: self.viewModel.inputs.password).disposed(by: self.disposeBag)
        self.loginButton.rx.tap.bind(to:self.viewModel.inputs.loginPress).disposed(by: self.disposeBag)
        
        self.viewModel.outputs.signin.drive( onNext: { signedin in
            print("test")
            if signedin == true {
                print("p")
            }
        }).disposed(by: self.disposeBag)
        
        //self.viewModel.test()
        
        
        //print(self.viewModel.inputs.loginPress)
        //self.viewModel.login(user: "57090016", pass: "EEI0S2wO")
        //usernameField.rx.text.bind(to: self.viewModel.inputs.username).disposed(by: disposeBag)
        //passwordField.rx.text.bind(to: self.viewModel.inputs.password).disposed(by: disposeBag)
        //loginButton.rx.tap.bind(to: self.viewModel.inputs.loginPress).disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

