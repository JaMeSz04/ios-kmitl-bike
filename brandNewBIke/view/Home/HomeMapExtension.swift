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
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
        annotationView.image = UIImage(named: "bikeLocationIcon")
        annotationView.transform = CGAffineTransform(scaleX: 2.2, y: 2.2)
        return annotationView
    }
    
    func addMarker(bikeList: [Bike]){
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let annotations = bikeList.map { bike -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: bike.latitude, longitude: bike.longitude)
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
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
}
