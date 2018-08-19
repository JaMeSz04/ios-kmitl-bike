//
//  HomeViewModelBottomSheetExtension.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import BulletinBoard
import RxSwift

extension HomeViewModel {
    public func getBottomSheet() -> PageBulletinItem {
        return self.bulletinFactory.getPageItem()
    }
    
    func loadBikeInfoPage(bike: Bike) -> PageBulletinItem {
        
        let img = self.getBikeAsset(model: bike.bike_model)
        let page = PageBulletinItem(title: "Your bike is ready")
        page.image = resizeImage(image: UIImage(named: img)!, targetSize: CGSize(width: 600.0, height: 400.0))
        page.descriptionText = bike.bike_model
        page.actionButtonTitle = "Borrow"
        page.actionHandler = { (item:PageBulletinItem) in
            if (self.currentBluetoothState == "avaliable") {
                item.manager?.displayActivityIndicator()
                self.borrowBike(bike: bike)
            } else {
                ErrorFactory.displayError(errorMessage: "Please enable or reset your bluetooth!!!")
                item.manager?.dismissBulletin()
            }
        }
        page.alternativeButtonTitle = "Re scan"
        page.alternativeHandler = { (item:PageBulletinItem) in
            self.instructionAction.onNext(item)
        }
        
        page.interfaceFactory.tintColor = .black
        if bike.bike_model == Constants.GIANT_ESCAPE {
            page.nextItem = self.loadBorrowSuccessPage(password: nil)
        } else {
            page.nextItem = self.loadBorrowSuccessPage(password: bike.mac_address)
        }
        page.isDismissable = true
        self.currentPage = page
        return page
    }
    
    public func getRootBottomSheet() -> PageBulletinItem {
        let rootItem = PageBulletinItem(title: "Get ready to scan")
        rootItem.descriptionText = "Point your camera to QRCode sign on the bike"
        rootItem.image = resizeImage(image: UIImage(named: "qrIcon")!, targetSize: CGSize(width: 600.0, height: 400.0))
        rootItem.actionButtonTitle = "Scan"
        rootItem.actionHandler = { (item:PageBulletinItem) in
            self.instructionAction.onNext(item)
        }
        rootItem.interfaceFactory.tintColor = UIColor(hexString: Constants.KMITL_PRIMARY_COLOR)
        
        rootItem.isDismissable = true
        
        return rootItem
    }
    
    func loadBorrowSuccessPage(password: String?) -> PageBulletinItem {
        let page = PageBulletinItem(title: "All set")
        if password != nil {
            page.descriptionText = "The password is " + password!
        } else {
            page.descriptionText = "Enjoy the ride!"
        }
        page.actionButtonTitle = "Start using the bike"
        page.actionHandler = { (item:PageBulletinItem) in
            item.manager?.dismissBulletin()
            //self.resetBulletin.onNext(())
            self.isTracking = true
            item.manager? = BulletinManager(rootItem : self.loadTrackingPage())
            self.bikeOperationStatus.onNext(BikeStatus.TRACKING)
        }
        page.interfaceFactory.tintColor = .black
        self.currentPage = page
        return page
    }
    
    public func loadReturnSuccessPage() -> PageBulletinItem {
        let thankyouPage = PageBulletinItem(title: "Thank you for using KMITL Bike")
        thankyouPage.descriptionText = "You can submit your feedback at our KMITL Bike Facebook Fanpage"
        thankyouPage.alternativeButtonTitle = "No Thanks"
        thankyouPage.actionButtonTitle = "Submit feedback"
        thankyouPage.alternativeHandler = { (item:PageBulletinItem) in
            item.manager?.dismissBulletin()
            item.manager? = BulletinManager(rootItem : self.getRootBottomSheet())
        }
        
        thankyouPage.image = resizeImage(image: UIImage(named: "feedbackIcon")!, targetSize: CGSize(width: 600.0, height: 400.0))
        thankyouPage.interfaceFactory.tintColor = UIColor(hexString: Constants.KMITL_PRIMARY_COLOR)
        thankyouPage.actionHandler = { (item:PageBulletinItem) in
            item.manager?.dismissBulletin()
            UIApplication.shared.open(URL(string: "https://www.facebook.com/kmitlgreencampus/")!, options: [:])
        }
        
        return thankyouPage
    }
    
    public func getCurrentPage() -> PageBulletinItem {
        return self.currentPage
    }
    
    public func loadTrackingPage() -> PageBulletinItem {
        let time = Array(self.currentSession.timestamps!.borrow_time.split(separator: ":"))
        let modTime = Int(time[0])! + 1
        var newTime = ""
        if String(modTime).count == 1 {
            newTime += "0"
        }
        newTime += String(modTime)
        
        let page = PageBulletinItem(title: "Please return before " + newTime + ":" + time[1])
        page.descriptionText = "Failure to return within time may result as ban"
        page.actionButtonTitle = "Scan"
        let img = self.getBikeAsset(model: self.currentBike.bike_model)
        page.image = resizeImage(image: UIImage(named: img)!, targetSize: CGSize(width: 600.0, height: 400.0))
        page.actionHandler = { (item:PageBulletinItem) in
            if self.currentBluetoothState == "avaliable"{
                self.instructionAction.onNext(item)
            } else {
                ErrorFactory.displayError(errorMessage: "Please enable or reset your bluetooth!!!")
                item.manager?.dismissBulletin()
            }
        }
        page.isDismissable = true
        page.interfaceFactory.tintColor = UIColor(hexString: Constants.KMITL_PRIMARY_COLOR)
            
        page.alternativeButtonTitle = "cancel"
        page.alternativeHandler = { (item:PageBulletinItem) in
            item.manager?.dismissBulletin()
        }
        return page
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
