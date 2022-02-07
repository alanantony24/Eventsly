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
    
    var selectedEvent:Event = Event(id: "", name: "", type: "", desc: "", pax: 0, datetime: "", address: "", host_name: "", num_attendees: 0)
    var userJoinedEvent:Bool = false
    let ref = Database.database().reference()
    
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
    @IBOutlet weak var joinBtn: UIButton!
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion (
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get all events from db
        let ref = Database.database().reference()
        ref.child("Event").observe(.value, with: { (snapshot) in
            
            var eventList:[Event] = []
            
            for event in snapshot.children.allObjects as! [DataSnapshot] {
                 
                let dict = event.value as! [String: AnyObject]

                let id = dict["id"] as! String
                let name = dict["name"] as! String
                let type = dict["type"] as! String
                let desc = dict["desc"] as! String
                let pax = dict["pax"] as! String
                let datetime = dict["date"] as! String
                let address = dict["address"] as! String
                let host_name = dict["host_name"] as! String
                let num_attendees = dict["num_attendees"] as! String

                let newEvent = Event(id: id, name: name, type: type, desc: desc, pax: Int(pax) ?? 0, datetime: datetime, address: address, host_name: host_name, num_attendees: Int(num_attendees) ?? 0)

                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = formatter.date(from: datetime)!
                let currentDate = Date()
                
                if date > currentDate{
                    eventList.append(newEvent)
                }
            }
            
            // get data of selected event from Discover page
            self.selectedEvent = eventList[self.appDelegate.selectedEvent]
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let dateObject = formatter.date(from: self.selectedEvent.datetime)!
            
            formatter.dateFormat = "HH:mm E, d MMM y"
            let displayDate:String = formatter.string(from: dateObject)
            
            // insert event details to view
            self.lblName.text = "\(self.selectedEvent.name)"
            self.lblDate.text = "Date & Time: \(displayDate)"
            self.lblDesc.text = "\(self.selectedEvent.desc)"
            self.lblHost.text = "Host: \(self.selectedEvent.host_name)"
            self.lblAttendees.text = "Attendees: \(self.selectedEvent.num_attendees)/\(self.selectedEvent.pax)"
            self.lblAddress.text = "\(self.selectedEvent.address)"
            
            //check if user joined event
            let ref = Database.database().reference()
            ref.child("Joined").child(self.appDelegate.loggedinUser.name).observe(.value, with: { (snapshot) in

                for joined in snapshot.children.allObjects as! [DataSnapshot] {

                    let dict = joined.value as! [String: AnyObject]

                    let eventID = dict["id"] as! String

                    if(eventID == self.selectedEvent.id)
                    {
                        //Change colour and text of Join Button
                        self.joinBtn.setTitle("Joined", for: .normal)
                        self.joinBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                        self.joinBtn.isEnabled = false
                        
                        let alertViewJoined = UIAlertController(
                            title: "Event Joined",
                            message: "You have joined this event already.",
                            preferredStyle: UIAlertController.Style.alert)

                        alertViewJoined.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler: { _ in
                            self.userJoinedEvent = true
                        }))

                        self.present(alertViewJoined, animated: true, completion: nil)
                    }

                }

            })
            
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
    
    
    @IBAction func btnJoin(_ sender: Any) {
        
        //check if user is host
        if (appDelegate.loggedinUser.name == self.selectedEvent.host_name)
        {
            let alertViewError = UIAlertController(
                title: "Joining Own Event",
                message: "This event hosted by yourself. You will not be able to join this event.",
                preferredStyle: UIAlertController.Style.alert)

            alertViewError.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler: { _ in }))

            self.present(alertViewError, animated: true, completion: nil)
        }
        
        //check for attendees limit
        if (self.selectedEvent.num_attendees < self.selectedEvent.pax && self.userJoinedEvent == false)
        {
            let alertViewTrue = UIAlertController(
                title: "Confirmation",
                message: "Do you confirm to join this event?",
                preferredStyle: UIAlertController.Style.alert)

            alertViewTrue.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in }))
            
            alertViewTrue.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { [self] _ in
                    
                selectedEvent.num_attendees = selectedEvent.num_attendees + 1
                let ref = Database.database().reference()

                // update Event num_attendees
                let postEvent = ["id": selectedEvent.id,
                                 "name": selectedEvent.name,
                                 "type": selectedEvent.type,
                                 "desc": selectedEvent.desc,
                                 "pax": String(selectedEvent.pax),
                                 "date": selectedEvent.datetime,
                                 "address": selectedEvent.address,
                                 "host_name": selectedEvent.host_name,
                                 "num_attendees": String(selectedEvent.num_attendees)] as [String : Any]
                let childUpdatesEvent = ["Event/\(selectedEvent.id)/": postEvent]
                ref.updateChildValues(childUpdatesEvent)
                
                // update User Joined events id
                let postJoined = ["id": selectedEvent.id, "name": selectedEvent.name] as [String : Any]
                let childUpdatesJoined = ["Joined/\(appDelegate.loggedinUser.name)/\(selectedEvent.id)": postJoined]
                ref.updateChildValues(childUpdatesJoined)
                                                        
                let alertViewConfirm = UIAlertController(
                    title: "Event Joined",
                    message: "You have joined this event",
                    preferredStyle: UIAlertController.Style.alert)

                alertViewConfirm.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { _ in
                
                    self.tabBarController?.selectedIndex = 3
                    
                }))
                
                self.present(alertViewConfirm, animated: true, completion: nil)

            }))

            self.present(alertViewTrue, animated: true, completion: nil)
        }
        else if (self.userJoinedEvent == true) // if user already joined selected event
        {
            let alertViewJoined = UIAlertController(
                title: "Event Joined",
                message: "You have joined this event already.",
                preferredStyle: UIAlertController.Style.alert)

            alertViewJoined.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler: { _ in }))

            self.present(alertViewJoined, animated: true, completion: nil)
        }
        else // if max pax limit reached for selected event
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
