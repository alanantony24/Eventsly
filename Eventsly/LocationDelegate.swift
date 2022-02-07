//
//  LocationDelegate.swift
//  Eventsly
//
//  Created by Alan Antony on 27/1/22.
//  This class is the LocationDelegate, contatining methods that are relevant with events from a Location Manager object.

import Foundation
import CoreLocation

class LocationDelegate: NSObject, CLLocationManagerDelegate{
    var locationCallback: ((CLLocation) -> ())? = nil
    
    //This function tells the delegate that new location information is available.
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        //Gets the last known location information.
        guard let currentLocation = locations.last else { return }
        locationCallback?(currentLocation)
    }
}
