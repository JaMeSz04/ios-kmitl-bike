//
//  RegisterViewController.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 8/21/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var genderSelector: UISegmentedControl!
    private let viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerButton.layer.cornerRadius = 15.0
        self.registerButton.layer.borderColor = UIColor(hexString: Constants.KMITL_PRIMARY_COLOR).cgColor
        self.registerButton.layer.borderWidth = 0.5
        self.registerButton.backgroundColor = UIColor(hexString: Constants.KMITL_PRIMARY_COLOR)
        bindRx()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    private func bindRx(){
        //fullnameField.becomeFirstResponder()
        self.usernameField.rx.text.bind(to: self.viewModel.inputs.username).disposed(by: self.disposeBag)
        self.fullnameField.rx.text.bind(to: self.viewModel.inputs.fullname).disposed(by: self.disposeBag)
        self.emailField.rx.text.bind(to:self.viewModel.inputs.email).disposed(by: self.disposeBag)
        self.phoneField.rx.text.bind(to:self.viewModel.inputs.phoneno).disposed(by: self.disposeBag)
        self.genderSelector.rx.value.bind(to:self.viewModel.inputs.gender).disposed(by: self.disposeBag)
        self.registerButton.rx.tap.bind(to:self.viewModel.inputs.registerPress).disposed(by: self.disposeBag)
        
        self.viewModel.onSignup.subscribeOn(MainScheduler.instance).subscribe { (user) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            homeViewController.viewModel.currentUser = user.element!
            self.present(homeViewController, animated: true, completion: nil)
            }.disposed(by: self.disposeBag)
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        usernameField.resignFirstResponder()
        fullnameField.resignFirstResponder()
        phoneField.resignFirstResponder()
        emailField.resignFirstResponder()
    }
    

}
