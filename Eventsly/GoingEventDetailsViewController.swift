//
//  GoingEventDetailsViewController.swift
//  Eventsly
//
//  Created by Keith Toh on 1/2/22.
//

import Foundation
import UIKit
import MapKit
import FirebaseDatabase

class GoingEventDetailsViewController: UIViewController {
    
    var selectedEvent:Event = Event(id: "", name: "", type: "", desc: "", pax: 0, date: "", address: "", host_name: "", num_attendees: 0)
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let regionRadius: CLLocationDistance = 1000
    
    var prevAnnotation = MKPointAnnotation()
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblHost: UILabel!
    @IBOutlet weak var lblAttendees: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion (
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        ref.child("Joined").child(appDelegate.loggedinUser.name).observe(.value, with: { (snapshot) in
            
            var goingEventList:[Event] = []
            
            for joined in snapshot.children.allObjects as! [DataSnapshot] {
                 
                let dict = joined.value as! [String: AnyObject]

                let eventID = dict["id"] as! String
                let eventName = dict["name"] as! String
                
                let goingEvent:Event = Event(id: eventID, name: eventName, type: "", desc: "", pax: 0, date: "", address: "", host_name: "", num_attendees: 0)
                
                goingEventList.append(goingEvent)
            }
            
            let selectedEventID = goingEventList[self.appDelegate.selectedGoingEvent].id
            ref.child("Event").child(selectedEventID).observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                
                let name = value?["name"] as? String ?? ""
                let type = value?["type"] as? String ?? ""
                let desc = value?["desc"] as? String ?? ""
                let pax = value?["pax"] as? Int ?? 0
                let date = value?["date"] as? String ?? ""
                let address = value?["address"] as? String ?? ""
                let host_name = value?["host_name"] as? String ?? ""
                let num_attendees = value?["num_attendees"] as? Int ?? 0
                
                let goingEventDetail:Event = Event(id: selectedEventID, name: name, type: type, desc: desc, pax: pax, date: date, address: address, host_name: host_name, num_attendees: num_attendees)
                
                self.lblName.text = "\(goingEventDetail.name)"
                self.lblDate.text = "Date: \(goingEventDetail.date)"
                self.lblDesc.text = "\(goingEventDetail.desc)"
                self.lblHost.text = "Host: \(goingEventDetail.host_name)"
                self.lblAttendees.text = "Attendees: \(goingEventDetail.num_attendees)/\(goingEventDetail.pax)"
                self.lblAddress.text = "\(goingEventDetail.address)"
                
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(
                    goingEventDetail.address,
                    completionHandler: {p,e in
                        let lat = String(
                            format: "Lat: %3.12f", p![0].location!.coordinate.latitude)
                        let long = String(
                            format: "Long: %3.12f", p![0].location!.coordinate.longitude)

                        print("Address - \(lat), \(long)")
                        
                        self.centerMapOnLocation(location: p![0].location!)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate.latitude = p![0].location!.coordinate.latitude
                        annotation.coordinate.longitude = p![0].location!.coordinate.longitude
                        annotation.title = goingEventDetail.name
                        annotation.subtitle = goingEventDetail.id
                        self.map.addAnnotation(annotation)
                    })
            })
        })
    }
}

