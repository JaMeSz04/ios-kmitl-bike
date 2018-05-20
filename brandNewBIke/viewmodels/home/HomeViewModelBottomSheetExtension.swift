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
            item.manager?.displayActivityIndicator()
            self.borrowBike(bike: bike)
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
        rootItem.image = UIImage(named: "qrIcon")
        rootItem.actionButtonTitle = "Scan"
        rootItem.actionHandler = { (item:PageBulletinItem) in
            self.instructionAction.onNext(item)
        }
        rootItem.interfaceFactory.tintColor = .black
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
        thankyouPage.interfaceFactory.tintColor = .black
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
            self.instructionAction.onNext(item)
        }
        page.isDismissable = true
        page.interfaceFactory.tintColor = .black
        page.alternativeButtonTitle = "cancel"
        page.alternativeHandler = { (item:PageBulletinItem) in
            item.manager?.dismissBulletin()
        }
        return page
    }
}
