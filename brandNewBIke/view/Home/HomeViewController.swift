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

class HomeViewController: UIViewController{

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var refreshLocationButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var rideButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomsheetView: UIView!
    var navigationViewController: NavigationViewController!
    var viewModel: HomeViewModel = HomeViewModel()
    let regionRadius: CLLocationDistance = 500
    let locationManager: CLLocationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    lazy var bulletinManager : BulletinManager = {
        return BulletinManager(rootItem : viewModel.getCurrentPage())
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
        
        self.setupSideMenu()
        bottomsheetView.layer.cornerRadius = 10.0
        bottomsheetView.layer.borderColor = UIColor.lightGray.cgColor
        bottomsheetView.layer.borderWidth = 0.5
        self.bindRx()
        self.initLocationService()
        self.viewModel.fetchSession()
        //bottomsheetView.clipsToBounds = true
        // Do any additional setup after loading the view.
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
            self.bulletinManager.prepare()
            self.bulletinManager.presentBulletin(above: self)
        }.disposed(by: self.disposeBag)
       
        self.refreshLocationButton.rx.tap.subscribe{ event in
            
        }.disposed(by: self.disposeBag)
        
        self.viewModel.outputs.bottomSheetItem.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (item) in
                self.bulletinManager.prepare()
                self.bulletinManager.push(item: item)
                self.bulletinManager.presentBulletin(above: self)
                print("Presented")
                
            }, onError: { (error) in
                print(error)
            }, onCompleted: {}, onDisposed: {}).disposed(by: self.disposeBag)
        
        self.viewModel.outputs.instructionAction.subscribe{ item in
            print("tap")
            self.openScanner()
        }.disposed(by: self.disposeBag)
        
        self.viewModel.outputs.bikeList.subscribe(onNext: { (bikeList) in
            print("incoming bikeList")
            self.addMarker(bikeList: bikeList)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.outputs.bikeOperationStatus.observeOn(MainScheduler.instance).subscribe(onNext: { (bikeStatus) in
            switch bikeStatus {
            case .BORROW_COMPLETED:
                self.rideButton.setTitle("RETURN", for: UIControlState.normal)
                break
            case .RETURN_COMPLETED:
                self.rideButton.setTitle("RIDE", for: UIControlState.normal)
                self.stopTracking()
                self.bulletinManager.prepare()
                let newPage = self.viewModel.loadReturnSuccessPage()
                self.bulletinManager.push(item: newPage)
                self.bulletinManager.presentBulletin(above: self)
                self.viewModel.isTracking = false
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
}


