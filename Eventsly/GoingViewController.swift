//
//  GoingViewController.swift
//  Eventsly
//
//  Created by Keith Toh on 1/2/22.
//

import Foundation
import UIKit
import FirebaseDatabase

class GoingViewController: UITableViewController {
    
    var goingEventList:[Event] = []
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        ref.child("Joined").child(appDelegate.loggedinUser.name).observe(.value, with: { (snapshot) in
            
            var goingEventList:[Event] = []
            
            for joined in snapshot.children.allObjects as! [DataSnapshot] {
                 
                let dict = joined.value as! [String: AnyObject]

                let eventID = dict["id"] as! String
                let eventName = dict["name"] as! String
                
                let goingEvent:Event = Event(id: eventID, name: eventName, type: "", desc: "", pax: 0, date: "", time: "", address: "", host_name: "", num_attendees: 0)
                
                goingEventList.append(goingEvent)
            }
            
            self.goingEventList = goingEventList
            self.tableView.reloadData()
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goingEventList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsGoing", for: indexPath)
                
        let event:Event = goingEventList[indexPath.row]
        
        cell.textLabel!.text = "\(event.name)"
        cell.detailTextLabel!.text = "ID: \(event.id)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.selectedGoingEvent = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Events You Are Going"
    }
    
}

