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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    public let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.layer.cornerRadius = 15.0
        self.usernameField.layer.borderColor = UIColor.lightGray.cgColor
        self.usernameField.layer.borderWidth = 0.5
       
        self.loginButton.layer.cornerRadius = 15.0
        self.loginButton.layer.borderColor = UIColor(hexString: Constants.KMITL_PRIMARY_COLOR).cgColor
        self.loginButton.layer.borderWidth = 0.5
        self.loginButton.backgroundColor = UIColor(hexString: Constants.KMITL_PRIMARY_COLOR)
        self.registerButton.layer.cornerRadius = 15.0
        self.registerButton.layer.borderColor = UIColor(hexString: Constants.KMITL_PRIMARY_COLOR).cgColor
        self.registerButton.layer.borderWidth = 0.5
        self.registerButton.backgroundColor = UIColor(hexString: Constants.KMITL_PRIMARY_COLOR)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        bindRx()
        // Do any additional setup after loading the view, typically from a nib.
    }

    private func bindRx(){
        usernameField.becomeFirstResponder()
        self.usernameField.rx.text.bind(to: self.viewModel.inputs.username).disposed(by: self.disposeBag)
        self.loginButton.rx.tap.bind(to:self.viewModel.inputs.loginPress).disposed(by: self.disposeBag)
       
        self.viewModel.signin.subscribeOn(MainScheduler.instance).subscribe { (user) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            homeViewController.viewModel.currentUser = user.element!
            self.present(homeViewController, animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        usernameField.resignFirstResponder()
     
    }

}

