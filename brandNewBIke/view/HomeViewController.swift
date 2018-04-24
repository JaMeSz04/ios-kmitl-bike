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

class HomeViewController: UIViewController {

    @IBOutlet weak var refreshLocationButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var rideButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomsheetView: UIView!
    private var viewModel: HomeViewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    private let regionRadius: CLLocationDistance = 500
    lazy var bulletinManager : BulletinManager = {
        return BulletinManager(rootItem : viewModel.getRootBottomSheet())
    }()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomsheetView.layer.cornerRadius = 10.0
        bottomsheetView.layer.borderColor = UIColor.lightGray.cgColor
        bottomsheetView.layer.borderWidth = 0.5
        self.bindRx()
        
        //bottomsheetView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bindRx(){
        self.rideButton.rx.tap.subscribe{ event in
            self.viewModel.inputs.bottomSheetPageRequest.onNext(())
        }.disposed(by: self.disposeBag)
        self.viewModel.getLatestLocation()
        self.viewModel.outputs.location.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (location) in
                let userLocation = CLLocation(latitude : location.latitude, longitude: location.longitude)
                self.centerMapOnLocation(location: userLocation)
            }, onError: { (error) in
                print(error)
            }, onCompleted: {}, onDisposed: {}).disposed(by: self.disposeBag)
        
        self.viewModel.outputs.bottomSheetItem.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (item) in
                self.bulletinManager.prepare()
                self.bulletinManager.presentBulletin(above: self)
            }, onError: { (error) in
                print(error)
            }, onCompleted: {}, onDisposed: {}).disposed(by: self.disposeBag)
        
        self.viewModel.outputs.instructionAction.subscribe{ item in
            print("tap")
            self.openScanner()
        }.disposed(by: self.disposeBag)
        
    }
}

extension HomeViewController: MKMapViewDelegate, QRCodeReaderViewControllerDelegate {
    
    func openScanner(){
        
        self.bulletinManager.dismissBulletin()
        
        readerVC.delegate = self
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print(result)
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    func showBulletin(){
        bulletinManager.prepare()
        bulletinManager.presentBulletin(above: self)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print("qr result")
        print(result.value)
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}

