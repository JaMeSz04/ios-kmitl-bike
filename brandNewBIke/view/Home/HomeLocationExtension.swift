//
//  HomeLocationExtension.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/13/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension HomeViewController: CLLocationManagerDelegate {
    func initLocationService(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("new location")
        
        let newLocation = Location(lat: locations[0].coordinate.latitude, long: locations[0].coordinate.longitude)
        if !self.viewModel.isTracking {
            self.viewModel.inputs.refreshBikeLocation.onNext(newLocation)
        } else if self.viewModel.latestLocation.latitude != newLocation.latitude ||  self.viewModel.latestLocation.longitude != newLocation.longitude {
            self.addPolyLine(begin: CLLocation(latitude: self.viewModel.latestLocation.latitude, longitude: self.viewModel.latestLocation.longitude), end: locations[0])
            self.viewModel.inputs.onLocationUpdate.onNext(newLocation)
        }
        self.centerMapOnLocation(location: locations[0])
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // 1. user enter region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter region")
    }
    
    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit region")
    }
    
    func startTracking(){
        print("dismiss!!!")
        self.bulletinManager.prepare()
        self.bulletinManager.dismissBulletin()
        //locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking(){
        locationManager.stopUpdatingLocation()
    }
}
