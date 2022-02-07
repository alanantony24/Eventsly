//
//  HomeViewController.swift
//  Eventsly
//
//  Created by Alan Antony on 18/1/22.
//  This class controls the actions done in the Home Page of the application.

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    //Initialize the AppDelegate and Welcome label to display the welcome message.
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var lblWelcome: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Getting the current logged in user.
        let user = Auth.auth().currentUser
        if let user = user {
            let db = Firestore.firestore()
            
            //Getting the details of the user from the FireStore Database.
            db.collection("users").whereField("uid", isEqualTo: user.uid).getDocuments() { (QuerySnapshot, err) in
                if let err = err {
                    print("error getting docs: \(err)")
                } else {
                    for document in QuerySnapshot!.documents {
                        let data = document.data()
                        let name = data["name"] as? String ?? ""
                        let username = data["username"] as? String ?? ""
                        let phone = data["phNo"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        
                        //Setting the User object in AppDelegate to the user data obtained from the database.
                        let loggedinUser:User = User(name: name, username: username, password: "", email: email, phone: Int32(phone) ?? 0)
                        self.appDelegate.loggedinUser = loggedinUser
                        
                        //Setting the welcome label message to "Welcome, [user's name]"
                        self.lblWelcome.text = "Welcome, \(name)!"
                    }
                }
            }
        }
    }
}
