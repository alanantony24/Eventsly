//
//  DiscoverViewController.swift
//  Eventsly
//
//  Created by Keith Toh on 1/2/22.
//

import Foundation
import UIKit
import FirebaseDatabase

class DiscoverViewController: UITableViewController {
    
    var eventList:[Event] = []
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

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
            
            self.eventList = eventList
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
        return eventList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverEvent", for: indexPath)
        
        let event:Event = eventList[indexPath.row]
        
        cell.textLabel!.text = "\(event.id): \(event.name)"
        cell.detailTextLabel!.text = "Type: \(event.type)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.selectedEvent = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Events"
    }

}