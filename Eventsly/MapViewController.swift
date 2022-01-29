//
//  MapViewController.swift
//  Eventsly
//
//  Created by MAD2 on 27/1/22.
//

import Foundation
import UIKit
import MapKit
import FirebaseDatabase

class MapViewController:UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var map: MKMapView!
    
    private let database = Database.database().reference()
    
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
        
        database.child("Event").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                return
            }
            print("Value : \(value["address"]!)")
            
            let geoCoder = CLGeocoder()
            
            geoCoder.geocodeAddressString(value["address"]! as! String) { p, e in
                let lat = String(
                    format: "Lat: %3.12f", p![0].location!.coordinate.latitude)
                
                let long = String(
                    format: "Lat: %3.12f", p![0].location!.coordinate.latitude)
                
                print("\(lat), \(long)")
                
                var locationPin:CLLocation = CLLocation(latitude:p![0].location!.coordinate.latitude, longitude: p![0].location!.coordinate.longitude)
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = locationPin.coordinate
                annotation.title = "Ngee Ann Polytechnic"
                annotation.subtitle = "School of ICT"
                self.map.addAnnotation(annotation)
            }
        })
    }
    
}
