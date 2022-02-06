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
    
    let regionRadius:CLLocationDistance = 4000
    
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
        
        database.child("Event").observe(.value, with: { (snapshot) in
            
            var locationList:[String] = []
            
            for event in snapshot.children.allObjects as! [DataSnapshot] {
                 
                if (event.hasChildren())
                {
                    let dict = event.value as! [String: AnyObject]

                    let eventName = dict["name"] as! String
                    let address = dict["address"] as! String
                    let id = dict["id"] as! String

                    self.GeoCoder(address: address, eventName: eventName, id: id)
                    locationList.append(address)
                }
            }
            
            print("LocationList :  \(locationList.count)")
        })
        
        locationManager.delegate = locationDelegate
        locationDelegate.locationCallback = { location in
            self.latestLocation = location
            let lat = String(format: "Lat(CurrentLoc): %3.8f", location.coordinate.latitude)
            let long = String(format: "Long(CurrentLoc): %3.8f", location.coordinate.longitude)
            print("\(lat), \(long)")
            
            //self.centerMapOnLocation(location: location)

            self.map.showsUserLocation = true
        }
        
//        database.child("Event").observeSingleEvent(of: .value, with: { snapshot in
//            guard let dataDict = snapshot.value as? [String:Any] else {
//                return
//            }
//
//            var event:[String:Any]
//            var address:String
//            var eventName:String = "Event Name"
//
//            for (key,value) in dataDict{
//
//                event = dataDict[key] as! [String:Any]
//
//                address = event["address"] as! String
//
//                eventName = event["name"] as! String
//
//                self.locationAndEventDict[eventName] = address
//
//                self.GeoCoder(locEventDict: self.locationAndEventDict)
//            }
//        })
    }
    
    func GeoCoder(address:String, eventName:String, id:String){
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { p, e in
            if (p != nil)
            {
                let annotation = MKPointAnnotation()
                annotation.coordinate.latitude = p![0].location!.coordinate.latitude
                annotation.coordinate.longitude = p![0].location!.coordinate.longitude
                annotation.title = eventName
                annotation.subtitle = id
                self.map.addAnnotation(annotation)
            }
        }
    
    }
    
    func centerMapOnLocation(location:CLLocation){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius
        )
        map.setRegion(coordinateRegion, animated: true)
    }
}
