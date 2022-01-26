//
//  EventDetailsViewController.swift
//  Eventsly
//
//  Created by Keith Toh on 1/2/22.
//

import Foundation
import UIKit
import MapKit
import FirebaseDatabase

class EventDetailsViewController: UIViewController {
    
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
        ref.child("Event").observe(.value, with: { (snapshot) in
            
            var eventList:[Event] = []
            
            for event in snapshot.children.allObjects as! [DataSnapshot] {
                 
                let dict = event.value as! [String: AnyObject]

                let id = dict["id"] as! String
                let name = dict["name"] as! String
                let type = dict["type"] as! String
                let desc = dict["desc"] as! String
                let pax = dict["pax"] as! Int
                let date = dict["date"] as! String
                let address = dict["address"] as! String
                let host_name = dict["host_name"] as! String
                let num_attendees = dict["num_attendees"] as! Int

                let newEvent = Event(id: id, name: name, type: type, desc: desc, pax: pax, date: date, address: address, host_name: host_name, num_attendees: num_attendees)

                eventList.append(newEvent)
            }
            
            self.selectedEvent = eventList[self.appDelegate.selectedEvent]
            
            self.lblName.text = "\(self.selectedEvent.name)"
            self.lblDate.text = "Date: \(self.selectedEvent.date)"
            self.lblDesc.text = "\(self.selectedEvent.desc)"
            self.lblHost.text = "Host: \(self.selectedEvent.host_name)"
            self.lblAttendees.text = "Attendees: \(self.selectedEvent.num_attendees)/\(self.selectedEvent.pax)"
            self.lblAddress.text = "\(self.selectedEvent.address)"
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(
                self.selectedEvent.address,
                completionHandler: {p,e in
                    self.centerMapOnLocation(location: p![0].location!)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate.latitude = p![0].location!.coordinate.latitude
                    annotation.coordinate.longitude = p![0].location!.coordinate.longitude
                    annotation.title = self.selectedEvent.name
                    annotation.subtitle = self.selectedEvent.id
                    self.map.addAnnotation(annotation)
                })
            
        })
        
    }
    
    
    @IBAction func btnJoin(_ sender: Any) {
        if (selectedEvent.num_attendees < selectedEvent.pax)
        {
            let alertViewTrue = UIAlertController(
                title: "Confirmation",
                message: "Do you confirm to join this event?",
                preferredStyle: UIAlertController.Style.alert)

            alertViewTrue.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in }))
            
            alertViewTrue.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { [self] _ in
                
                let alertViewConfirm = UIAlertController(
                    title: "Event Joined",
                    message: "You have joined this event",
                    preferredStyle: UIAlertController.Style.alert)

                alertViewConfirm.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { _ in
                    
                    selectedEvent.num_attendees = selectedEvent.num_attendees + 1
                    let ref = Database.database().reference()
                    guard let key = ref.child("Event").childByAutoId().key else { return }
                    // update Event num_attendees
                    let postEvent = ["id": selectedEvent.id,
                                "name": selectedEvent.name,
                                "type": selectedEvent.type,
                                "desc": selectedEvent.desc,
                                "pax": selectedEvent.pax,
                                "date": selectedEvent.date,
                                "address": selectedEvent.address,
                                "host_name": selectedEvent.host_name,
                                "num_attendees": selectedEvent.num_attendees] as [String : Any]
                    let childUpdatesEvent = ["Event/\(selectedEvent.id)/": postEvent]
                    ref.updateChildValues(childUpdatesEvent)
                    
                    // update UserJoined events id
                    let postJoined = ["id": selectedEvent.id, "name": selectedEvent.name] as [String : Any]
                    let childUpdatesJoined = ["Joined/\(appDelegate.loggedinUser.name)/\(selectedEvent.id)": postJoined]
                    ref.updateChildValues(childUpdatesJoined)
                    
                    self.tabBarController?.selectedIndex = 3
                }))

                self.present(alertViewConfirm, animated: true, completion: nil)
                
                }))

            self.present(alertViewTrue, animated: true, completion: nil)
        }
        else
        {
            let alertViewFalse = UIAlertController(
                title: "Maximum Number of Pax Reached",
                message: "This event has reached its maximum pax limit. You will not be able to join this event.",
                preferredStyle: UIAlertController.Style.alert)

            alertViewFalse.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler: { _ in }))

            self.present(alertViewFalse, animated: true, completion: nil)
        }
    }
    
}