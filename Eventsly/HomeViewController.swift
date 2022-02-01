//
//  HomeViewController.swift
//  Eventsly
//
//  Created by MAD2 on 18/1/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var lblWelcome: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: user.uid).getDocuments() { (QuerySnapshot, err) in
                if let err = err {
                    print("error getting docs: \(err)")
                } else {
                    for document in QuerySnapshot!.documents {
                        let data = document.data()
                        let name = data["name"] as? String ?? ""
                        let username = data["username"] as? String ?? ""
                        let phone = data["phNo"] as? Int32 ?? 0
                        
                        let loggedinUser:User = User(name: name, username: username, password: "", email: "", phone: phone)
                        self.appDelegate.loggedinUser = loggedinUser
                        
                        self.lblWelcome.text = "Welcome, \(name)!"
                    }
                }
            }
        }
        
        
    }
    
    

}
