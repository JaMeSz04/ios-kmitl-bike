//
//  NavigationViewController.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FontAwesome_swift

class NavigationViewController: UIViewController {
    
    var rootDelegate: NavigationDelegate!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subnameLabel: UILabel!
    
    var name: String = ""
    var subname: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = self.name
        self.subnameLabel.text = self.subname
        self.historyButton.setImage(UIImage.fontAwesomeIcon(name: .history, textColor: UIColor.darkGray, size: CGSize(width: 40, height: 40)), for: .normal)
        self.reportButton.setImage(UIImage.fontAwesomeIcon(name: .bug, textColor: UIColor.darkGray, size: CGSize(width: 40, height: 40)), for: .normal)
        self.termsButton.setImage(UIImage.fontAwesomeIcon(name: .file, textColor: UIColor.darkGray, size: CGSize(width: 40, height: 40)), for: .normal)
        self.logoutButton.setImage(UIImage.fontAwesomeIcon(name: .signOut, textColor: UIColor.darkGray, size: CGSize(width: 40, height: 40)), for: .normal)
        self.bindRx()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLabel(title: String, subtitle: String){
        self.nameLabel.text = title
        self.subnameLabel.text = subtitle
    }
    
    private func bindRx(){
        historyButton.rx.tap.observeOn(MainScheduler.instance).subscribe{ event in
            self.rootDelegate.onHomePress()
        }.disposed(by: self.disposeBag)
        
        reportButton.rx.tap.observeOn(MainScheduler.instance).subscribe{ event in
            self.rootDelegate.onReportPress()
        }.disposed(by: self.disposeBag)
        
        termsButton.rx.tap.observeOn(MainScheduler.instance).subscribe{ event in
            self.rootDelegate.onTermsAndConditionPress()
        }.disposed(by: self.disposeBag)
        
        logoutButton.rx.tap.observeOn(MainScheduler.instance).subscribe{ event in
            self.rootDelegate.onLogoutPress()
        }.disposed(by: self.disposeBag)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
