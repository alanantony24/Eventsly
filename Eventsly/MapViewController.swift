//
//  MapViewController.swift
//  Eventsly
//
//  Created by MAD2 on 27/1/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController:UIViewController{
    
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius:CLLocationDistance = 1000
    
    func centerMapOnLocation(location:CLLocation){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius
        )
        map.setRegion(coordinateRegion, animated: true)
    }
    
    let annotation = MKPointAnnotation()
    
    let locationDelegate = LocationDelegate()
    
    var latestLocation:CLLocation? = nil
    
    let locationManager:CLLocationManager = {
        $0.requestAlwaysAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = locationDelegate
        locationDelegate.locationCallback = { location in
            self.latestLocation = location
            let lat = String(format: "Lat: %3.8f", location.coordinate.latitude)
            let long = String(format: "Long: %3.8f", location.coordinate.longitude)
            print("\(lat), \(long)")
            
            self.centerMapOnLocation(location: location)
            self.annotation.coordinate = location.coordinate
            self.annotation.title = "Me"
            self.annotation.subtitle = "My current location"
            self.map.addAnnotation(self.annotation)
            self.map.showsUserLocation = true
        }
    }
    
}
