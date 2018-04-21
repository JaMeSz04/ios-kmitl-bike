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
        return BulletinManager(rootItem : HomeViewModel.getRootButtomSheet())
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
    
    override func viewDidAppear(_ animated: Bool) {
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bindRx(){
        self.rideButton.rx.tap.subscribe{ event in
            self.showBulletin()
        }.disposed(by: self.disposeBag)
        self.viewModel.getLatestLocation()
        self.viewModel.location.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (location) in
                let userLocation = CLLocation(latitude : location.latitude, longitude: location.longitude)
                self.centerMapOnLocation(location: userLocation)
            }, onError: { (error) in
                print("ERROR get user location")
                print(error)
            }, onCompleted: {}, onDisposed: {}).disposed(by: self.disposeBag)
        
    }
}

extension HomeViewController: MKMapViewDelegate {
    
    func showBulletin(){
        bulletinManager.prepare()
        bulletinManager.presentBulletin(above: self)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

