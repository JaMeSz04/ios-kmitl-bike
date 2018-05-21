//
//  TermsAndConditionViewController.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/20/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import UIKit
import WebKit
class TermsAndConditionViewController: UIViewController {

 
    @IBOutlet weak var uiView: UIView!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: uiView.bounds, configuration: WKWebViewConfiguration())
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        uiView.addSubview(webView)
        let myURL = URL(string: "http://161.246.94.246:1995/api/v1/info/terms_conditions")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.title = "Terms and Conditions"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
