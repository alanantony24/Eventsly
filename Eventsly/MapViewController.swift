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
    
    var locationAndEventDict:[String:String] = [:]
    
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
            let lat = String(format: "Lat(CurrentLoc): %3.8f", location.coordinate.latitude)
            let long = String(format: "Long(CurrentLoc): %3.8f", location.coordinate.longitude)
            print("\(lat), \(long)")
            
            //self.centerMapOnLocation(location: location)

            self.map.showsUserLocation = true
        }
        
        database.child("Event").observeSingleEvent(of: .value, with: { snapshot in
            guard let dataDict = snapshot.value as? [String:Any] else {
                return
            }
            
            var event:[String:Any]
            var address:String
            var eventName:String = "Event Name"
            
            for (key,value) in dataDict{
                
                event = dataDict[key] as! [String:Any]
                
                address = event["address"] as! String
                
                eventName = event["name"] as! String
                
                self.locationAndEventDict[eventName] = address
                
                self.GeoCoder(locEventDict: self.locationAndEventDict)
            }
        })
    }
    
    func GeoCoder(locEventDict:[String:String]){
        
        let geoCoder = CLGeocoder()
        
        var annotationList:[MKAnnotation] = []
        for (key, value) in locEventDict{
            geoCoder.geocodeAddressString(value) { p, e in
                let lat = String(
                    format: "Lat (Address): %3.12f", p![0].location!.coordinate.latitude)
                let long = String(
                    format: "Lat (Address): %3.12f", p![0].location!.coordinate.latitude)
                print("\(lat), \(long)")
                let locationPin:CLLocation = CLLocation(latitude:p![0].location!.coordinate.latitude, longitude: p![0].location!.coordinate.longitude)
                
               
                let annotation = MKPointAnnotation()
                annotation.coordinate = locationPin.coordinate
                annotation.title = key
                annotationList.append(annotation)
                print(annotationList.count)
                self.map.addAnnotations(annotationList)
            }
        }
    }
}
