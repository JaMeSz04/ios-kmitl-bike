//
//  ErrorFactory.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/21/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import SwiftMessages

class ErrorFactory {
    public static func displayError(errorMessage: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureDropShadow()
        
        
        view.configureContent(title: "Error!!!", body: errorMessage)
        SwiftMessages.show(view: view)
    }
}
