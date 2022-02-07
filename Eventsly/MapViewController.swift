//
//  MapViewController.swift
//  Eventsly
//
//  Created by Alan Antony on 27/1/22.
//

import Foundation
import UIKit
import MapKit
import FirebaseDatabase

class MapViewController:UIViewController, MKMapViewDelegate{
    
    //Initialize the MKMapView object, FireBase Realtime database, and other variables.
    @IBOutlet weak var map: MKMapView!
    private let database = Database.database().reference()
    let regionRadius:CLLocationDistance = 4000
    let locationDelegate = LocationDelegate()
    var latestLocation:CLLocation? = nil
    
    //LocationManager is declared, the arguements are set so as to get the most accuract current location of the user.
    let locationManager:CLLocationManager = {
        $0.requestAlwaysAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //From the Realtime Database, get the values such as Event Name, Address, and Event ID. This will be used to add annotations to the MapView.
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
                    
                    //Adding the list of locations to a List object. This list object will later be iterated to get the Location Coordinates using the GeoCoder.
                    locationList.append(address)
                }
            }
            print("LocationList :  \(locationList.count)")
        })
        
        //This is to get the last location from the LocationDelegate and get it's corresponding Coordinates.
        locationManager.delegate = locationDelegate
        locationDelegate.locationCallback = { location in
            self.latestLocation = location
            let lat = String(format: "Lat(CurrentLoc): %3.8f", location.coordinate.latitude)
            let long = String(format: "Long(CurrentLoc): %3.8f", location.coordinate.longitude)
            print("\(lat), \(long)")
            
            //self.centerMapOnLocation(location: location)
            
            //Shows the current user location as a blue marker on the MapView.
            self.map.showsUserLocation = true
        }
    }
    
    //The GeoCoder function takes in the following parameters, converts the location string to a location object, then gets the coordinates of the CLLocation and adds an annotation on that cetain location and displays it on the map.
    func GeoCoder(address:String, eventName:String, id:String){
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { p, e in
            if (p != nil)
            {
                //P is a location. The address string must be a correct address for the GeoCoder to convert it to a CLLocation object.
                let annotation = MKPointAnnotation()
                annotation.coordinate.latitude = p![0].location!.coordinate.latitude
                annotation.coordinate.longitude = p![0].location!.coordinate.longitude
                
                //Annotation is added to the map, title is set to EventName and subtitle is set to EventID.
                annotation.title = eventName
                annotation.subtitle = id
                self.map.addAnnotation(annotation)
            }
        }
    }
    
    //This function is to center the map to a specific location and zoom in according to the radius specified via the parameter. Th higher the regionRadius, the lower the map will be zoomed in.
    func centerMapOnLocation(location:CLLocation){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius
        )
        map.setRegion(coordinateRegion, animated: true)
    }
}
