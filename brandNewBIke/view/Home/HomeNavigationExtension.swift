//
//  HomeNavigationExtension.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import SideMenu

extension HomeViewController: NavigationDelegate {
    
    func setupSideMenu(){
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.width * 0.8
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        navigationViewController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! NavigationViewController
        navigationViewController.rootDelegate = self
        navigationViewController.name =  self.viewModel.currentUser.first_name + " " + self.viewModel.currentUser.last_name
        navigationViewController.subname = self.viewModel.currentUser.email
        let navigationMenu = UISideMenuNavigationController(rootViewController: navigationViewController)
        navigationMenu.isNavigationBarHidden = true
        
        SideMenuManager.default.menuLeftNavigationController = navigationMenu
        //SideMenuManager.default.menuAddPanGestureToPresent(toView:(self.navigationController?.navigationBar)!)
        //SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
    }
    
    func onHomePress() {
        self.dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileTableViewController") as! ProfileTableViewController
        profileViewController.viewModel.userId = self.viewModel.currentUser.id
        
        self.present(profileViewController, animated: true, completion: nil)
    }
    
    func onReportPress() {
        UIApplication.shared.open(URL(string: "https://www.facebook.com/kmitlgreencampus/")!, options: [:])
    }
    
    func onTermsAndConditionPress() {
//        self.dismiss(animated: true, completion: nil)
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let termViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionViewController
//        self.present(termViewController, animated: true, completion: nil)
        UIApplication.shared.open(URL(string: "http://161.246.94.246:1995/api/v1/info/terms_conditions")!, options: [:])
        
        
    }
    
    func onLogoutPress() {
        self.dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    
}
