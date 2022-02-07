//
//  AttendeesViewController.swift
//  Eventsly
//
//  Created by Keith Toh on 7/2/22.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseFirestore

class AttendeesViewController: UITableViewController {
    
    var attendeeList:[String] = []
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var aList:[String] = []
        
        // get list of all users and their name
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let userName = data["name"] as? String ?? ""
                    
                    let ref = Database.database().reference()
                    ref.child("Joined").child(userName).observe(.value, with: { (snapshot) in
                        for joined in snapshot.children.allObjects as! [DataSnapshot] {

                            let dict = joined.value as! [String: AnyObject]

                            let eventID = dict["id"] as! String
                            
                            // check if user joined event
                            if (eventID == self.appDelegate.selectedYourEventID)
                            {
                                aList.append(userName)
                            }

                        }
                        self.attendeeList = aList
                        self.tableView.reloadData()
                    })
                }
                                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendeeList.count
    }

    // populate table cells with event details
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendeesCell", for: indexPath)

        let user:String = attendeeList[indexPath.row]

        cell.textLabel!.text = "\(user)"

        return cell
    }

    // populate table header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (attendeeList.count == 0)
        {
            return "This event does not have any attendees currently"
        }
        else
        {
            return "Name of attendees"
        }
    }

}

