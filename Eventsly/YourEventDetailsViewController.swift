//
//  YourEventDetailsViewController.swift
//  Eventsly
//
//  Created by Keith Toh on 3/2/22.
//

import Foundation
import UIKit
import MapKit
import FirebaseDatabase

class YourEventDetailsViewController: UIViewController {
    
    var selectedEvent:Event = Event(id: "", name: "", type: "", desc: "", pax: 0, datetime: "", address: "", host_name: "", num_attendees: 0)
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let regionRadius: CLLocationDistance = 1000
    
    var prevAnnotation = MKPointAnnotation()
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblHost: UILabel!
    @IBOutlet weak var lblAttendees: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion (
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get all events hosted by user
        let ref = Database.database().reference()
        ref.child("Event").observe(.value, with: { (snapshot) in
            
            var eventList:[Event] = []
            
            for event in snapshot.children.allObjects as! [DataSnapshot] {
                 
                if (event.hasChildren())
                {
                    let dict = event.value as! [String: AnyObject]

                    let host_name = dict["host_name"] as! String
                    if (host_name == self.appDelegate.loggedinUser.name)
                    {
                        let id = dict["id"] as! String
                        let name = dict["name"] as! String
                        let type = dict["type"] as! String
                        let desc = dict["desc"] as! String
                        let pax = dict["pax"] as! String
                        let datetime = dict["date"] as! String
                        let address = dict["address"] as! String
                        let num_attendees = dict["num_attendees"] as! String

                        let newEvent = Event(id: id, name: name, type: type, desc: desc, pax: Int(pax) ?? 0, datetime: datetime, address: address, host_name: host_name, num_attendees: Int(num_attendees) ?? 0)
                        
                        eventList.append(newEvent)
                    }
                }
            }
            
            // data of selected event hosted by user from Your Events page
            self.selectedEvent = eventList[self.appDelegate.selectedYourEvent]
            
            // set event id to appDelegate to view attendees
            self.appDelegate.selectedYourEventID = self.selectedEvent.id
            
            //formatter to format the display date in the label.
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let dateObject = formatter.date(from: self.selectedEvent.datetime)!
            
            formatter.dateFormat = "HH:mm E, d MMM y"
            let displayDate:String = formatter.string(from: dateObject)
            
            // insert details of event to view
            self.lblName.text = "\(self.selectedEvent.name)"
            self.lblDate.text = "Date & Time: \(displayDate)"
            self.lblDesc.text = "\(self.selectedEvent.desc)"
            self.lblHost.text = "Host: \(self.selectedEvent.host_name)"
            self.lblAttendees.text = "Attendees: \(self.selectedEvent.num_attendees)/\(self.selectedEvent.pax)"
            self.lblAddress.text = "\(self.selectedEvent.address)"
            
            // display pin on location map
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(
                self.selectedEvent.address,
                completionHandler: {p,e in
                    if (p != nil)
                    {
                        self.centerMapOnLocation(location: p![0].location!)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate.latitude = p![0].location!.coordinate.latitude
                        annotation.coordinate.longitude = p![0].location!.coordinate.longitude
                        annotation.title = self.selectedEvent.name
                        annotation.subtitle = self.selectedEvent.id
                        self.map.addAnnotation(annotation)
                    }
                })
        })
    }
    
}
