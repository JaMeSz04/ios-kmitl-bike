//
//  HomeViewController.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/20/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import BulletinBoard
import UIKit
import RxSwift
import RxCocoa
import MapKit
import QRCodeReader
import SideMenu
import UserNotifications

class HomeViewController: UIViewController{

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var refreshLocationButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var rideButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomsheetView: UIView!
    @IBOutlet weak var buttomsheetBlurView: UIVisualEffectView!
    var sideBarNavigationController: NavigationViewController!
    var viewModel: HomeViewModel = HomeViewModel()
    let regionRadius: CLLocationDistance = 500
    let locationManager: CLLocationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    lazy var bulletinManager : BulletinManager = {
        return BulletinManager(rootItem : viewModel.getCurrentPage())
    }()
    lazy var returnBulletinManager : BulletinManager = {
        return BulletinManager(rootItem : viewModel.loadTrackingPage())
    }()
    lazy var statusBulletinManager : BulletinManager = {
        return BulletinManager(rootItem : viewModel.loadReturnSuccessPage())
    }()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.reader.stopScanningWhenCodeIsFound = true
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.bulletinManager.backgroundViewStyle = .blurredDark
        UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
            if error != nil {
                print("por mung die e sus")
            }
        })
        self.mapView.delegate = self
        self.mapView.showsCompass = false
        self.mapView.showsUserLocation = true
        //self.mapView.userTrackingMode = true
        self.setupSideMenu()
        bottomsheetView.layer.cornerRadius = 15.0
        bottomsheetView.layer.borderColor = UIColor.lightGray.cgColor
        bottomsheetView.layer.borderWidth = 0.5
        self.bindRx()
        self.initLocationService()
        self.viewModel.fetchSession()
        self.setupData()

        //bottomsheetView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.buttomsheetBlurView.layer.cornerRadius = 15.0
        self.buttomsheetBlurView.layer.borderColor = UIColor.lightGray.cgColor
        self.buttomsheetBlurView.layer.borderWidth = 0.5
    }
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bindRx(){
        
        self.menuButton.rx.tap.subscribe{ event in
            self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
        
        self.rideButton.rx.tap.subscribe{ event in
            let manager = self.getBulletinManager()
            manager.prepare()
            manager.presentBulletin(above: self)
        }.disposed(by: self.disposeBag)
       
        self.refreshLocationButton.rx.tap.subscribe{ event in
            self.locationManager.requestLocation()
        }.disposed(by: self.disposeBag)
        
        self.refreshButton.rx.tap.subscribe{ event in
            self.viewModel.getBikeLocation()
            }.disposed(by: self.disposeBag)
        
        self.viewModel.outputs.bottomSheetItem.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (item) in
                let manager = self.getBulletinManager()
                manager.prepare()
                manager.push(item: item)
                manager.presentBulletin(above: self)
                print("Presented")
                
            }).disposed(by: self.disposeBag)
        
        self.viewModel.outputs.instructionAction.subscribe{ item in
            print("tap")
            self.openScanner()
        }.disposed(by: self.disposeBag)
        
        self.viewModel.outputs.bikeList.subscribe(onNext: { (bikeList) in
            print("incoming bikeList")
            self.clearMarkers()
            self.addMarker(bikeList: bikeList)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.outputs.bikeOperationStatus.observeOn(MainScheduler.instance).subscribe(onNext: { (bikeStatus) in
            print(bikeStatus)
            switch bikeStatus {
            case .BORROW_COMPLETED:
                self.rideButton.setTitle("RETURN", for: UIControlState.normal)
                UNUserNotificationCenter.current().add(NotificationFactory.createLastMinuteReturnWarning(lastMinute: 5)) { (error) in
                    if error != nil {
                        print("ERROR GEOFENCING NOTIFICATION")
                    }
                }
                self.clearMarkers()
                break
            case .RETURN_COMPLETED:
                self.rideButton.setTitle("RIDE", for: UIControlState.normal)
                self.returnBulletinManager.dismissBulletin()
                self.stopTracking()
                self.statusBulletinManager.prepare()
                self.statusBulletinManager.push(item: self.viewModel.loadReturnSuccessPage())
                self.statusBulletinManager.presentBulletin(above: self)
                self.viewModel.isTracking = false
                self.viewModel.getBikeLocation()
                break
            case .TRACKING:
                print("tracking start!!!")
                self.startTracking()
                break
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        
    }
    
    func getBulletinManager() -> BulletinManager {
        if self.viewModel.isTracking{
            return self.returnBulletinManager
        } else {
            return self.bulletinManager
        }
    }
    
    
}


