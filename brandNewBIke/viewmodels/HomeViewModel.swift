//
//  HomeViewModel.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/20/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import BulletinBoard
import RxSwift
import SwiftLocation



protocol HomeViewModelInputs {
    var bottomSheetPageRequest: PublishSubject<Void> { get }
    var refreshBikeLocation: PublishSubject<Location> { get }
    var scannerBikeUpdate: PublishSubject<String> { get }
    var onLocationUpdate: PublishSubject<Location> { get }
}

protocol HomeViewModelOutputs {
    var location: PublishSubject<Location> { get }
    var bottomSheetItem: PublishSubject<PageBulletinItem> { get }
    var instructionAction: PublishSubject<PageBulletinItem> { get }
    var bikeList: PublishSubject<[Bike]> { get }
    var resetBulletin: PublishSubject<Void> { get }
    var bikeOperationStatus: PublishSubject<BikeStatus> { get }
}

protocol HomeViewModelType {
    var inputs : HomeViewModelInputs { get }
    var outputs : HomeViewModelOutputs { get }
}

class HomeViewModel: HomeViewModelType, HomeViewModelInputs, HomeViewModelOutputs {
    
    
    let disposeBag = DisposeBag()
    var location: PublishSubject<Location>
    var inputs : HomeViewModelInputs { return self }
    var outputs : HomeViewModelOutputs { return self }
    var locationRequest: PublishSubject<Bool>
    var bottomSheetPageRequest: PublishSubject<Void>
    var refreshBikeLocation: PublishSubject<Location>
    var onLocationUpdate: PublishSubject<Location>
    var resetBulletin: PublishSubject<Void>
    var scannerBikeUpdate: PublishSubject<String>
    var bottomSheetItem: PublishSubject<PageBulletinItem>
    var instructionAction: PublishSubject<PageBulletinItem>
    var bikeList: PublishSubject<[Bike]>
    var bikeOperationStatus: PublishSubject<BikeStatus>
    let bulletinFactory: BulletinFactory = BulletinFactory()
    
    private var internalBikeList:[Bike]
    private var currentPage: PageBulletinItem!
    private var bluetoothUtil: BluetoothClient!
    private var manualUtil: ManualClient!
    public var latestLocation: Location!
    public var isTracking: Bool = false
    public var currentSession: Session!
    //private var thankyouPage: PageBulletinItem
    
    init() {
        Locator.requestAuthorizationIfNeeded()
        location = PublishSubject<Location>()
        locationRequest = PublishSubject<Bool>()
        bottomSheetPageRequest = PublishSubject<Void>()
        refreshBikeLocation = PublishSubject<Location>()
        onLocationUpdate = PublishSubject<Location>()
        resetBulletin = PublishSubject<Void>()
        bottomSheetItem = PublishSubject<PageBulletinItem>()
        instructionAction = PublishSubject<PageBulletinItem>()
        scannerBikeUpdate = PublishSubject<String>()
        bikeOperationStatus = PublishSubject<BikeStatus>()
        bikeList = PublishSubject<[Bike]>()
        internalBikeList = [Bike]()
        
        currentPage = getRootBottomSheet()

        bottomSheetPageRequest.observeOn(MainScheduler.instance).subscribe(onNext: { () in
            self.bottomSheetItem.onNext(self.getBottomSheet())
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            
        }).disposed(by: self.disposeBag)
        
        refreshBikeLocation.observeOn(MainScheduler.instance).subscribe(onNext: { (location) in
            self.latestLocation = location
        }).disposed(by: self.disposeBag)
        
        scannerBikeUpdate.observeOn(MainScheduler.instance).subscribe { (scannerCode) in
            self.onScannerCompleted(code: scannerCode.element!)
        }.disposed(by: self.disposeBag)
        
        onLocationUpdate.subscribe(onNext: { (location) in
            print("location updated tracking")
            Api.updateLocation(location: location).observeOn(MainScheduler.instance).subscribe({ (response) in
                print("location updated at : " + String(location.latitude) + " : " + String(location.longitude))
                self.latestLocation = location
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: self.disposeBag)
        
        self.bluetoothUtil = BluetoothClient(subject: self.bikeOperationStatus)
        self.manualUtil = ManualClient(subject: self.bikeOperationStatus)
        self.getBikeLocation()
        
//        thankyouPage = PageBulletinItem(title: "Thank you for using KMITL Bike")
//        thankyouPage.descriptionText("You can submit your feedback via KMITL Bike Facebook page!")
//        thankyouPage.actionButtonTitle("Got it")
//        thankyouPage.actionHandler{ (item:PageBulletinItem) in
//
//        }
    }
    
    
    public func getCurrentPage() -> PageBulletinItem {
        return self.currentPage
    }
    
    private func onScannerCompleted(code: String) {
        if self.isTracking {
            self.validateReturn(code: code)
            print("done")
        } else {
            let bike = self.getBikeFromCode(code: code)
            print("found bike: " + bike.bike_name)
            self.bottomSheetItem.onNext(self.loadBikeInfoPage(bike: bike))
        }
    }
    
    private func validateReturn(code: String){
        if self.currentSession.bike.barcode == code {
            let util: ReturnProtocol = self.createUtil(model: self.currentSession.bike.bike_model) as! ReturnProtocol
            util.returnBike(bike: self.currentSession.bike, location: self.latestLocation).subscribe(onSuccess: { (returnResponse) in
                print(returnResponse)
                self.bikeOperationStatus.onNext(BikeStatus.CONNECTED_SERVER)
                util.performReturn(bike: self.currentSession.bike)
            }) { (error) in
                print(error)
            }.disposed(by: self.disposeBag)
            print("pass")
        } else {
            print("qrcode mismatch!!!!")
        }
    }
    
    private func loadBikeInfoPage(bike: Bike) -> PageBulletinItem {
        
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
    
    private func loadBorrowSuccessPage(password: String?) -> PageBulletinItem {
        let page = PageBulletinItem(title: "All set")
        if password != nil {
            page.descriptionText = "The password is " + password!
        }
        page.actionButtonTitle = "Start using the bike"
        page.actionHandler = { (item:PageBulletinItem) in
            item.manager?.dismissBulletin()
            //self.resetBulletin.onNext(())
            self.isTracking = true
            self.bikeOperationStatus.onNext(BikeStatus.TRACKING)
      
        }
        page.isDismissable = true
        page.interfaceFactory.tintColor = .black
        self.currentPage = page
        return page
    }
    
    private func getBikeAsset(model: String) -> String {
        switch model {
        case Constants.GIANT_ESCAPE:
            return "giantEscape"
        case Constants.LA_BIKE_GREEN:
            return "LABikeGreen"
        default:
            return ""
        }
    }
    
    private func borrowBike(bike: Bike) {
        print("borrow " + bike.bike_name)
        let borrowUtil = self.createUtil(model: bike.bike_model) as! BorrowProtocol
        let nonce = Int(Double(NSDate.timeIntervalSinceReferenceDate) / 1000)
        self.bikeOperationStatus.subscribe(onNext: { bikeStatus in
            switch bikeStatus {
            case .BORROW_COMPLETED:
                self.currentPage.displayNextItem()
                print("COMPLETED")
                break
            default:
                print(bikeStatus.description)
            }
        }).disposed(by: self.disposeBag)
        borrowUtil.borrow(bike: bike, planId: 2, location: self.latestLocation, nonce: nonce)
            .subscribe(onSuccess: { (session) in
                print(session)
                self.currentSession = session
            }).disposed(by: self.disposeBag)
    }
    
    private func createUtil(model: String) -> BikeOperationProtocol {
        switch model {
        case Constants.GIANT_ESCAPE:
            return self.bluetoothUtil
        default:
            return self.manualUtil
        }
    }
    
    
    private func getBikeLocation(){
        Api.getBikeList().observeOn(MainScheduler.instance).subscribe(onSuccess: { (bikeList) in
            self.bikeList.onNext(bikeList)
            self.internalBikeList = bikeList
        }) { (error) in
            print(error)
            }.disposed(by: self.disposeBag)
    }
    
    private func getBikeFromCode(code:String) -> Bike {
        return self.internalBikeList.filter{ bike in bike.barcode == code }[0]
    }
    
    public func getBottomSheet() -> PageBulletinItem {
        return self.bulletinFactory.getPageItem()
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
    
}


