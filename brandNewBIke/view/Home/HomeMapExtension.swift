//
//  HomeMapExtension.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/13/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import MapKit


extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        if self.viewModel.isTracking {
            return MKAnnotationView(annotation: annotation, reuseIdentifier: "poly pin")
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "bike pin")
        annotationView.image = UIImage(named: "bikeLocationIcon")
        annotationView.transform = CGAffineTransform(scaleX: 2.2, y: 2.2)
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline){
            return MKPolylineRenderer(overlay: overlay)
        }
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.darkGray
        circleRenderer.fillColor = UIColor(red: CGFloat(0.2), green: CGFloat(0.2), blue: CGFloat(0.2), alpha: CGFloat(0.1))
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    func addMarker(bikeList: [Bike]){
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let annotations = bikeList.map { bike -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: bike.latitude!, longitude: bike.longitude!)
            annotation.title = bike.bike_model
            return annotation
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func addPolyLine(begin: CLLocation, end: CLLocation){
        let lines = [begin.coordinate,end.coordinate]
        let polyLine = MKPolyline(coordinates: lines, count: 2)
        self.mapView.add(polyLine)
    }
    
    func clearMarkers(){
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setupData() {
        // 1. check if system can monitor regions
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let title = "Available Area"
            let coordinate = CLLocationCoordinate2DMake(Constants.GEO_LOCATION.latitude, Constants.GEO_LOCATION.longitude)
            let regionRadius = 600.0
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                                         longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoring(for: region)
            let circle = MKCircle(center: coordinate, radius: regionRadius)
            self.mapView.add(circle)
        }
        else {
            print("System can't track regions")
        }
    }
    
    
}
